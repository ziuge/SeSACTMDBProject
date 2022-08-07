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

    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castTableView.delegate = self
        castTableView.dataSource = self
        
        fetchCast(id: id)
        fetchMovie(id: id)
    }
    
    func fetchCast(id: String) {
        CastAPIManager.shared.fetchData(id: id) { id, list in
            cast = list
//            print("cast", self.cast)
        }
    }
    
    func fetchMovie(id: String) {
        MovieAPIManager.shared.fetchMovieData(id: id) { list in
            self.movie = list[0]
//            print("movie", self.movie)
            self.configure()
        }
    }
    
    func configure() {
        let backURL = URL(string: EndPoint.tmdbPosterURL + movie["backdrop_path"]!)
        backgroundImageView.kf.setImage(with: backURL)
        
        let posterURL = URL(string: EndPoint.tmdbPosterURL + movie["poster_path"]!)
        posterImageView.kf.setImage(with: posterURL)
        
        titleLabel.text = movie["title"]
        titleLabel.textColor = UIColor(.white)
        titleLabel.font = .boldSystemFont(ofSize: 16)
    }
    
}

extension CastTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cast.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
    
        cell.configureCell(index: indexPath.row)
        
        
        return cell
    }
    
}
