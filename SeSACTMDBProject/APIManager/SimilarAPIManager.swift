//
//  SimilarAPIManager.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class SimilarAPIManager {
    static let shared = SimilarAPIManager()
    
    private init() { }
    
    typealias completionHandler = (String, [[String: String]]) -> Void
    
    public func fetchData(id: String, completionHandler: @escaping completionHandler) {
        let url = EndPoint.recommendationsURL + "\(id)/similar?api_key=\(APIKey.TMDB_SECRET)&language=en-US&page=1"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print( "JSON: \(json)")
                
                var list: [[String: String]] = []
                
                for item in json["results"].arrayValue {
                    list.append(["title": item["title"].stringValue,
                                 "poster_path": item["poster_path"].stringValue])
                }
//                print("similar")
                
                completionHandler(id, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
