//
//  IGImage.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 04/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import Foundation
import SwiftyJSON

class IGImage {
    var id:String!
    var owner:String!
    var url_s:String!
    
    init(json : JSON) {
        if json["url_s"].string != nil {
            self.url_s = json["url_s"].string
        }
        else {
            self.url_s = ""
        }
    }
}
