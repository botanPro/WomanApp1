//
//  SubCategoryVC.swift
//  WomanApp
//
//  Created by botan pro on 9/5/21.
//

import UIKit
import Toast_Swift
class SubCategoryVC: UIViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    var CatID = ""
    var SubCategoryArray : [SubCategoryObjects] = []
    @IBOutlet weak var SubCategoryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SubCategoryCollectionView.register(UINib(nibName: "MainCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        GetSUbCategory()
    }
    
    
    func GetSUbCategory(){
        SubCategoryAPI.GetSubCategory(MainCategoryID: self.CatID) { SubCategory in
            self.SubCategoryArray = SubCategory
            if SubCategory.count == 0{
                self.view.makeToast("Empty list", duration: 2.0, position: .center)
            }
            self.SubCategoryCollectionView.reloadData()
        }
    }
    
}

extension SubCategoryVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        if collectionView == self.SubCategoryCollectionView{
            if self.SubCategoryArray.count == 0{
                return 0
            }
            return self.SubCategoryArray.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.SubCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MainCategoryCollectionViewCell
            cell.Update(category: SubCategoryArray[indexPath.row])
            return cell
        }

        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
   
        if let collection = self.SubCategoryCollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 191)
        }
        
        
      
        return CGSize(width: 0, height: 0)
        
    }



     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.SubCategoryCollectionView{
            return sectionInsets
        }
            return UIEdgeInsets()
        
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == self.SubCategoryCollectionView{
            return spacingBetweenCells
        }
        return CGFloat()
        
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if SubCategoryArray.count != 0 && indexPath.row <= SubCategoryArray.count{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "GoToAllPro") as! AllProfilesVC
            myVC.title = self.SubCategoryArray[indexPath.row].name
            myVC.IsFromCat = true
            myVC.SubId = self.SubCategoryArray[indexPath.row].id
            self.navigationController?.pushViewController(myVC, animated: true)
        }
    }
    
}
