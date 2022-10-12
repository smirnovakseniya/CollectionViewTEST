//
//  UnsplashResult.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 6.10.22.
//

import UIKit

struct APIResponse: Codable {
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLS
    let user: User
}

struct User: Codable {
    let username: String
}

struct URLS: Codable {
    let small: String
    let full: String
    let raw: String
    let thumb: String
    let regular: String
}

struct Image {
    let results: Result
    var paid: Bool = false
}
