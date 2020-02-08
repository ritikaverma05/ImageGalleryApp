//
//  IGImageService.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 04/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Haneke

class IGImageService {
    class func getImages(pageNo:Int, success: @escaping (_ totalPages: Int, [IGImage], _ cached: Bool) -> Void, failure: @escaping (IGError) -> Void) {
        let cache = Shared.dataCache
        cache.fetch(key: IGConstants.Services.baseURL + "/\(pageNo)/").onSuccess { (data) in
            do {
                let json = try JSON(data: data)
                var images = [IGImage]()
                for (_, subJson):(String, SwiftyJSON.JSON) in json["photos"]["photo"] {
                    images.append(IGImage(json: subJson))
                }
                success(pageNo, images, true)
            }
            catch {
                
            }
        }
        var params = [String: AnyObject]()
        params["method"] = "flickr.photos.getRecent" as AnyObject
        params["per_page"] = "10" as AnyObject
        params["page"] = pageNo as AnyObject
        params["api_key"] = IGConstants.Services.apiKey as AnyObject
        params["format"] = "json" as AnyObject
        params["nojsoncallback"] = "1" as AnyObject
        params["extras"] = "url_s" as AnyObject
        IGApiService.request(.get, needLogin: false, url: IGConstants.Services.baseURL, params: params, encoding: URLEncoding() as ParameterEncoding, loginToken: nil, success: { (json) in
            
            do {
                let encryptedData = try json!.rawData()
                cache.set(value: encryptedData, key: IGConstants.Services.baseURL + "/\(pageNo)/")
            }
            catch {
                
            }
            var images = [IGImage]()
            for (_, subJson):(String, SwiftyJSON.JSON) in json!["photos"]["photo"] {
                images.append(IGImage(json: subJson))
            }
            success(json!["photos"]["pages"].int ?? 0, images, false)
        }) { (error) in
            failure(error)
        }
    }
}


