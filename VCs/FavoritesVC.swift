//
//  FavoritesVC.swift
//  RealEstates
//
//  Created by botan pro on 6/14/21.
//

import UIKit
import Toast_Swift
class FavoritesVC: UIViewController {

    
    var ProductArray : [GetProfilesByCategoryObjects] = []
    @IBOutlet weak var TableView: UITableView!{didSet{self.TableView.delegate = self; self.TableView.dataSource = self ; self.GetData()}}
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        TableView.cr.addHeadRefresh {
            self.GetData()
        }
    }
    
    
    func GetData(){
        self.ProductArray.removeAll()
        CommentObjectAPI.GetFav { profiles in
            if profiles.count == 0{
                self.view.makeToast("Empty list", duration: 2.0, position: .center)
            }
            self.ProductArray = profiles
            self.TableView.reloadData()
            self.TableView.cr.endHeaderRefresh()
        }
    }
}

extension FavoritesVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ProductArray.count == 0{
            return 0
        }
        return ProductArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
        if ProductArray.count != 0{
        cell.Update(profil:self.ProductArray[indexPath.row])
        }
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ProductArray.count != 0 && indexPath.row <= ProductArray.count{
        callSegueFromProductCell(myData: (self.ProductArray[indexPath.row].id as NSString).integerValue)
        }
    }
    
    
    func callSegueFromProductCell(myData: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
        myVC.ProfileID = "\(myData)"
        myVC.modalPresentationStyle = .fullScreen
        self.present(myVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print((self.ProductArray[indexPath.row].id as NSString).integerValue)
            CommentObjectAPI.SetToWishList(ProductID: (self.ProductArray[indexPath.row].id as NSString).integerValue , AddOrDelete: 2) { (state) in
                self.GetData()
            }
        }
    }
    
    
}

