//
//  IGError.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 04/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import Foundation
import SwiftyJSON

class IGError {
    var message:String?
    
    init(json: JSON) {
        let js = JSON(parseJSON: json.string!)
        if js["message"].string != nil {
            self.message = js["message"].string
        }
        else {
            self.message = ""
        }
    }
    
    init(statusCode:Int, message:String) {
        self.message = message
    }
}
