//
//  SearchViewController.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/03.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        fetch()
        
    }
    
    var list: [[String: String]] = []
    
    var startPage = 1
    var totalCount = 0
    
    func fetch() {
//        let url = EndPoint.tmdbURL + "/movie/week?api_key=" + APIKey.TMDB_SECRET
        let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(APIKey.TMDB_SECRET)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print( "JSON: \(json)")
                
                self.totalCount = json["total_results"].intValue
                
                for item in json["results"].arrayValue {
                    self.list.append(["poster": item["poster_path"].stringValue,
                                     "release": item["release_date"].stringValue,
                                      "title": item["title"].stringValue,
                                     "overview": item["overview"].stringValue])
                }
                
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: "https://api.themoviedb.org/3/trending/movie/week?api_key=\(APIKey.TMDB_SECRET)" + list[indexPath.item]["poster"]!)
        cell.imageView.kf.setImage(with: url!)
        cell.titleLabel.text = list[indexPath.item]["title"]
        cell.dateLabel.text = list[indexPath.item]["release"]
//        cell.genreLabel.text = list[]
//        cell.actorLabel.text = list[indexPath.item][""]
        
        
//        cell.backgroundColor = .lightGray
        
        print("list", list)
        
        return cell
    }
    
}
