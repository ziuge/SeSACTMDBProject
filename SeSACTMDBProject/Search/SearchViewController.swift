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
    
    var list: [[String: Any]] = []
    
    var startPage = 1
    var totalCount = 0
    
    var genreList: [Int: String] = [:]
    
    func fetch() {
        SearchAPIManager.shared.fetchData(startPage: startPage) { totalCount, list in
            self.totalCount = totalCount
            self.list.append(contentsOf: list)
            self.collectionView.reloadData()
        }
        GenreAPIManager.shared.fetchData { list in
            self.genreList = list
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
        
        let url = URL(string: EndPoint.tmdbPosterURL + "\(list[indexPath.item]["poster"]!)")
        cell.imageView.kf.setImage(with: url!)
        cell.titleLabel.text = list[indexPath.item]["title"] as! String
        cell.dateLabel.text = list[indexPath.item]["release"] as! String
        cell.actorLabel.text = list[indexPath.item]["overview"] as! String
        print("=======genre",list[indexPath.item]["genre"] as! Int)
        let genre = list[indexPath.item]["genre"] as! Int
        cell.genreLabel.text = genreList[genre]
        
        
//        print("list", list)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CastTableViewController") as! CastTableViewController
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
//        vc.movie.append()
        MovieAPIManager.shared.fetchMovieData(id: list[indexPath.row]["id"]! as! String) { list in
            vc.movie = list
            print("====vc.movie", vc.movie)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
