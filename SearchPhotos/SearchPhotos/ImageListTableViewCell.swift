//
//  ImageListTableViewCell.swift
//  SearchPhotos
//
//  Created by Kapil.kumar on 17/05/20.
//  Copyright © 2020 Kapil.kumar. All rights reserved.
//

import UIKit

class ImageListTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoDescription: UILabel!
    
    override func prepareForReuse() {
          photoDescription.text = nil
          photoImageView.image = nil
    }
    
}
