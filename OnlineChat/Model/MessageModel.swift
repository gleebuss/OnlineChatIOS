//
//  MessageView.swift
//  OnlineChat
//
//  Created by Агапов Глеб on 12.05.2024.
//

import Foundation

class MessageModel: Hashable {
    public var id: UUID = UUID()
    
    private var text: String = ""
    private var date: String = ""
    private var sender: String = ""
    
    init(dict:[String:Any]) {
        self.text = dict["text"] as! String
        self.date = dict["date"] as! String
        self.sender = dict["sender"] as? String ?? ""
    }
    
    public func getText() -> String{
        return self.text
    }
    
    public func getDate() -> String{
        return self.date
    }
    
    public func getSender() -> String{
        return self.sender
    }
    
    public func getHoursMinutes() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self.date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date!)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.id == rhs.id
    }
}
