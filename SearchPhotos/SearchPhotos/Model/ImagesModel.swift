//
//  ImagesMdel.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import Foundation

struct ImagesModel: Codable {
    let total, totalHits: Int
    let images: [Images]
}

struct Images: Codable {
    let id: Int
    let pageURL: String
    let type: TypeEnum
    let tags: String
    let previewURL: String
    let previewWidth, previewHeight: Int
    let webformatURL: String
    let webformatWidth, webformatHeight: Int
    let largeImageURL: String
    let imageWidth, imageHeight, imageSize, views: Int
    let downloads, favorites, likes, comments: Int
    let userID: Int
    let user: String
    let userImageURL: String
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}

