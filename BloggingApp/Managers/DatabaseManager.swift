//
//  DatabaseManager.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {
        
    }
    
    public func insert(
        blogPost: BlogPost,
        user: User,
        completion: @escaping(Bool) -> Void
    ){
        
    }
    
    public func getAllPosts(
        completion: @escaping([BlogPost]) -> Void
    ){
        
    }
    
    public func getPosts(
        for user: User,
        completion: @escaping([BlogPost]) -> Void
    ){
        
    }
    
    public func insert(
        user: User,
        completion: @escaping(Bool) -> Void
    ){
        
    }
    
    
}
