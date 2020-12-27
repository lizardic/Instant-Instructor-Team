//
//  MessageViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 10/12/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

struct MessageViewModel {
    private let message: Message
    
    var messageBackgroundColor: UIColor { return message.isFromCurrentUser ? .systemGray6 : .white }
    
    var messageBorderWidth: CGFloat { return message.isFromCurrentUser ? 0 : 1.0 }
    
    var rightAnchorActive: Bool { return message.isFromCurrentUser  }
    
    var leftAnchorActive: Bool {  return !message.isFromCurrentUser }
    
    var shouldHideProfileImage: Bool { return message.isFromCurrentUser }
    
    var messageText: String { return message.text }
    
    var username: String { return message.username }
    
    var profileImageUrl: URL? { return URL(string: message.profileImageUrl) }
    
    var timestampString: String? {
        guard let date = message.timestamp else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(message: Message) {
        self.message = message
    }
}
