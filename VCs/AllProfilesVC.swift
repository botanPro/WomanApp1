//
//  AllProfilesVC.swift
//  WomanApp
//
//  Created by botan pro on 9/5/21.
//

import UIKit
import Toast_Swift
class AllProfilesVC: UIViewController {
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 1
    let spacingBetweenCells: CGFloat = 10
    
    
    var SubId = ""
    var CatId = ""
    var IsFromCat = false
    var AllArray : [GetProfilesByCategoryObjects] = []
    var AllSubArray : [GetProfilesBySubCategoryObjects] = []
    @IBOutlet weak var AllProfilesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AllProfilesCollectionView.register(UINib(nibName: "AllProfilesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")

        if IsFromCat == true{print(";;;;;;")
            GetProfilesBySubCatId()
        }else{print(";;;;;;333")
            GetProfilesByCatId()
        }
    }
    
    
    
    func GetProfilesByCatId(){
        self.AllArray.removeAll()
        GetProfilesByCategoryAPI.GetProfilesByCategory(MainCategoryID: self.CatId) { Profiles in
            self.AllArray = Profiles
            if Profiles.count == 0{
                self.view.makeToast("Empty list", duration: 2.0, position: .center)
            }
            self.AllProfilesCollectionView.reloadData()
        }
    }
    
    func GetProfilesBySubCatId(){
        self.AllSubArray.removeAll()
        GetProfilesBySubCategoryAPI.GetProfilesBySubCategory(SubCategoryId: self.SubId) { Profiles in
            self.AllSubArray = Profiles
            if Profiles.count == 0{
                self.view.makeToast("Empty list", duration: 2.0, position: .center)
            }
            self.AllProfilesCollectionView.reloadData()
        }
    }
}

extension AllProfilesVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        if IsFromCat == false{
            if self.AllArray.count == 0{
                return 0
            }
            return self.AllArray.count
        }else{
            if self.AllSubArray.count == 0{
                return 0
            }
            return self.AllSubArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! AllProfilesCollectionViewCell
        if IsFromCat == false{
            cell.Update(profil: AllArray[indexPath.row])
            return cell
        }else{
            cell.Update(profil: self.AllSubArray[indexPath.row])
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
   
        if let collection = self.AllProfilesCollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 65)
        }
        
        
      
        return CGSize(width: 0, height: 0)
        
    }



     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.AllProfilesCollectionView{
            return sectionInsets
        }
            return UIEdgeInsets()
        
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == self.AllProfilesCollectionView{
            return spacingBetweenCells
        }
        return CGFloat()
        
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.AllArray.count != 0 && indexPath.row <= self.AllArray.count{
        if IsFromCat == false{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
            myVC.ProfileID = self.AllArray[indexPath.row].id
            myVC.modalPresentationStyle = .fullScreen
            self.present(myVC, animated: true, completion: nil)
        }else{
            if AllSubArray.count != 0 && indexPath.row <= AllSubArray.count{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
            myVC.ProfileID = self.AllSubArray[indexPath.row].id
            myVC.modalPresentationStyle = .fullScreen
            self.present(myVC, animated: true, completion: nil)
            }
        }
    }
    }
    
}
