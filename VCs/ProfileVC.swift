//
//  ProfileVC.swift
//  WomanApp
//
//  Created by botan pro on 9/5/21.
//

import UIKit
import Cosmos
import FSPagerView
import SDWebImage
import Alamofire
import SwiftyJSON
import Toast_Swift
import YouTubeVideoPlayer

class ProfileVC: UIViewController {
    var sliderImages : [String] = []
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Views: UILabel!
    @IBOutlet weak var SubName: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var CategoryName: UILabel!
    @IBOutlet weak var Dismiss: UIButton!
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var YoutubeView: YouTubeVideoPlayer!
    
    @IBOutlet weak var FavView: UIView!
    @IBAction func AddToFav(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "Login") == true{
            CommentObjectAPI.SetToWishList(ProductID: (self.ProfileID as NSString).integerValue , AddOrDelete: 1) { (state) in
                if state == "true"{
                self.view.makeToast("Added to favorites", duration: 2.0, position: .center)
                }
            }
        }else{
            self.performSegue(withIdentifier: "GoToLogin", sender: nil)
        }
    }
    
    
    
    var yt = ""
    var ProfileID = ""
    @IBOutlet weak var SliderView: FSPagerView!{
        didSet{
            GetImages()
            self.SliderView.layer.masksToBounds = true
            self.SliderView.layer.cornerRadius = 20
            self.SliderView.automaticSlidingInterval = 4.0
            self.SliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.SliderView.transformer = FSPagerViewTransformer(type: .crossFading)
            self.SliderView.itemSize = FSPagerView.automaticSize
        }
    }
    
    
    @IBOutlet weak var AcivitiesCollectionHight: NSLayoutConstraint!
    @IBOutlet weak var ActivitiesCollectionView: UICollectionView!
    @IBOutlet weak var PostsCollectionViewCell: UICollectionView!
    @IBOutlet weak var PostCollectionHight: NSLayoutConstraint!
    @IBOutlet weak var YouTube: AZSocialButton!
    @IBOutlet weak var Instagram: AZSocialButton!
    @IBOutlet weak var Twitter: AZSocialButton!
    @IBOutlet weak var FaceBook: AZSocialButton!
    var youtube = ""
    var facebook = ""
    var instagram = ""
    var twitter = ""
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 1
    let spacingBetweenCells: CGFloat = 20
    
    var Posts : [PostsObjects] = []
    var Activities : [PostsObjects] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        GetData()
        GetComments()
        TableView.rowHeight = UITableView.automaticDimension
        TableView.estimatedRowHeight = 90
        

        self.FavView.layer.cornerRadius = self.FavView.bounds.width / 2
        PostsCollectionViewCell.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        ActivitiesCollectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActCell")

        
        TableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsCell")
        
        
        
        
        
        self.Instagram.onClickAction = { (button) in
            if let urlDestination = URL.init(string: self.instagram ) {
                UIApplication.shared.open(urlDestination)
            }
        }
            
        
        
        
            self.FaceBook.onClickAction = { (button) in
                if let urlDestination = URL.init(string: self.facebook) {
                    UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                }
            }
        
           
        
        
        self.Twitter.onClickAction = { (button) in
            if let urlDestination = URL.init(string: self.twitter) {
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
            
        
        
        
        self.YouTube.onClickAction = { (button) in
            if let urlDestination = URL.init(string: self.youtube) {
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
        
        
        
        
        
        
        self.SliderView.reloadData()
        self.Dismiss.layer.cornerRadius = self.Dismiss.bounds.width / 2
    }
    
    
    
    func GetComments(){
        self.ReviewsArray.removeAll()
        CommentObjectAPI.GetComment(id: (self.ProfileID as NSString).integerValue) { comments in
            self.ReviewsArray = comments
            self.TableView.reloadData()

        }
    }
    
    
    
    @IBOutlet weak var ytHight: NSLayoutConstraint!
    @IBOutlet weak var ReviewsLable: LanguageLable!
    
    var ReviewsArray : [CommentObject] = []
    @IBOutlet weak var RateLable: UILabel!
    @IBOutlet weak var ActivityLabel: LanguageLable!
    @IBOutlet weak var PostLable: LanguageLable!
    
    @IBOutlet weak var Calll: Languagebutton!
    @IBOutlet weak var LocationStack: UIStackView!
    var lat = ""
    var long = ""
    @IBOutlet weak var PRate: CosmosView!
    var phone = ""
    func GetData(){
        ViewProfilObjectsAPI.ViewProfil(ProfileId: self.ProfileID) { data in
            self.CategoryName.text = data.category
            self.SubName.text = data.sub_category
            self.Name.text = data.name
            self.Description.text = data.desc
            self.PRate.rating = Double(data.rate) ?? 0.0
            self.RateLable.text = String(Double(data.rate) ?? 0.0)
            
            if XLanguage.get() == .English{
                self.Views.text = "\(data.views) views"
            }else if XLanguage.get() == .Arabic{
                self.Views.text = "\(data.views) مشاهد"
            }else{
                self.Views.text = "\(data.views) دیتن"
            }
            self.phone = data.phone
            if data.phone == ""{
                self.Calll.isHidden = true
            }
            
            
            self.lat = data.latitude
            self.long = data.longitude
            
            
            if data.latitude == ""{
                self.LocationStack.isHidden = true
            }
            
            
            self.Address.text = data.address
            
            self.yt = data.youtube_video
            
            self.youtube = data.youtube
            self.facebook = data.facebook
            self.instagram = data.instagram
            self.twitter = data.twitter
            
            
            
            
            
            
            print("skaansdnsdkncksjdnk")
            print(data.youtube_video)
            if data.youtube_video == ""{
                self.ytHight.constant = 0
                self.YoutubeView.isHidden = true
            }else{
                self.YoutubeView.play(videoId: self.yt, sourceView: self.YoutubeView)
            }
            
            
            
            
            if self.instagram == ""{
                self.Instagram.isHidden = true
            }
            
            if self.facebook == ""{
                self.FaceBook.isHidden = true
            }
            
            if self.youtube == ""{
                self.YouTube.isHidden = true
            }
            
            if self.twitter == ""{
                self.Twitter.isHidden = true
            }
            
        }
        
        GetPosts(ProfileId : self.ProfileID)
    }
    
    
    
    
    func GetPosts(ProfileId : String){
        self.Posts.removeAll()
        ProPostIdObjectsAPI.GetPostsByNIdew(ProId: self.ProfileID) { Posts in
            print("counttttttt \(Posts.count)")
            for i in Posts{
                if i.type == "1"{
                    self.Posts.append(i)
                }else{
                    self.Activities.append(i)
                }
            }
            self.ActivitiesCollectionView.reloadData()
            self.PostsCollectionViewCell.reloadData()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let height = self.PostsCollectionViewCell.collectionViewLayout.collectionViewContentSize.height
            self.PostCollectionHight.constant = height
            self.PostsCollectionViewCell.reloadData()
            let heightt = self.ActivitiesCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.AcivitiesCollectionHight.constant = heightt
            self.ActivitiesCollectionView.reloadData()
            self.TableHight.constant = self.TableView.contentSize.height
            self.TableView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
    
    
    func GetImages(){
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"profile_img",
            "profile_id": self.ProfileID
        ]
        print("p[p[[[[[[]]]]]]")
        print(self.ProfileID)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        self.sliderImages.append(val["image"].string ?? "")
                    }
                self.SliderView.reloadData()
            case .failure(let error):
                print("error 450 : error while getting images profiles")
                print(error);
            }
        }
    }
    
    
    
    @IBAction func ShowLocation(_ sender: Any) {
        if self.ProfileID != ""{
            print(self.lat)
            print(self.long)
            if let UrlNavigation = URL.init(string: "comgooglemaps://") {
                if UIApplication.shared.canOpenURL(UrlNavigation){
                    if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(self.lat.trimmingCharacters(in: .whitespaces)),\(self.long.trimmingCharacters(in: .whitespaces))&directionsmode=driving") {
                        UIApplication.shared.open(urlDestination)
                    }
                }else {print("opopopopop")
                    NSLog("Can't use comgooglemaps://");
                    self.openTrackerInBrowser()
                }
            }else{print("lkklklklkl")
                NSLog("Can't use comgooglemaps://");
                self.openTrackerInBrowser()
            }
        }
    }
    
     func openTrackerInBrowser(){
        print("[][][][][]")
        print(self.lat)
        print(self.long)
        if let urlDestination = URL.init(string: "http://maps.google.com/maps?q=loc:\(self.lat.trimmingCharacters(in: .whitespaces)),\(self.long.trimmingCharacters(in: .whitespaces))&directionsmode=driving") {
               UIApplication.shared.open(urlDestination)
            print("p[p[p[p")
           }
       }
    
    
    
    
    @IBAction func Call(_ sender: Any) {
        let myAlert = UIAlertController()

            myAlert.addAction(UIAlertAction(title: "Cellular call", style: .default, handler: { (action: UIAlertAction!) -> Void in
                if(UIDevice.current.userInterfaceIdiom == .pad){
                    return
                }
                self.makePhoneCall(phoneNumber: self.phone)

            }))
            
                myAlert.addAction(UIAlertAction(title: "Viber", style: .default, handler: { (action: UIAlertAction!) -> Void in
                    let phoneNumber = self.phone
                    let viberScheme = "viber://"
                    let tel = "contact?number="
                    let chat = "caht"
                    let action = tel
                    var myString = ""
                    if let url = URL(string: viberScheme) {print("[")
                        if UIApplication.shared.canOpenURL(url) {
                            if action == tel {
                                myString = "\(tel):\(phoneNumber)"
                            } else if action == chat {
                                myString = "\(chat):\(phoneNumber)"
                            }
                        }
                    }
                    let myUrl = URL(string: viberScheme + myString)
                    print(myUrl! as URL)
                    if let myUrl = myUrl {print("33[")
                        if UIApplication.shared.canOpenURL(myUrl) {
                            UIApplication.shared.open(myUrl as URL, options: [:], completionHandler: { (Bool) in
                            })
                        } else {
                        }
                    }
    
                }))
                
        myAlert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { (action: UIAlertAction!) -> Void in
            let first4 = String(self.phone.prefix(4))
            let first3 = String(self.phone.prefix(3))
            var fullMob = ""
            if first4 == "+964" || first3 == "964"{
                fullMob = self.phone
            }else{
                fullMob = "964\(self.phone)"
            }
            fullMob = fullMob.replacingOccurrences(of: " ", with: "")
            fullMob = fullMob.replacingOccurrences(of: "+", with: "")
            fullMob = fullMob.replacingOccurrences(of: "-", with: "")
            let urlWhats = "whatsapp://send?phone=\(fullMob)"
            
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = NSURL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                        UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        })
                    } else {
                        let myAlert = UIAlertController()
                        myAlert.addAction(UIAlertAction(title:"WhatsApp Not Found on your device" , style: .default, handler: { (action: UIAlertAction!) -> Void in }))
                        myAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in}))
                        self.present(myAlert, animated: true, completion: nil)
                    }
                }
            }
        }))
        myAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        self.present(myAlert, animated: true, completion: nil)
    }

    @IBOutlet weak var TableHight: NSLayoutConstraint!
    @IBOutlet weak var TableView: UITableView!
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL)
        }
    }
    
    @IBOutlet weak var RateView: CosmosView!{
        didSet{
            RateView.settings.fillMode = .half
            RateView.didFinishTouchingCosmos = { rating in
                if UserDefaults.standard.bool(forKey: "Login") == true{
                let deviceID = UIDevice.current.identifierForVendor!.uuidString
                let stringUrl = URL(string: API.URL);
                let paramR: [String: Any] = [
                    "key":API.key,
                    "username":API.UserName,
                    "fun" : "add_rate",
                    "profile_id":self.ProfileID,
                    "rate":self.RateView.rating,
                    "mobile_id":deviceID
                ]
                
                AF.request(stringUrl!, method: .post, parameters: paramR).responseData { (response) in
                    switch response.result
                    {
                    case .success(_):
                        let jsonData = JSON(response.data ?? "")
                        print(jsonData)
                        if jsonData["insert"].string ?? "" == "true"{
                            self.Alert()
                            if XLanguage.get() == .English{
                                self.view.makeToast("Submited successfully", duration: 2.0, position: .top)
                            }else if XLanguage.get() == .Arabic{
                                self.view.makeToast("تم الارسال بنجاح", duration: 2.0, position: .top)
                            }else{
                                self.view.makeToast("بسەرکەفتیانە هاتە هنارتن", duration: 2.0, position: .top)
                            }
                        }else{
                            if XLanguage.get() == .English{
                                self.view.makeToast("You already rated this.", duration: 2.0, position: .top)
                            }else if XLanguage.get() == .Arabic{
                                self.view.makeToast("لقد قيمت هذا من قبل.", duration: 2.0, position: .top)
                            }else{
                                self.view.makeToast("تە ژ بەری نوکە ئەڤ پروفیایلە یە هەلسەنگاندی", duration: 2.0, position: .top)
                            }
                        }
                    case .failure(let error):
                        print(error);
                    }
                }
            }else{
                self.performSegue(withIdentifier: "GoToLogin", sender: nil)
            }
            }
        }
    }
    
    
    
    func Alert(){
        let alert = UIAlertController(title: "Write your review", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
        textField.placeholder = "Type..."
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text != ""{
                if UserDefaults.standard.bool(forKey: "Login") == true{
                    
                           guard let UserName = UserDefaults.standard.string(forKey: "Name") else{ return}
                           let stringUrl = URL(string: API.URL);
                           let param: [String: Any] = [
                               "key":API.key,
                               "username":API.UserName,
                               "fun" : "add_comment",
                               "id":self.ProfileID,
                               "comment":textField?.text ?? "",
                               "user_name":UserName
                           ]
                           AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                               switch response.result
                               {
                               case .success(_):
                                   let jsonData = JSON(response.data ?? "")
                                    print(jsonData)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.GetComments()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.TableHight.constant = self.TableView.contentSize.height
                                                self.TableView.reloadData()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.TableHight.constant = self.TableView.contentSize.height
                                                self.TableView.reloadData()
                                        }
                                    }
                               case .failure(let error):
                                   print(error);
                               }
                           }
                }else{
                    self.performSegue(withIdentifier: "GoToLogin", sender: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

}


extension ProfileVC: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if sliderImages.count == 0{
            return 0
        }
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if sliderImages.count != 0{print("p[p[p[p")
        let urlString = "\(API.profileImageURL)\(sliderImages[index])";
        let url = URL(string: urlString)
        cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imageView?.sd_setImage(with: url, completed: nil)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.cornerRadius = 12
        }
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if sliderImages.count != 0{
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        }
    }

}



extension ProfileVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == PostsCollectionViewCell{
            if self.Posts.count == 0{
                self.PostLable.isHidden = true
                return 0
            }
            self.PostLable.isHidden = false
            return self.Posts.count
        }
        
        if collectionView == ActivitiesCollectionView{
            if self.Activities.count == 0{
                self.ActivityLabel.isHidden = true
                return 0
            }
            self.ActivityLabel.isHidden = false
            return self.Activities.count
        }
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == PostsCollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! NewsCollectionViewCell
            cell.Imagee.layer.cornerRadius = 10
            cell.update(Post: self.Posts[indexPath.row])
            return cell
        }
        if collectionView == ActivitiesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActCell", for: indexPath as IndexPath) as! NewsCollectionViewCell
            cell.Imagee.layer.cornerRadius = 10
            cell.update(Post: self.Activities[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (2 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.PostsCollectionViewCell{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 65)
        }
        
        if let collection = self.ActivitiesCollectionView{
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
        if collectionView == PostsCollectionViewCell{
            if Posts.count != 0 && indexPath.row <= Posts.count{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPostView") as! PostVC
                myVC.modalPresentationStyle = .fullScreen
                myVC.Array = self.Posts[indexPath.row]
                self.present(myVC, animated: true, completion: nil)
            }
        }
        if collectionView == ActivitiesCollectionView{
            if Activities.count != 0 && indexPath.row <= Activities.count{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPostView") as! PostVC
                myVC.modalPresentationStyle = .fullScreen
                myVC.Array = self.Activities[indexPath.row]
                self.present(myVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
}



//TableView
extension ProfileVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if ReviewsArray.count == 0{
                self.ReviewsLable.isHidden = true
                return 0
            }
          self.ReviewsLable.isHidden = false
            return ReviewsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell", for: indexPath) as! ReviewsTableViewCell
            if ReviewsArray.count != 0{
                cell.update(self.ReviewsArray[indexPath.row])
            }
        return cell
    }
    
    
}
