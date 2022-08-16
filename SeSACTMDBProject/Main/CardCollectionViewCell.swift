//
//  CardCollectionViewCell.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterView: PosterView!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        cellView.layer.cornerRadius = 10
        cellView.layer.masksToBounds = true
        
    }

    private func setupUI() {
        posterView.posterImageView.layer.cornerRadius = 10
        posterView.posterImageView.layer.masksToBounds = true
    }

}
