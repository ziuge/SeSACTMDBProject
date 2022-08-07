//
//  MovieAPIManager.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/06.
//

import Foundation

import Alamofire
import SwiftyJSON

class MovieAPIManager {
    static let shared = MovieAPIManager()
    
    private init() { }
    
    typealias completionHandler = ([[String: String]]) -> Void
    
    func fetchMovieData(id: String, completionHandler: @escaping completionHandler) {
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(APIKey.TMDB_SECRET)&language=en-US"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print( "JSON: \(json)")
                
                var list: [[String: String]] = []
                
                list.append(["title": json["title"].stringValue,
                             "homepage": json["homepage"].stringValue,
                             "runtime": json["runtime"].stringValue,
                             "overview": json["overview"].stringValue])
                
//                for item in json.arrayValue[0] {
//
//                }
                
//                list.append(json.arrayValue)
//
//                completionHandler(list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
