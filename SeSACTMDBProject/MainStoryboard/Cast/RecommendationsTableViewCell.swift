//
//  RecommendationsTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/10.
//

import UIKit

class RecommendationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    func setupUI() {
        recommendationsCollectionView.collectionViewLayout = collectionViewLayout()
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        return layout
    }
}
