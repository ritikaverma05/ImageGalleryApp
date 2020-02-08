//
//  IGApiService.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 04/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ReachabilitySwift

class IGApiService {
    static var alamofireManager: Session?
    
    class func reachabilityError () -> IGError {
        return IGError(statusCode:0, message:IGConstants.ErrorStrings.noInternetConnection)
    }
    
    class func isReachable() -> Bool {
           do {
            let reachability = Reachability(hostname: IGConstants.Services.baseURL)
               if reachability!.isReachable {
                   return true
               }
           }
           return false
       }
    
    
    class func request(_ method: HTTPMethod, needLogin: Bool, url:String, params:[String: AnyObject]?, encoding: ParameterEncoding = URLEncoding.default, loginToken: String? = nil, success:((JSON?) -> Void)?, failure:((IGError) -> Void)?) {
        
        if IGApiService.isReachable() {
            let absoluteUrl: String?
            absoluteUrl = url
//            let headers:[String:String]?
            
            if needLogin {
                //TODO: what if token is not available
            }
            
            if alamofireManager == nil {
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 12
                configuration.timeoutIntervalForResource = 12
                alamofireManager = Alamofire.Session(configuration: configuration)
            }
            alamofireManager!.request(absoluteUrl!, method: method, parameters: params, encoding: encoding, headers: nil).validate()
                .responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        if let value = response.value  {
                            let json = JSON(value)
                            print("----====success json====----")
                            print(json)
                            print("----====end of success json====----")
                            success?(json)
                        }
                    case .failure:
                        guard response.response != nil else {
                            failure?(IGError(statusCode: 0, message: IGConstants.ErrorStrings.undefinedError))
                            return
                        }
                        
                        if response.response!.statusCode >= 200 && response.response!.statusCode < 300  {
                            print(response)
                            success?(nil)
                        } else {
                            print("----====response data and error====----")
                            print(response.data ?? "nil", response.error ?? "nil")
                            print("----====end of response data and error====----")
                            if let responseError = response.error {
                                var error: IGError?
                                if responseError.localizedDescription == IGConstants.ErrorStrings.timeOutError {
                                    
                                    // Handling timout
                                    error = IGError(statusCode: 408, message: responseError.localizedDescription)
                                    
                                } else if responseError.localizedDescription == IGConstants.ErrorStrings.noInternetConnection {
                                    
                                    // Handling No Internet
                                    error = IGError(statusCode: 4, message: responseError.localizedDescription)
                                    
                                } else if responseError.localizedDescription == IGConstants.ErrorStrings.networkConnectionLost {
                                    
                                    // Handling Lost Connection
                                    error = IGError(statusCode: -1005, message: responseError.localizedDescription)
                                    
                                } else {
                                    print("handling error")
                                    // Handling all other Errors
                                    let jsonString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) as String?
                                    
                                    if jsonString == nil{
                                        error = IGError(statusCode: -1, message: IGConstants.ErrorStrings.undefinedError)
                                    } else {
                                        let json = JSON.init(jsonString ?? "")
                                        print("----====end of MS object:====----")
                                        error = IGError(json: json)
                                    }
                                    
                                }
                                failure?(error!)
                            }
                        }
                    }
            }
        } else {
            print("DSfdsfsdfdfsfsf")
            failure?(IGApiService.reachabilityError())
        }
    }
}



