//
//  CastTableViewController.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/06.
//

import UIKit
import SwiftyJSON

class CastTableViewController: UIViewController {
    
    var movie: [[String: String]] = []

    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castTableView.delegate = self
        castTableView.dataSource = self

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
