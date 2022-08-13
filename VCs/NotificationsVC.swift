//
//  NotificationsVC.swift
//  WomanApp
//
//  Created by botan pro on 9/3/21.
//

import UIKit
import CustomLoader
class NotificationsVC: UIViewController {
    
    var Notifications : [NotificationsObject] = []
    
    @IBOutlet weak var InternetStack: UIStackView!
    
    @IBAction func TryAgain(_ sender: Any) {
        _ =  LoadingView.standardProgressBox.show(inView: self.view)
        self.GetNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.removeLoadingViews(animated: true)
        }
        if CheckInternet.Connection() == false{
            self.InternetStack.isHidden = false
            self.TableView.isHidden = true
        }else{
            self.InternetStack.isHidden = true
            self.TableView.isHidden = false
        }
    }
    
    @IBOutlet weak var TryAgain: UIButton!
    @IBOutlet weak var TableView : UITableView!{didSet{self.GetNotifications()}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.rowHeight = UITableView.automaticDimension
        TableView.estimatedRowHeight = 90
        TableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.TableView.cr.addHeadRefresh {
            self.GetNotifications()
        }
        self.TableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CheckInternet.Connection() == false{
            self.InternetStack.isHidden = false
            self.TableView.isHidden = true
        }else{
            self.InternetStack.isHidden = true
            self.TableView.isHidden = false
        }
        self.navigationController?.tabBarItem.badgeValue = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.GetNotifications()
        }
    }
    
    func GetNotifications(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.TableView.cr.endHeaderRefresh()
        }
        NotificationAPI.GetNotifications { (notifications) in
            self.Notifications = notifications
            self.TableView.reloadData()
        }
    }
}


extension NotificationsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Notifications.count == 0{
            return 0
        }
        return Notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsTableViewCell
        if self.Notifications.count != 0{
            cell.Updatee(notif: self.Notifications[indexPath.row])
        }
        return  cell
    }
    
}
