//
//  NewsVc.swift
//  WomanApp
//
//  Created by botan pro on 10/5/21.
//

import UIKit

class NewsVc: UIViewController {
    @IBOutlet weak var NewsCollectionView: UICollectionView!{didSet{self.NewsCollectionView.delegate = self ; self.NewsCollectionView.dataSource = self ; self.GetNews()}}
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 1
    let spacingBetweenCells: CGFloat = 20
    
    var Array : [NewsObjects] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsCollectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        self.NewsCollectionView.cr.addHeadRefresh {
            self.GetNews()
        }
    }
    
    
    func GetNews(){
        self.Array.removeAll()
        NewsObjectsAPI.GetProfilesByCategory { News in
            self.Array = News
            self.NewsCollectionView.reloadData()
            self.NewsCollectionView.cr.endHeaderRefresh()
        }
    }

}

extension NewsVc : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.Array.count == 0{
            return 0
        }
        return self.Array.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! NewsCollectionViewCell
        cell.Imagee.layer.cornerRadius = 10
        cell.date.isHidden = true
        
        cell.Name.text = self.Array[indexPath.row].name
        let strUrl = "\(API.NewsImages)\(self.Array[indexPath.row].image)";
        let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let Url = URL(string: urlString)
        cell.Imagee?.sd_setImage(with: Url, completed: nil)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.NewsCollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 65)
        }
        
        return CGSize(width: 0, height: 0)
        
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            return sectionInsets
        
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return spacingBetweenCells

     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Array.count != 0 && indexPath.row <= Array.count{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPost") as! PostsVc
        myVC.title = self.Array[indexPath.row].name
        self.navigationController?.pushViewController(myVC, animated: true)
        }
    }
    


    
}
