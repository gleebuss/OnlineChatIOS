//
//  RegisterView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 23.04.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var surname: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8.0)
                .padding(.horizontal)
            
            TextField("Surname", text: $surname)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8.0)
                .padding(.horizontal)
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8.0)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8.0)
                .padding(.horizontal)
            
            Button(action: {
                createUser()
            }) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8.0)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
        }
        .padding()
        .navigationTitle("Registration")
    }
    
    func createUser() {
        if (name != "" && surname != "" && email != "" && password != "") {
            Auth.auth().createUser(withEmail: email, password: password) {(res, err) in
                if err != nil {
                    print("\(err!)")
                    return
                }
                else {
                    createUserInfo()
                    presentationMode.wrappedValue.dismiss()
                    Auth.auth().currentUser!.sendEmailVerification()
                }
            }
        }
    }
    
    func createUserInfo(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let avatarUrl = "https://firebasestorage.googleapis.com/v0/b/onlinechat-e50bd.appspot.com/o/default.png?alt=media&token=5ba44ab5-c1aa-4a9f-9ec1-efc12aa599f5"
        db.collection("users").document("\(uid!)").setData(["name": name, "surname": surname, "email": email, "uid": uid!, "avatarUrl": avatarUrl])
    }
    
}


#Preview {
    RegisterView()
}
