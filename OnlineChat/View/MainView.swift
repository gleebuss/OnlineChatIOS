//
//  MainView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 23.04.2024.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State private var isQuited: Bool = false
    @Binding var user : UserModel?
    var body: some View {
        if self.isQuited {
            LoginView()
        }
        else {
            TabView {
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }
                
                ProfileView(isQuited: $isQuited, user: $user)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
        }
    }
}


#Preview {
    MainView(user: .constant(UserModel(name: "Gleb", surname: "Agapov", email: "glebagapov3@gmail.com", uid: "123", avatarUrl: "")))
}
