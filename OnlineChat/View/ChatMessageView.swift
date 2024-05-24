//
//  ChatMessageView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 12.05.2024.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageView: View {
    @Binding var user: UserModel?
    @State var isShowTabBar: Bool = false
    @State private var messageInput: String = ""
    @ObservedObject private var messages = MessageViewModel()
    let uidCurrent = Auth.auth().currentUser?.uid
    var body: some View {
        VStack{
            List(messages.messages, id: \.id) { message in
                MessageBubbleView(message: message)
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
            }
        }
        .padding(.top)
        .navigationTitle(user?.getAllName() ?? "Unknown")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(PlainListStyle())
        .toolbar(!isShowTabBar ? .hidden : .visible, for: .tabBar)
        .onDisappear(){
            self.isShowTabBar = true
        }
        .onAppear(){
            let uidAnother = user?.getUid()
            let path : String = String((uidCurrent!+uidAnother!).sorted())
            self.messages.getAllMessage(path: path)
        }
        Spacer()
        HStack {
            TextField("Введите сообщение", text: $messageInput)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                .frame(maxWidth: .infinity)
            
            Button(action: {
                if (!self.messageInput.isEmpty) {
                    let uidAnother = user?.getUid()
                    let path : String = String((uidCurrent!+uidAnother!).sorted())
                    self.messages.sendMessage(message: self.messageInput, path: path)
                    self.messageInput = ""
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

//#Preview {
//    @State var user : UserModel? = UserModel(name: "Gleb", surname: "Agapov", email: "glebagapov3@gmail.com", uid: "123")
//    return ChatMessageView(user: $user)
//}
