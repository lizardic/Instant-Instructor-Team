//
//  CommentService.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 9/4/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import Firebase

struct CommentService {
    
    static func uploadComment(comment: String, post: Post, user: User,
                              completion: @escaping(FirestoreCompletion)) {

        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl,
                                   "postOwnerUid": post.ownerUid]
        
        COLLECTION_POSTS.document(post.postId).collection("comments").addDocument(data: data,
                                                                             completion: completion)
        
    }
    
    static func fetchComments(forPost postID: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        let query = COLLECTION_POSTS.document(postID).collection("comments")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            
            completion(comments)
        }
    }
}
