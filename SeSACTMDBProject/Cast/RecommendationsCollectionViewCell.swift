//
//  RecommendationsCollectionViewCell.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/10.
//

import UIKit

class RecommendationsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterView: PosterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        posterView.posterImageView.layer.cornerRadius = 10
    }

}
