//
//  IGConstants.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 04/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import Foundation

struct IGConstants {
    struct Services {
        static let baseURL = "https://api.flickr.com/services/rest/"
        static let apiKey = "6f102c62f41998d151e5a1b48713cf13"
    }
    struct ErrorStrings {
        static let timeOutError = "The request timed out."
        static let noInternetConnection = "The Internet connection appears to be offline."
        static let networkConnectionLost = "The network connection was lost."
        static let undefinedError = "Some error occured. Please try again!"
    }
    
    struct ViewController {
        static let IGImageSelectViewController = "ig_imageSelect_view_controller"
    }
    
    struct Storyboards {
        static let IGHome = "IGHome"
        static let IGImageSelect = "IGImageSelect"
    }
    
    struct Nibs {
        static let IGImageCollectionViewCell = "IGImageCollectionViewCell"
        static let IGLoadingSpinnerCollectionViewCell = "IGLoadingSpinnerCollectionViewCell"
    }
    
    
}
