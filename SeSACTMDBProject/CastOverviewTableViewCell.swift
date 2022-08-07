//
//  CastOverviewTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/07.
//

import UIKit

class CastOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var overviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        overviewLabel.font = .systemFont(ofSize: 13, weight: .medium)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
