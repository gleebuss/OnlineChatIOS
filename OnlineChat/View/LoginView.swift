//
//  ContentView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 23.04.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var username: String = "glebagapov3@gmail.com"
    @State private var password: String = "Qwerty123"
    @State private var isLogin: Bool = false
    @State private var currentUser: UserModel?
    
    var body: some View {
        NavigationView {
            VStack {
                Image("chat_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8.0)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8.0)
                    .padding(.horizontal)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8.0)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Chat Login")
            .background(NavigationLink("", destination: MainView(user: $currentUser).navigationBarBackButtonHidden(true), isActive: $isLogin))
        }
    }
    func login() {
        Auth.auth().signIn(withEmail: username, password: password) {(res, err) in
            if err != nil {
                print("\(err!)")
                return
            }
            else {
                if Auth.auth().currentUser?.isEmailVerified == true {
                    self.isLogin = true
                    self.currentUser = UserModel(uid: Auth.auth().currentUser!.uid)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
