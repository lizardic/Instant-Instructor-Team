//
//  User.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/27/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Foundation
import Firebase

/** The user struct represents a user with data pulled from Firebase, namely their email/fullname/profileImageUrl/username/uid/fcmToken. Our initilizer pulls the data
    from the dictionary received from Firebase and stores it in constants/variables.
 */
struct User {
    let email: String
    var fullname: String
    var profileImageUrl: String
    var username: String
    let uid: String
    let fcmToken: String
    
    var isFollowed = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.fcmToken = dictionary["fcmToken"] as? String ?? ""
        
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
