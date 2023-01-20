//
//  CastTableViewController.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/06.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

var cast: [[String: String]] = []

class CastTableViewController: UIViewController {
    
    var movie: [String: String] = [:]
    var id: String = "0"
    var overview: String = "Overview here"
    var recommend: [[String: String]] = []
    var similar: [[String: String]] = []
    
    var isExpanded = false

    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castTableView.delegate = self
        castTableView.dataSource = self
        castTableView.rowHeight = UITableView.automaticDimension
        
        castTableView.register(UINib(nibName: "CastOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "CastOverviewTableViewCell")
        
        fetchCast(id: id)
        fetchMovie(id: id)
        fetchRecommendations(id: id)
        fetchSimilar(id: id)
    }
    
    // MARK: Fetch Data
    func fetchCast(id: String) {
        CastAPIManager.shared.fetchData(id: id) { id, list in
            cast = list
            self.castTableView.reloadData()
        }
    }

    func fetchMovie(id: String) {
        MovieAPIManager.shared.fetchMovieData(id: id) { list in
            self.movie = list[0]
            self.overview = list[0]["overview"]!
            self.configure()
            self.castTableView.reloadData()
        }
    }
    
    func fetchRecommendations(id: String) {
        RecommendationsAPIManager.shared.fetchData(id: id) { id, list in
            self.recommend = list
            self.castTableView.reloadData()
        }
    }
    
    func fetchSimilar(id: String) {
        SimilarAPIManager.shared.fetchData(id: id) { id, list in
            self.similar = list
            self.castTableView.reloadData()
        }
    }
    
    func configure() {
        print(movie)
        let backURL = URL(string: EndPoint.tmdbPosterURL + movie["backdrop_path"]!)
        backgroundImageView.kf.setImage(with: backURL)
        
        let posterURL = URL(string: EndPoint.tmdbPosterURL + movie["poster_path"]!)
        posterImageView.kf.setImage(with: posterURL)
        
        titleLabel.text = movie["title"]
        titleLabel.textColor = UIColor(.white)
        titleLabel.font = .boldSystemFont(ofSize: 18)
    }

}

// MARK: - TableView
extension CastTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return cast.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "OverView"
        } else if section == 1 {
            return "Cast"
        } else if section == 2 {
            return "Recommendations"
        } else {
            return "Similar Movies"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            return 86
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastOverviewTableViewCell", for: indexPath) as? CastOverviewTableViewCell else { return UITableViewCell() }
            cell.overviewLabel.text = overview
            cell.overviewLabel.numberOfLines = isExpanded ? 0 : 2
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
            cell.configureCell(index: indexPath.row)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationsTableViewCell", for: indexPath) as? RecommendationsTableViewCell else { return UITableViewCell() }
            
            cell.recommendationsCollectionView.delegate = self
            cell.recommendationsCollectionView.dataSource = self
            cell.recommendationsCollectionView.tag = indexPath.section
            cell.recommendationsCollectionView.register(UINib(nibName: "RecommendationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommendationsCollectionViewCell")
            cell.recommendationsCollectionView.reloadData()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            isExpanded = !isExpanded
            tableView.reloadData()
        }
    }
}

// MARK: - CollectionView
extension CastTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? recommend.count : similar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationsCollectionViewCell", for: indexPath) as? RecommendationsCollectionViewCell else { return UICollectionViewCell() }

        if collectionView.tag == 2 {
            guard let poster = recommend[indexPath.row]["poster_path"] else { return cell }
            let url = URL(string: "\(EndPoint.tmdbPosterURL)\(poster)")
            cell.posterView.posterImageView.kf.setImage(with: url)
        } else {
            guard let poster = similar[indexPath.row]["poster_path"] else { return cell }
            let url = URL(string: "\(EndPoint.tmdbPosterURL)\(poster)")
            cell.posterView.posterImageView.kf.setImage(with: url)
        }
        
//        cell.posterView.posterImageView.backgroundColor = .systemMint
        cell.posterView.posterImageView.contentMode = .scaleAspectFill
        
        return cell
    }
}
