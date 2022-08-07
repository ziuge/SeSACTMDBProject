//
//  CastTableViewController.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/06.
//

import UIKit
import SwiftyJSON

class CastTableViewController: UIViewController {
    
    var cast: [[String: String]] = []
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

    }
    
    func fetchCast(id: String) {
        CastAPIManager.shared.fetchData(id: id) { id, list in
            self.cast = list
            print("==CastTableVC== fetchCast success", id)
            print("list", list)
            print("self.cast", self.cast)
            
        }
    }

}

extension CastTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
