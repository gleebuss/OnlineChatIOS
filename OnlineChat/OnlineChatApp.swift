//
//  OnlineChatApp.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 23.04.2024.
//

import SwiftUI
import FirebaseCore

@main
struct OnlineChatApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
