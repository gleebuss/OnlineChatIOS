//
//  MessageViewModel.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 12.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class MessageViewModel: ObservableObject{
    @Published var messages = [MessageModel]()
    private var db = Firestore.firestore()
    
    func sendMessage(message:String, path:String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTime = dateFormatter.string(from: Date())
        let data:[String:Any] = ["text": message, "date": currentDateTime, "sender": Auth.auth().currentUser!.uid]
        db.collection(path).addDocument(data: data)
    }
    
    func getAllMessage(path:String) {
        db.collection(path).order(by: "date", descending: false).addSnapshotListener{
            (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.messages = documents.map{ (QueryDocumentSnapshot) -> MessageModel in
                let data = QueryDocumentSnapshot.data()
                return MessageModel(dict: data)
            }
        }
    }
}

