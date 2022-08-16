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
        
        UserDefaults.standard.set(true, forKey: "First")
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 77/255, green: 106/255, blue: 120/255, alpha: 1)]
        title = "TMDB"
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        collectionView.prefetchDataSource = self
        collectionView.collectionViewLayout = collectionViewLayout()
        
        fetch()
    }
    
    @IBAction func listBtn(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mapBtn(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var list: [[String: Any]] = []
    var id = ""
    
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
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - spacing
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return layout
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

// MARK: - CollectionView
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
        
        let id = self.list[indexPath.item]["id"] as! String
        var videoURL = ""
        VideoAPIManager.shared.fetchData(id: id) { id, video, site in
            if site == "YouTube" {
                videoURL = "https://www.youtube.com/watch?v=" + video
            } else if site == "Vimeo" {
                videoURL = "https://vimeo.com/" + video
            } else {
                print("site", site)
            }
        }
        
        cell.addActionHandler = {
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            
            vc.modalPresentationStyle = .overFullScreen
            vc.destinationURL = videoURL
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CastTableViewController") as! CastTableViewController
        
        vc.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        let id = list[indexPath.row]["id"] as! String
        vc.id = id
        vc.fetchCast(id: id)
        vc.fetchMovie(id: id)
        
    }
    
}
