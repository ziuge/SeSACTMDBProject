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

    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castTableView.delegate = self
        castTableView.dataSource = self
        
        castTableView.register(UINib(nibName: "CastOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "CastOverviewTableViewCell")
        
        fetchCast(id: id)
        fetchMovie(id: id)
    }
    
    func fetchCast(id: String) {
        CastAPIManager.shared.fetchData(id: id) { id, list in
            cast = list
            print("fetchCast called", cast[0])
            self.castTableView.reloadData()
        }
    }
    
    func fetchMovie(id: String) {
        MovieAPIManager.shared.fetchMovieData(id: id) { list in
            self.movie = list[0]
            print("movie called", self.movie)
            self.overview = list[0]["overview"]!
            self.configure()
            self.castTableView.reloadData()
        }
    }
    
    func configure() {
        let backURL = URL(string: EndPoint.tmdbPosterURL + movie["backdrop_path"]!)
        backgroundImageView.kf.setImage(with: backURL)
        
        let posterURL = URL(string: EndPoint.tmdbPosterURL + movie["poster_path"]!)
        posterImageView.kf.setImage(with: posterURL)
        
        titleLabel.text = movie["title"]
        titleLabel.textColor = UIColor(.white)
        titleLabel.font = .boldSystemFont(ofSize: 18)
    }
    
}

extension CastTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return cast.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("section", section)
        if section == 0 {
            return "OverView"
        } else {
            return "Cast"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastOverviewTableViewCell", for: indexPath) as? CastOverviewTableViewCell else { return UITableViewCell() }
            
            cell.overviewLabel.text = overview
            
            return cell
            
            
//            let cell = CastOverviewTableViewCell()
//            self.overview = movie["overview"]
//
//            print("===overview", overview)
//            cell.overviewLabel.text = overview
//            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
            cell.configureCell(index: indexPath.row)
            
            return cell
        }
        
    }
    
}
