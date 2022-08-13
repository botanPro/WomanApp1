//
//  HomeVC.swift
//  WomanApp
//
//  Created by botan pro on 9/3/21.
//

import UIKit
import FSPagerView
import CRRefresh
import SDWebImage
import TableViewReloadAnimation
import Alamofire
import SwiftyJSON
import OneSignal
import CustomLoader
import ViewAnimator
class HomeVC: UIViewController ,UITextFieldDelegate{

    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    @IBOutlet weak var AllProfilesLable: LanguageLable!
    
    @IBOutlet weak var CategoryLable: LanguageLable!
    
    var IsSearched = false
    var workitem = WorkItem()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 1 {print(";,;,;;,;")
            self.SearchArray.removeAll()
            self.GeAlltProfiles(CityId: self.CityID)
        }else{
            workitem.perform(after: 0.3) {
                self.SearchArray.removeAll()
                let stringUrl = URL(string: API.URL);
                let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
                let param: [String: Any] = [
                    "key":API.key,
                    "username":API.UserName,
                    "fun":"profile_search",
                    "text": textField.text!,
                    "lang":lang
                ]
                self.IsSearched = true
                AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
                    switch respons.result{
                    case .success:
                        let jsonData = JSON(respons.data ?? "")
                        print(jsonData)
                            for (_,val) in jsonData{
                                let profile = GetProfilesByCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "", latitude: val["latitude"].string ?? "", longitude: val["longitude"].string ?? "", rate: val["rate"].string ?? "")
                                self.SearchArray.append(profile)
                            }
                            self.SearchTableView.reloadData()
                    case .failure(let error):
                        print("error 520 : error while getting product in search")
                        print(error);
                    }
                }
            }
        }
        return true
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var IsSearchViewTaped = false
    
    @IBAction func DismissSearch(_ sender: Any) {
        IsSearchViewTaped = false
        UIView.animate(withDuration: 0.4) {
            self.SearchBigView.alpha = 0
            self.SearchTableView.alpha = 0
            self.SearchText.resignFirstResponder()
            self.SearchText.isUserInteractionEnabled = false
            self.SearchTextTop.constant = 10
            self.SearchTextBottom.constant = 20
            self.SearchTextRight.constant = 8
            self.ScrollView.isScrollEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    @IBOutlet weak var FavoritesButton: UIBarButtonItem!
    
    
    @IBOutlet weak var TryAgain: UIButton!
    
    @IBOutlet weak var AllProfilesCollectionView: UICollectionView!
    @IBOutlet weak var SearchTextRight: NSLayoutConstraint!
    @IBOutlet weak var SearchTextBottom: NSLayoutConstraint!
    @IBOutlet weak var SearchTextTop: NSLayoutConstraint!
    @IBOutlet weak var SearchTableView: UITableView!{didSet{self.SearchTableView.delegate = self ; self.SearchTableView.dataSource = self}}
    @IBOutlet weak var SearchBigView: UIView!
    
    @IBAction func SearchStackAction(_ sender: Any) {
        if IsSearchViewTaped == false{
         IsSearchViewTaped = true
        UIView.animate(withDuration: 0.3) {
            self.SearchTextTop.constant = 20
            self.SearchTextBottom.constant = 10
            self.view.layoutIfNeeded()
        } completion: { finish in
            UIView.animate(withDuration: 0.4) {
            self.SearchTextTop.constant = -215
            self.SearchTextBottom.constant = 185
            self.SearchTextRight.constant = 55
               
            self.view.layoutIfNeeded()
            }
            self.SearchText.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.SearchBigView.alpha = 1
                self.SearchTableView.alpha = 1
            }
            self.SearchTableView.reloadData(with: .simple(duration: 0.2, direction: .left(useCellsFrame: true), constantDelay: 0.1))
            self.ScrollView.scrollToTop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.ScrollView.isScrollEnabled = false
            }
        }
        }
    }
    
    
    @IBAction func NoInternetTryAgain(_ sender: Any) {
        _ =  LoadingView.standardProgressBox.show(inView: self.view)
        self.GetSlides()
        self.GetAllCity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.removeLoadingViews(animated: true)
        }
        
        if CheckInternet.Connection() == false{
            self.InternetStack.isHidden = false
            self.ScrollView.isHidden = true
        }else{
            self.InternetStack.isHidden = true
            self.ScrollView.isHidden = false
        }
    }
    
    @IBOutlet weak var InternetStack: UIStackView!
    @IBOutlet weak var SearchText: UITextField!
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    
    var AllProfile : [GetProfilesByCategoryObjects] = []
    var CityArray : [CityObject] = []
    var sliderImages : [SlideObject] = []
    var CategoryArray : [MainCategoryObjects] = []
    var SelectedCity : CityObject?
    var IsSelected = false
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var AllProfilesCollectionHight: NSLayoutConstraint!
    @IBOutlet weak var ProfileCollectionViewLayout: NSLayoutConstraint!
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var SliderView: FSPagerView!{
        didSet{
            self.GetSlides()
            self.SliderView.layer.masksToBounds = true
            self.SliderView.layer.cornerRadius = 10
            self.SliderView.automaticSlidingInterval = 4.0
            self.SliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.SliderView.transformer = FSPagerViewTransformer(type: .crossFading)
            self.SliderView.itemSize = FSPagerView.automaticSize
        }
    }
    var SearchArray : [GetProfilesByCategoryObjects] = []
    @IBOutlet weak var ProfileCollectionView: UICollectionView!
    @IBOutlet weak var CityCollectionView: UICollectionView!{didSet{GetAllCity()}}
    var IsFooter = false
    var start = 0
    var MyCell = UICollectionViewCell()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "options") == "0"{
            self.navigationItem.leftBarButtonItem = nil
        }
        SearchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.SearchText.delegate = self
        SearchView.layer.cornerRadius = 25
        SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        SearchView.layer.shadowOffset = .zero
        SearchView.layer.shadowRadius = 5.0
        SearchView.layer.shadowOpacity = 0.6

        AllProfilesCollectionView.register(UINib(nibName: "AllProfilesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllCell")
        ProfileCollectionView.register(UINib(nibName: "MainCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        CityCollectionView.register(UINib(nibName: "CityCollectonViewCell", bundle: nil), forCellWithReuseIdentifier: "CityCell")
        self.SearchView.layer.cornerRadius = 10
        

        
        ScrollView.cr.addHeadRefresh {
             self.GetSlides()
            self.GetAllCity()
        }
        
        
    }
    
    
    var CityID = ""
    func GetAllCity(){
        self.CityArray.removeAll()
        CityAPI.GetAllCity { City in
            self.CityArray = City
            self.SelectedCity = City[0]
            self.GetAllCatrgories(CityId: City[0].id)
            self.CityID = City[0].id
            self.GeAlltProfiles(CityId: City[0].id)
            UserDefaults.standard.set(City[0].id ,forKey: "CityId")
            self.CityCollectionView.reloadData()
        }
    }
    
    
    func GetAllCatrgories(CityId : String){
        self.CategoryArray.removeAll()
        MainCategoryAPI.GetMainCategory(CityId: CityId) { MainCategory in
            self.CategoryArray = MainCategory
            self.ScrollView.cr.endHeaderRefresh()
            let animation = AnimationType.from(direction: .right, offset: 20.0)
            self.ProfileCollectionView.animate(animations: [animation])
            self.ProfileCollectionView.reloadData()
        }
    }
    
    
    func GeAlltProfiles(CityId : String){
        self.AllProfile.removeAll()
        GetProfilesByCategoryAPI.GetALlProfiles(CityId: CityId) { Profiles in
            self.AllProfile = Profiles
            self.SearchArray = Profiles
            self.AllProfilesCollectionView.reloadData()
            self.SearchTableView.reloadData()
        }
        
    }
    
    
    
    func GetSlides(){
        self.sliderImages.removeAll()
        SlideAPI.GetSlides { Slide in
            self.sliderImages = Slide
            self.SliderView.reloadData()
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(OneSignal.getDeviceState().userId ?? "")
        UpdateOneSignalIdAPI.Update(onesignalUUID: OneSignal.getDeviceState().userId ?? "")
 
        if CheckInternet.Connection() == false{
            self.InternetStack.isHidden = false
            self.ScrollView.isHidden = true
        }else{
            self.InternetStack.isHidden = true
            self.ScrollView.isHidden = false
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let height = self.ProfileCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.ProfileCollectionViewLayout.constant = height
            
            let heightt = self.AllProfilesCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.AllProfilesCollectionHight.constant = heightt
            self.view.layoutIfNeeded()
        }
    }
    
}



extension HomeVC: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if sliderImages.count == 0{
            return 0
        }
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if sliderImages.count != 0{
            let urlString = "\(API.SlideImages)\(sliderImages[index].image)";
        let url = URL(string: urlString)
        cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imageView?.sd_setImage(with: url, completed: nil)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.cornerRadius = 10
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if sliderImages.count != 0{
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
            if let url = NSURL(string: sliderImages[index].link){
                UIApplication.shared.open(url as URL)
            }
        }
    }

}

extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.CityCollectionView{
            if self.CityArray.count == 0{
                return 0
            }
            return self.CityArray.count
        }
        
        if collectionView == self.ProfileCollectionView{
            if self.CategoryArray.count == 0{
                collectionView.backgroundView?.isHidden = false
                return 0
            }
            collectionView.backgroundView?.isHidden = true
            return self.CategoryArray.count
        }
        
        if collectionView == self.AllProfilesCollectionView{
            if self.AllProfile.count == 0{
                self.AllProfilesCollectionHight.constant = 250
                collectionView.backgroundView?.isHidden = false
                self.view.layoutIfNeeded()
                return 0
            }
            self.viewDidLayoutSubviews()
            collectionView.backgroundView?.isHidden = true
            return self.AllProfile.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ProfileCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MainCategoryCollectionViewCell
            MyCell = cell
            UserDefaults.standard.set(CategoryArray[indexPath.row].option, forKey: "options")
            cell.Update(category: CategoryArray[indexPath.row])
            return cell
        }
        if collectionView == self.AllProfilesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCell", for: indexPath as IndexPath) as! AllProfilesCollectionViewCell
            cell.Update(profil: AllProfile[indexPath.row])
            return cell
        }
        if collectionView == self.CityCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath as IndexPath) as! CityCollectonViewCell
            cell.ViewOver.layer.cornerRadius = 6
            cell.Image.layer.cornerRadius = 6
            cell.Update(city: CityArray[indexPath.row])
            
            if self.SelectedCity?.id == self.CityArray[indexPath.row].id{
                UIView.animate(withDuration: 0.2) {
                    cell.SelectedCellView.backgroundColor = #colorLiteral(red: 0.6636810899, green: 0.3209502697, blue: 0.1211987212, alpha: 1)
                }
            } else {
                 cell.SelectedCellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }

            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        
        if collectionView == self.CityCollectionView{
            let text = self.CityArray[indexPath.row].Name
             let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
             return CGSize(width: width + 28, height: 40)
         }
        
        if let collection = self.ProfileCollectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 65)
        }
        
        if let collection = self.AllProfilesCollectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 65)
        }
      
        return CGSize(width: 0, height: 0)
        
    }

    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }


     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.ProfileCollectionView{
            return sectionInsets
        }
         
         if collectionView == self.AllProfilesCollectionView{
             return sectionInsets
         }
        
        if collectionView == self.CityCollectionView{
            return UIEdgeInsets(top: 0.0, left: 9.0, bottom: 0.0, right: 9.0)
        }
            return UIEdgeInsets()
        
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.CityCollectionView{
            return 0
        }
        
        if collectionView == self.ProfileCollectionView{
            return spacingBetweenCells
        }
         if collectionView == self.AllProfilesCollectionView{
             return spacingBetweenCells
         }
        return CGFloat()
        
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.CityCollectionView{
            if CityArray.count != 0 && indexPath.row <= CityArray.count{
                self.IsSelected = true
                self.SelectedCity = self.CityArray[indexPath.row]
                self.GetAllCatrgories(CityId: CityArray[indexPath.row].id)
                self.GeAlltProfiles(CityId: CityArray[indexPath.row].id)
                UserDefaults.standard.set(CityArray[indexPath.row].id,forKey: "CityId")
                self.CityID = CityArray[indexPath.row].id
                self.CityCollectionView.reloadData()
            }
        }
        
        if collectionView == ProfileCollectionView{
            if CategoryArray.count != 0 && indexPath.row <= CategoryArray.count{
                SubCategoryAPI.GetSubCategory(MainCategoryID: self.CategoryArray[indexPath.row].id) { SubCategory in
                    if SubCategory.count != 0{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "GoToSub") as! SubCategoryVC
                    myVC.title = self.CategoryArray[indexPath.row].name
                    myVC.CatID = self.CategoryArray[indexPath.row].id
                    print(self.CategoryArray[indexPath.row].id)
                    self.navigationController?.pushViewController(myVC, animated: true)
                }else{print("dkmfkmsdk")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "GoToAllPro") as! AllProfilesVC
                    myVC.title = self.CategoryArray[indexPath.row].name
                    myVC.IsFromCat = false
                    myVC.CatId = self.CategoryArray[indexPath.row].id
                    self.navigationController?.pushViewController(myVC, animated: true)
                }
            }
          }
        }
        
        if collectionView == AllProfilesCollectionView{
            if AllProfile.count != 0 && indexPath.row <= AllProfile.count{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
            myVC.ProfileID = self.AllProfile[indexPath.row].id
            myVC.modalPresentationStyle = .fullScreen
            self.present(myVC, animated: true, completion: nil)
            }
        }
    }
    


    
}


extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}





extension HomeVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SearchArray.count == 0 {
            return 0
        }
        return SearchArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        if SearchArray.count != 0 && indexPath.row <= SearchArray.count{
            cell.Name.text = self.SearchArray[indexPath.row].name
            cell.Check.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SearchArray.count != 0 && indexPath.row <= SearchArray.count{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
            myVC.ProfileID = self.SearchArray[indexPath.row].id
            myVC.modalPresentationStyle = .fullScreen
            self.present(myVC, animated: true, completion: nil)
        }
    }
    
    
}
