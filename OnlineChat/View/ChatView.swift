//
//  ChatView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 09.05.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    @State private var text: String = ""
    @ObservedObject private var users = UserViewModel()
    var body: some View {
        VStack() {
            Text("Chat").bold()
            TextField("Search by name and surname", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal, 30.0)
                .multilineTextAlignment(.center)
                .onSubmit {
                    fetchUsersIfNeeded()
                }

            Spacer()
            List(users.users, id: \.id) { user in
                HStack {
                    AsyncImage(url: URL(string: user.getAvatarUrl())) {image in
                        image.image?.resizable()
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    Text(user.getAllName())
                    NavigationLink("") {
                        ChatMessageView(user: .constant(user))
                    }.opacity(0)
                }
            }.onAppear{
                fetchUsersIfNeeded()
            }
        }
    }
    
    func fetchUsersIfNeeded() {
        self.users.users.removeAll()
        if (self.text.isEmpty){
            self.users.fetchAllUsers()
        } else {
            let separatedArray = text.components(separatedBy: " ")
            print(separatedArray.count)
            guard separatedArray.count == 2 else {
                print("Error")
                return
            }
            let name = separatedArray[0]
            let surname = separatedArray[1]
            self.users.fetchUserByNameSurname(name: name, surname: surname)
        }
    }
}

//#Preview {
//    ChatView()
//}
