//
//  SearchView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 09.05.2024.
//

import SwiftUI

struct SearchView: View {
    @State private var text: String = ""
    @ObservedObject private var users = UserViewModel()
    
    var body: some View {
        VStack() {
            Text("Search").bold()
            TextField("Search by email", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal, 30.0)
                .multilineTextAlignment(.center)
                .keyboardType(.emailAddress)
                .onSubmit {fetchUsersIfNeeded()}
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
                        ProfileView(isQuited: .constant(false), user: .constant(user))
                            .navigationBarTitleDisplayMode(.inline)
                    }.opacity(0)
                }
            }
            .onAppear {fetchUsersIfNeeded()}
        }
    }
    func fetchUsersIfNeeded() {
        self.users.users.removeAll()
        if (self.text.isEmpty){
            self.users.fetchAllUsers()
        } else {
            self.users.fetchUserByEmail(email: self.text)
        }
    }
}

#Preview {
    SearchView()
}
