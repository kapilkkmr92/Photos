//
//  ImagesMdel.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import Foundation
import UIKit



struct ImagesModel: Codable {
    let total, totalHits: Int?
    let images: [Item]?
}


class Item: Codable {
    let id: Int?
    let pageURL: String?
    let type: String?
    let tags: String?
    let previewURL: String?
    let previewWidth, previewHeight: Int?
    let webformatURL: String?
    let webformatWidth, webformatHeight: Int?
    let largeImageURL: String?
    let imageWidth, imageHeight, imageSize, views: Int?
    let downloads, favorites, likes, comments: Int?
    let userID: Int?
    let user: String?
    let userImageURL: String?
    var image = UIImage(named: "Placeholder")
    var state = PhotoRecordState.new

    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, favorites, likes, comments
        case userID = "user_id"
        case user, userImageURL
    }
}
