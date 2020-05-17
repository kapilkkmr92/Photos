//
//  ImagesMdel.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import Foundation
import UIKit

struct ImagesResponse: Codable {
    let total, totalHits: Int?
    let imageItems: [ImageDetail]
    enum CodingKeys: String, CodingKey {
        case total, totalHits
        case imageItems = "hits"
    }
}

class ImageDetail: Codable {
    let previewURL: String?
    let largeImageURL: String?
    let user: String?
    var image = UIImage(named: "Placeholder")
    var state = PhotoRecordState.new
    
    enum CodingKeys: String, CodingKey {
        case previewURL,largeImageURL, user
    }
}
