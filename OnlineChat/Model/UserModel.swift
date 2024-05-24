//
//  UserModel.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 09.05.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserModel: Hashable {
    public var id: UUID = UUID()
    
    private var email: String = ""
    private var name: String = ""
    private var surname: String = ""
    private var uid: String = ""
    private var avatarUrl: String = ""
    
    init(uid: String) {
        self.uid = uid
        let db = Firestore.firestore()
        db.collection("users").document("\(uid)").getDocument(){ (document,err) in if let document = document, document.exists {
            if let data = document.data() {
                self.name = (data["name"] as? String)!
                self.email = (data["email"] as? String)!
                self.surname = (data["surname"] as? String)!
                self.avatarUrl = (data["avatarUrl"] as? String)!
            }
        }
        }
    }
    
    init(name: String, surname: String, email: String, uid: String, avatarUrl: String) {
        self.email = email
        self.name = name
        self.surname = surname
        self.uid = uid
        self.avatarUrl = avatarUrl
    }
    
    func setAvatarUrl(url: String) {
        self.avatarUrl = url
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getSurname() -> String {
        return self.surname
    }
    
    func getUid() -> String {
        return self.uid
    }
    
    func getAllName() -> String {
        return self.name + " " + self.surname
    }
    
    func getAvatarUrl() -> String {
        return self.avatarUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}
