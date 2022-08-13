//
//  TabbarTableViewController.swift
//  WomanApp
//
//  Created by botan pro on 12/14/21.
//

import UIKit

class TabbarTableViewController: UITabBarController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainCategoryAPI.GetMainCategory(CityId: "1") { MainCategory in
            if UserDefaults.standard.string(forKey: "options") == "0"{
                self.viewControllers?.remove(at: 0)
            }
        }
    }

 

}
