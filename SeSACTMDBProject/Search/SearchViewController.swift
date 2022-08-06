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
        collectionView.prefetchDataSource = self
        
        // collectionView layout
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
    
    // id -> genre 받아오기
    var movieList: [[String: String]] = []
    
//    func fetchId(id: String) {
//        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(APIKey.TMDB_SECRET)&language=en-US"
//        AF.request(url, method: .get).validate().responseData { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
////                print( "JSON: \(json)")
//
//                self.movieList.append(["id": json["id"].stringValue,
//                                      "genres": json["genres"][0]["name"].stringValue])
//                print("append")
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    func fetch() {
        SearchAPIManager.shared.fetchData(startPage: startPage) { totalCount, list in
            self.totalCount = totalCount
            self.list.append(contentsOf: list)

            self.collectionView.reloadData()
        }
    }
}

// MARK: Pagenation
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 1
                fetch()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
}

// MARK: CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: EndPoint.tmdbPosterURL + list[indexPath.item]["poster"]!)
        cell.imageView.kf.setImage(with: url!)
        cell.titleLabel.text = list[indexPath.item]["title"]
        cell.dateLabel.text = list[indexPath.item]["release"]
        cell.actorLabel.text = list[indexPath.item]["overview"]
//        cell.genreLabel.text = movieList[indexPath.item]["genres"]
        
//        print("list", list)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CastTableViewController") as! CastTableViewController
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
//        vc.movie.append()
        MovieAPIManager.shared.fetchMovieData(id: list[indexPath.row]["id"]!) { list in
            vc.movie = list
            print("====vc.movie", vc.movie) // 
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
