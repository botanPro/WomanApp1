//
//  NewsCollectionViewCell.swift
//  WomanApp
//
//  Created by botan pro on 10/5/21.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ProfileCategory: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Imagee: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.Imagee.layer.cornerRadius = self.Imagee.bounds.width / 2
        self.Imagee.layer.borderColor = UIColor.black.cgColor
        self.Imagee.layer.borderWidth = 0.5
    }
    
    
    func update(Post :PostsObjects){
        self.Name.text = Post.name
        self.ProfileCategory.text = Post.proname
        self.date.text = Post.date
        let strUrl = "\(API.NewsImages)\(Post.post_image)";
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return  }
        let Url = URL(string: urlString)
        self.Imagee?.sd_setImage(with: Url, completed: nil)
    }

}
