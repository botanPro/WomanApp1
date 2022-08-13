//
//  AllProfilesCollectionViewCell.swift
//  WomanApp
//
//  Created by botan pro on 9/5/21.
//

import UIKit
import Cosmos
class AllProfilesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var RateView: CosmosView!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var MainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Imagee.layer.cornerRadius = self.Imagee.bounds.width / 2
        self.Imagee.layer.borderColor = UIColor.black.cgColor
        self.Imagee.layer.borderWidth = 0.5
    }

    
    func Update(profil : GetProfilesByCategoryObjects){
        self.Name.text = profil.name
        let strUrl = "\(API.profileImageURL)\(profil.image)";
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return  }
        let Url = URL(string: urlString)
        self.Imagee?.sd_setImage(with: Url, completed: nil)
        self.Rate.text = profil.rate
        self.RateView.rating = Double(profil.rate) ?? 0.0
    }
    
    func Update(profil : GetProfilesBySubCategoryObjects){
        self.Name.text = profil.name
        let strUrl = "\(API.profileImageURL)\(profil.image)";
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return  }
        let Url = URL(string: urlString)
        self.Imagee?.sd_setImage(with: Url, completed: nil)
        self.Rate.text = profil.rate
        self.RateView.rating = Double(profil.rate) ?? 0.0
    }
    
}
