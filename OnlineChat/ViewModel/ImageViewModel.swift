//
//  ImageViewModel.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 16.05.2024.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore


class ImageViewModel: ObservableObject {
    @Published var imageUrl = URL(string: "")
    
    func getAvatarUrlByUid(uid: String){
        let avatarRef = Storage.storage().reference().child("\(uid)" + "/avatar.jpg")
        avatarRef.downloadURL { (url, _) in
            if let downloadURL = url {
                Firestore.firestore().collection("users").document("\(uid)").updateData(["avatarUrl": downloadURL.absoluteString]){ error in
                    if let error = error {
                        return
                    }
                        self.imageUrl = downloadURL
                }
            }
        }
    }
}
