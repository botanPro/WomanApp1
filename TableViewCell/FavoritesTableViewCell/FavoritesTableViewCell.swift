//
//  FavoritesTableViewCell.swift
//  WomanApp
//
//  Created by botan pro on 10/10/21.
//

import UIKit
import Cosmos
class FavoritesTableViewCell: UITableViewCell {
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var Cosmos: CosmosView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.Imagee.layer.cornerRadius = 6
        self.Imagee.layer.borderColor = UIColor.black.cgColor
        self.Imagee.layer.borderWidth = 0.5
    }


    func Update(profil : GetProfilesByCategoryObjects){
        self.Name.text = profil.name
        let strUrl = "\(API.profileImageURL)\(profil.image)";
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return  }
        let Url = URL(string: urlString)
        self.Imagee?.sd_setImage(with: Url, completed: nil)
        self.rate.text = profil.rate
        print(profil.rate)
        self.Cosmos.rating = Double(profil.rate) ?? 0.0
    }
}
