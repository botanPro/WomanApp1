//
//  MainCategoryCollectionViewCell.swift
//  WomanApp
//
//  Created by botan pro on 9/3/21.
//

import UIKit

class MainCategoryCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Image.layer.cornerRadius =  self.Image.bounds.width / 2
        self.Image.layer.borderColor = UIColor.black.cgColor
        self.Image.layer.borderWidth = 0.5
    }
    
    func Update(category : MainCategoryObjects){
        self.Name.text = category.name
        let strUrl = "\(API.CategoryImages)\(category.image)";
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        let Url = URL(string: urlString)
        self.Image?.sd_setImage(with: Url, completed: nil)
    }
    
    func Update(category : SubCategoryObjects){
        self.Name.text = category.name
        let strUrl = "\(API.CategoryImages)\(category.image)";
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        let Url = URL(string: urlString)
        self.Image?.sd_setImage(with: Url, completed: nil)
    }
}
