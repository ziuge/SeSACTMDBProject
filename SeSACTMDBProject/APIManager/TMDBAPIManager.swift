//
//  TMDBAPIManager.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

//https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
//https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
//https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1
//https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1


//struct movieGroups {
//    var group: String
//    var name: String
//    var list: [String]
//}
//
//struct movies {
//    let movies: [movieGroups] = [movieGroups(group: "popular", name: "Popular", list: <#T##[String]#>)]
//}

class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    typealias completionHandler = (String, [String]) -> Void
    
    public func callRequest(query: String, completionHandler: @escaping completionHandler ) {
        let url = "https://api.themoviedb.org/3/movie/\(query)?api_key=\(APIKey.TMDB_SECRET)&language=en-US&page=1"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print( "JSON: \(json)")
                
                var list: [String] = []
                
                for item in json["results"].arrayValue {
                    list.append(item["poster_path"].stringValue)
                }
                
                completionHandler(query, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
