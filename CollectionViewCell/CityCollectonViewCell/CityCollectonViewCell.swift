//
//  CityCollectonViewCell.swift
//  WomanApp
//
//  Created by botan pro on 9/3/21.
//

import UIKit

class CityCollectonViewCell: UICollectionViewCell {

    @IBOutlet weak var ViewOver: UIView!
    @IBOutlet weak var SelectedCellView: UIView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.SelectedCellView.layer.cornerRadius = self.SelectedCellView.bounds.width / 2
    }
    
    
    func Update(city : CityObject){
        self.Name.text = city.Name
        let strUrl = "\(API.CityImages)\(city.Image)";
        print(city.Image)
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        let Url = URL(string: urlString)
        self.Image?.sd_setImage(with: Url, completed: nil)
    }

}
