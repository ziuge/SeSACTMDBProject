//
//  GenreAPIManager.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/06.
//

import Foundation

import Alamofire
import SwiftyJSON

class GenreAPIManager {
    static let shared = GenreAPIManager()
    
    private init() { }
    
    typealias completionHandler = ([Int: String]) -> Void
    
    public func fetchData(completionHandler: @escaping completionHandler) {
        let url = "\(EndPoint.genreURL)api_key=\(APIKey.TMDB_SECRET)&language=ko-KR"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print( "JSON: \(json)")
                
                var list: [Int: String] = [:]
                
                for item in json["genres"].arrayValue {
                    let id = item["id"].intValue
                    let name = item["name"].stringValue
                    list[id] = name
                }
                
                completionHandler(list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
