//
//  MainTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        titleLabel.text = "#Genre"
//        contentCollectionView.backgroundColor = .systemCyan
//        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }

    
}
