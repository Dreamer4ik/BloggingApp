//
//  BlogPost.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 23.12.2021.
//

import Foundation

struct BlogPost {
    let identifier: String
    let title: String
    let timestamp: TimeInterval
    let headerImageUrl: URL?
    let text: String
}
