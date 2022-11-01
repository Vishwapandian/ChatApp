//
//  ChatUser.swift
//  ChatApp
//
//  Created by Vishwa Pandian on 12/29/21.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    
    let uid, email, profileImageUrl, firstName, lastName, bio: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.firstName = data ["firstName"] as? String ?? ""
        self.lastName = data ["lastName"] as? String ?? ""
        self.bio = data ["bio"] as? String ?? "n/a"
    }
    
}
