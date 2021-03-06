//
//  RequestManager+Extensions.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import Foundation

extension RequestManager {
    func getImagesWith(query: String, completion: CompletionHandler<ResponseType>? = nil) {
        guard let urlRequest = Endpoints.getImages.getImagesWithQuery(query: query) else { return }
        self.getData(urlRequest, completion: completion)
    }
}
