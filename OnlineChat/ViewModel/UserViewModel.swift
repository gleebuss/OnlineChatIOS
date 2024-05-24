//
//  UserViewModel.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 12.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class UserViewModel: ObservableObject{
    @Published var users = [UserModel]()
    private var db = Firestore.firestore()
    
    // Получение всех чатов пользователя
    func fetchChats(){
        let uid = Auth.auth().currentUser?.uid
        self.db.collection("users").document(uid!).collection("chats").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let tmpUid: String
                    if ((data["user1"] as! String) != uid){
                        tmpUid = data["user1"] as! String
                    }
                    else {
                        tmpUid = data["user2"] as! String
                    }
                    self.fetchUser(uid: tmpUid) {user in
                        self.users.append(user!)
                    }
                }
            }
        }
    }
    // Получение пользователя по uid
    func fetchUser(uid: String, completion: @escaping (UserModel?) -> Void) {
        self.db.collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let surname = data["surname"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let avatarUrl = data["avatarUrl"] as! String
                    let user = UserModel(name: name, surname: surname, email: email, uid: uid, avatarUrl: avatarUrl)
                    completion(user)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    //Получение пользователя по почте
    func fetchUserByEmail(email: String){
        self.db.collection("users")
            .whereField("email", isEqualTo: email)
            .getDocuments {snapshot,_ in
                guard let documents = snapshot?.documents, !documents.isEmpty, Auth.auth().currentUser?.uid != documents[0].documentID else {
                    return
                }
                self.users.removeAll()
                let data = documents[0].data()
                let user = UserModel(name: data["name"] as! String, surname: data["surname"] as! String, email: data["email"] as! String, uid: data["uid"] as! String, avatarUrl: data["avatarUrl"] as! String)
                self.users.append(user)
                
            }
    }
    
    //Получение всех пользователей
    func fetchAllUsers() {
        self.db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.documentID == Auth.auth().currentUser?.uid){ continue
                    }
                    let data = document.data()
                    let user = UserModel(name: data["name"] as! String, surname: data["surname"] as! String, email: data["email"] as! String, uid: data["uid"] as! String, avatarUrl: data["avatarUrl"] as! String)
                    self.users.append(user)
                }
            }
        }
    }
    //Получение пользователей по имени и фамилии
    func fetchUserByNameSurname(name: String, surname:String){
        self.db.collection("users")
            .whereField("name", isEqualTo: name)
            .whereField("surname", isEqualTo: surname)
            .getDocuments {snapshot,_ in
                guard let documents = snapshot?.documents, !documents.isEmpty, Auth.auth().currentUser?.uid != documents[0].documentID else {
                    return
                }
                self.users.removeAll()
                let data = documents[0].data()
                let user = UserModel(name: data["name"] as! String, surname: data["surname"] as! String, email: data["email"] as! String, uid: data["uid"] as! String, avatarUrl: data["avatarUrl"] as! String)
                self.users.append(user)
                
            }
    }
}
