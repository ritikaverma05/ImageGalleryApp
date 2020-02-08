//
//  IGImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 04/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import UIKit

class IGImageCollectionViewCell: UICollectionViewCell
{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imagecell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5.0
        containerView.clipsToBounds = true
    }

}
