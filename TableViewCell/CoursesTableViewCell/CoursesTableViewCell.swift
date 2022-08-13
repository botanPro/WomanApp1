//
//  CoursesTableViewCell.swift
//  WomanApp
//
//  Created by botan pro on 10/11/21.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Vieww: UIView!
    @IBOutlet weak var End: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Vieww.layer.shadowColor = UIColor.lightGray.cgColor
        Vieww.layer.shadowOpacity = 0.3
        Vieww.layer.shadowOffset = CGSize.zero
        Vieww.layer.shadowRadius = 3
        self.Vieww.layer.cornerRadius = 7
    }

}
