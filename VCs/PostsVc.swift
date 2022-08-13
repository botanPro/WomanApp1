//
//  PostsVc.swift
//  WomanApp
//
//  Created by botan pro on 10/5/21.
//

import UIKit

class PostsVc: UIViewController {

    @IBOutlet weak var PostsCollectionViewCell: UICollectionView!{didSet{self.GetPosts()}}
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 1
    let spacingBetweenCells: CGFloat = 20
    
    
    
    var Array : [PostsObjects] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        PostsCollectionViewCell.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.PostsCollectionViewCell.cr.addHeadRefresh {
            self.GetPosts()
        }
    }
    
    
    
    func GetPosts(){
        self.Array.removeAll()
        PostsObjectsAPI.GetPostsByNIdew { Posts in
            self.Array = Posts
            self.PostsCollectionViewCell.reloadData()
            self.PostsCollectionViewCell.cr.endHeaderRefresh()
        }
    }
    
}

extension PostsVc : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.Array.count == 0{
            return 0
        }
        return self.Array.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! NewsCollectionViewCell
        cell.update(Post: self.Array[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.PostsCollectionViewCell{
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
        let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPostView") as! PostVC
        myVC.modalPresentationStyle = .fullScreen
        myVC.Array = self.Array[indexPath.row]
        self.present(myVC, animated: true, completion: nil)
        }
    }
    


    
}
