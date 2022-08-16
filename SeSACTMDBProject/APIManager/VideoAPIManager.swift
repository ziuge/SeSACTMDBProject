//
//  VideoAPIManager.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class VideoAPIManager {
    static let shared = VideoAPIManager()
    
    private init() { }
    
    typealias completionHandler = (String, String, String) -> Void
    
    public func fetchData(id: String, completionHandler: @escaping completionHandler) {
        let url = EndPoint.videoURL + id + "/videos?api_key=\(APIKey.TMDB_SECRET)&language=en-US"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print( "JSON: \(json["results"][0])")
                let video = json["results"][0]["key"].stringValue
                let site = json["results"][0]["site"].stringValue
                
                completionHandler(id, video, site)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
