//
//  SearchCollectionViewCell.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/04.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var seperateView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var linkBtn: UIButton!
    
    var addActionHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        shadow(view: shadowView)
        cellView.layer.cornerRadius = 15
        cellView.layer.masksToBounds = true
        
        linkBtn.layer.cornerRadius = 45 / 2
        
    }
    
    @IBAction func linkBtnClicked(_ sender: UIButton) {
        self.addActionHandler?()
    }
    
    // MARK: 그림자 설정
    func shadow(view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowPath = nil
        view.layer.masksToBounds = false
    }

}
