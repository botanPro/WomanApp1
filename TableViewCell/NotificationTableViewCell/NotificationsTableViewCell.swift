//
//  NotificationsTableViewCell.swift
//  AdamGroup
//
//  Created by Botan Amedi on 9/14/20.
//  Copyright © 2020 AdamGrouping. All rights reserved.
//

import UIKit


class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NotifImage: UIImageView!
    @IBOutlet weak var DateTime: UILabel!
    
    @IBOutlet weak var MainView: UIView!
    
    @IBOutlet weak var Title: UILabel!
    

    
    @IBOutlet weak var Description: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.MainView.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.MainView.layer.masksToBounds = false
        self.MainView.layer.shadowColor = UIColor.gray.cgColor
        self.MainView.layer.shadowOffset = CGSize(width: 0.0, height: 1.3)
        self.MainView.layer.shadowOpacity = 0.5

    }
    
    func Updatee(notif : NotificationsObject){
        self.Title.text = notif.title
        self.Description.text = notif.disc
        self.DateTime.text = notif.date
    }

}
