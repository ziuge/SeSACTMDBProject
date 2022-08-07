//
//  CastTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/06.
//

import UIKit

class CastTableViewCell: UITableViewCell {

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureCell(index: Int) {
        if cast.count > 0 {
            print("cast not 0", cast)
            let profile = cast[index]["profile"]!
            let url = URL(string: EndPoint.tmdbPosterURL + profile)
            castImageView.kf.setImage(with: url)
            castImageView.layer.cornerRadius = 5
            characterLabel.text = cast[index]["character"]!
            nameLabel.text = cast[index]["name"]!
        } else {
            print("cast 0", cast)
        }
        
        
        
    }
    
}
