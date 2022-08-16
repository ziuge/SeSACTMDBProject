//
//  CastAPIManager.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/07.
//

import Foundation

import Alamofire
import SwiftyJSON

class CastAPIManager {
    static let shared = CastAPIManager()
    
    private init() { }
    
    typealias completionHandler = (String, [[String: String]]) -> Void
    
    public func fetchData(id: String, completionHandler: @escaping completionHandler) {
        let url = EndPoint.creditURL +  "\(id)/credits?api_key=\(APIKey.TMDB_SECRET)&language=en-US"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print( "JSON: \(json)")
                
                var list: [[String: String]] = []
                
                for item in json["cast"].arrayValue {
                    list.append(["id": "\(item["id"].stringValue)",
                                 "name": item["name"].stringValue,
                                 "character": item["character"].stringValue,
                                 "order": "\(item["order"].intValue)",
                                 "profile": item["profile_path"].stringValue])
                }
                
                completionHandler(id, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
