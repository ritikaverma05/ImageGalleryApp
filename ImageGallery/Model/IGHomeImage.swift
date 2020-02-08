//
//  IGHomeImage.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 05/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import Foundation
import SwiftyJSON

class IGHomeImage {
    var pageNo:Int!
    var images = [IGImage]()
    
    init(page: Int, image: [IGImage]) {
        self.pageNo = page
        self.images = image
    }
}
