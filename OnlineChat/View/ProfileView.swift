//
//  ProfileView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 09.05.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import FirebaseStorage

struct ProfileView: View {
    @Binding var isQuited: Bool
    @Binding var user: UserModel?
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isStartNewMessage: Bool = false
    @State private var selectedPhotoData: Data?
    @ObservedObject private var image: ImageViewModel = ImageViewModel()
    
    var body: some View {
        let menuItems = ContextMenu {
            Button(action: {
                self.isQuited = true
            }){
                Label("Quit", systemImage: "person.badge.minus")
            }
            Button(action: {
                self.isQuited = true
                Auth.auth().currentUser?.delete()
            }){
                Label("Delete account", systemImage: "person.slash").foregroundStyle(.red)
            }
            if (selectedItem != nil) {
                Button(action: {
                    self.user?.setAvatarUrl(url: image.imageUrl!.absoluteString)
                    image.getAvatarUrlByUid(uid: (user?.getUid())!)
                }, label: {
                    Label("Send new avatar", systemImage: "arrow.up")
                })
            }
        }
        
        let shouldShowMenu = user?.getUid() == Auth.auth().currentUser?.uid
        
        VStack() {
            VStack {
                if (shouldShowMenu) {
                    PhotosPicker(selection: $selectedItem,
                                 matching: .images,
                                 photoLibrary: .shared()){
                        AsyncImage(url: image.imageUrl) {image in
                            image.image?.resizable()
                        }
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                    }
                                 .onChange(of:selectedItem) { newItem in Task{
                                     if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                         selectedPhotoData = data
                                         uploadImage()
                                     }
                                 }
                                 }
                }
                else {
                    AsyncImage(url: image.imageUrl) {image in
                        image.image?.resizable()
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                }
                
                HStack() {
                    Text(user?.getName() ?? "Name")
                        .font(.title)
                        .bold()
                    Text(user?.getSurname() ?? "Surname")
                        .font(.title)
                        .bold()
                }
                .onAppear(){
                    self.image.imageUrl = URL(string: (user?.getAvatarUrl())!)
                }
                Text(user?.getEmail() ?? "Email")
                    .font(.subheadline)
            }.contextMenu(shouldShowMenu ? menuItems : nil)
            Spacer()
            HStack {
                if (!shouldShowMenu) {
                    NavigationLink(destination: ChatMessageView(user: .constant(user)), isActive: $isStartNewMessage, label: {
                        Button(action: {
                            let db = Firestore.firestore()
                            let uidCurrent = Auth.auth().currentUser?.uid
                            let uidAnother = user?.getUid()
                            let data: [String:Any] = ["user1": uidCurrent!, "user2": uidAnother!]
                            let nameDocument:String = String((uidCurrent!+uidAnother!).sorted())
                            
                            db.collection("users").document(uidCurrent!).collection("chats").document(nameDocument).setData(data)
                            db.collection("users").document(uidAnother!).collection("chats").document(nameDocument).setData(data)
                            self.isStartNewMessage.toggle()
                        }, label: {
                            Label("Начать чат", systemImage: "message.fill")
                        })
                    })
                }
            }
            Spacer()
        }
    }
    
    func uploadImage(){
        guard let path = user?.getUid() else { return }
        let avatarRef = Storage.storage().reference().child(path + "/avatar.jpg")
        let data = UIImage(data: selectedPhotoData!)?.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        if let data = data {
            avatarRef.putData(data, metadata: metadata)
        }
    }
}


#Preview {
    @State var user : UserModel? = UserModel(name: "Gleb", surname: "Agapov", email: "glebagapov3@gmail.com", uid: "123", avatarUrl: "")
    return ProfileView(isQuited: .constant(false), user: $user)
}
