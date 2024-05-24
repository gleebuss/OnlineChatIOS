//
//  MessageBubbleView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 13.05.2024.
//

import SwiftUI
import FirebaseAuth

struct MessageBubbleView: View {
    @State var message : MessageModel
    let uidCurrent = Auth.auth().currentUser?.uid
    var body: some View {
        HStack(){
            VStack(alignment: .leading){
                Text(message.getText()).padding(.vertical, 5)
                    .font(.body)
                Text(message.getHoursMinutes())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.footnote)
            }
            .padding(10.0)
            .background(Color.blue.opacity(0.8))
            .frame(maxWidth: 200)
            .cornerRadius(30)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: uidCurrent == message.getSender() ? .trailing : .leading)
    }
}

#Preview {
    @State var mes = MessageModel(dict: ["text": "Тест", "date": "2024-05-12 23:40:23", "sender": "me"])
    return MessageBubbleView(message: mes)
}
