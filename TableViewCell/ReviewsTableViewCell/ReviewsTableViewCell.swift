//
//  ReviewsTableViewCell.swift
//  rollTest
//
//  Created by Botan Amedi on 22/01/2021.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var Nmae: UILabel!
    @IBOutlet weak var Comment: UITextView!
    @IBOutlet weak var Date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.Imagee.layer.cornerRadius = self.Imagee.bounds.width / 2
        self.Imagee.layer.borderColor = UIColor.black.cgColor
        self.Imagee.layer.borderWidth = 0.5
        
    }
    func parseName(_ fullDate: String) -> (String) {
        let components = fullDate.split(separator: " ", maxSplits: 1).map(String.init)
        return (components.first ?? "")
    }
    func update(_ cell : CommentObject){
        self.Nmae.text = cell.name
        self.Comment.text = cell.comment
        self.Date.text = self.parseName(cell.date)
        self.Imagee.image = UIImage(named: "333")
    }
    
}
