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
    
    public func fetchMovieData(id: String, completionHandler: @escaping completionHandler) {
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(APIKey.TMDB_SECRET)&language=en-US"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                
                var list: [[String: String]] = []
                
                list.append(["title": json["title"].stringValue,
                             "homepage": json["homepage"].stringValue,
                             "runtime": json["runtime"].stringValue,
                             "overview": json["overview"].stringValue,
                             "backdrop_path": json["backdrop_path"].stringValue,
                             "poster_path": json["poster_path"].stringValue])
                
                completionHandler(list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
