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
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
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
    
//
//    var castList: [[String: String]] = []
//    
//    func fetchCast(id: String) {
//        CastAPIManager.shared.fetchData(id: id) { id, list in
//            self.castList = list
//            
//        }
//    }
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
        
        let title = list[indexPath.item]["title"] as! String
        let release = list[indexPath.item]["release"] as! String
        let actor = list[indexPath.item]["overview"] as! String
        let genre = list[indexPath.item]["genre"] as! Int
        
        cell.titleLabel.text = title
        cell.dateLabel.text = release
        cell.actorLabel.text = actor
        cell.genreLabel.text = genreList[genre]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CastTableViewController") as! CastTableViewController
        
        vc.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        let id = list[indexPath.row]["id"] as! String
        vc.id = id
        
    }
    
}
