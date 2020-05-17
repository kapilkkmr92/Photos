//
//  ImageDownloader.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import Foundation
import UIKit

enum PhotoRecordState {
  case new, downloaded, failed
}

class PendingOperations {
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    return queue
  }()
}

class ImageDownloader: Operation {
    var photoRecord: ImageDetail
  
  init(_ photoRecord: ImageDetail) {
    self.photoRecord = photoRecord
  }
  
  override func main() {
    
    if isCancelled {
      return
    }
    var imageData: Data?
    if let url = URL(string: photoRecord.largeImageURL ?? "") {
        imageData = try? Data(contentsOf: url)
    }
    if isCancelled {
      return
    }
    
    if let data = imageData {
      photoRecord.image = UIImage(data:data)
      photoRecord.state = .downloaded
    } else {
      photoRecord.state = .failed
      photoRecord.image = UIImage(named: "failed")
    }
  }
}
