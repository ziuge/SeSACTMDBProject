//
//  SearchAPIManager.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class SearchAPIManager {
    static let shared = SearchAPIManager()
    
    private init() { }
    
    typealias completionHandler = (Int, [[String: Any]]) -> Void
    
    public func fetchData(startPage: Int, completionHandler: @escaping completionHandler) {
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(APIKey.TMDB_SECRET)&page=\(startPage)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print( "JSON: \(json)")
                
                let totalCount = json["total_results"].intValue
                
                var list: [[String: Any]] = []
                
                for item in json["results"].arrayValue {
                    list.append(["poster": item["poster_path"].stringValue,
                                 "release": self.changeDateFormat(date: item["release_date"].stringValue),
                                "title": item["title"].stringValue,
                                 "overview": item["overview"].stringValue,
                                 "id": item["id"].stringValue,
                                 "rate": "\(item["vote_average"].doubleValue)",
                                 "genre": item["genre_ids"][0].intValue])
                }
                
                completionHandler(totalCount, list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: 날짜 형식 바꾸기
    private func changeDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let resultString = dateFormatter.string(from: date!)
        
        return resultString
    }

}
