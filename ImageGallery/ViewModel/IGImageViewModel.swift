//
//  IGImageViewModel.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 04/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import Foundation
import Haneke

class IGImageViewModel: NSObject {
    
    var delegate:IGImageViewModelProtocol? =  nil
    
    var imageSet = [IGHomeImage]()
    var totalPages:Int!
    var currentPage = 1
    var startLoading = false
    var isLoaded = false
    
    
    func loadImages(pageNo: Int) {
        currentPage = pageNo
        isLoaded = false
        IGImageService.getImages(pageNo: pageNo, success: { (totalPages, images, cached) in
            if self.isLoaded {
            }
            else {
                if self.currentPage < totalPages {
                    self.startLoading = true
                }
                else {
                    self.startLoading = false
                }
                self.totalPages = totalPages
                let newData = IGHomeImage(page: pageNo, image: images)
                self.imageSet.append(newData)
                self.delegate?.didUpdateImages()
                self.isLoaded = true
            }
        }) { (error) in
            self.delegate?.didSendError(error: error.message ?? "")
        }
        
    }
    
}


protocol IGImageViewModelProtocol {
    func didUpdateImages()
    func didSendError(error: String)
}

