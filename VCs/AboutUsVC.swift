//
//  AboutUsVC.swift
//  WomanApp
//
//  Created by botan pro on 9/3/21.
//

import UIKit
import FSPagerView
import SDWebImage
import CustomLoader
import FirebaseAuth
class AboutUsVC: UIViewController {

    @IBOutlet weak var InternetStack: UIStackView!
    
    var sliderImages : [SlideObject] = []
    
    
    @IBOutlet weak var InfoStack: UIStackView!
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var PhoneNumber: UILabel!
    
    
    
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    
    @IBOutlet weak var YouTube: AZSocialButton!
    @IBOutlet weak var Instagram: AZSocialButton!
    @IBOutlet weak var CallUs: AZSocialButton!
    @IBOutlet weak var Twitter: AZSocialButton!
    @IBOutlet weak var FaceBook: AZSocialButton!
    
    @IBOutlet weak var Lougout: UIButton!
    
    var IsLogout = false
    @IBAction func LogOut(_ sender: Any) {
        if IsLogout == false{
        if UserDefaults.standard.bool(forKey: "Login") == true{
            let myAlert = UIAlertController(title: "Logout?", message: nil, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "Ok", style:  UIAlertAction.Style.default, handler: { _ in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    UserDefaults.standard.set(false, forKey: "Login")
                    UserDefaults.standard.set("", forKey: "UserId")
                    UserDefaults.standard.set("", forKey: "Name")
                    UserDefaults.standard.set("", forKey: "PhoneNumber")
                    self.Name.text = ""
                    self.PhoneNumber.text = ""
                    self.Lougout.setTitle("Login", for: .normal)
                    self.IsLogout = true
                    self.view.layoutIfNeeded()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }))
            
            
            myAlert.addAction(UIAlertAction(title: "No", style:  UIAlertAction.Style.cancel, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
        }
        }else{
            self.performSegue(withIdentifier: "GoToLogin", sender: nil)
        }
    }
    
    
    
    
    @IBAction func TryAgain(_ sender: Any) {
        _ =  LoadingView.standardProgressBox.show(inView: self.view)
        GetSlides()
        GetAbout()
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
    @IBOutlet weak var TryAgain: UIButton!
    @IBOutlet weak var SliderView: FSPagerView!{
        didSet{
            GetSlides()
            self.SliderView.layer.masksToBounds = true
            self.SliderView.layer.cornerRadius = 10
            self.SliderView.automaticSlidingInterval = 4.0
            self.SliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.SliderView.transformer = FSPagerViewTransformer(type: .crossFading)
            self.SliderView.itemSize = FSPagerView.automaticSize
        }
    }
    
    
    @IBOutlet weak var AboutUsText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "Login") == true{
            self.Lougout.setTitle("Lougout", for: .normal)
            self.IsLogout = false
            self.Name.text = UserDefaults.standard.string(forKey: "Name")
            self.PhoneNumber.text = UserDefaults.standard.string(forKey: "PhoneNumber")
            
           
        }else{
            self.Name.text = ""
            self.PhoneNumber.text = ""
            self.Lougout.setTitle("Login", for: .normal)
            self.IsLogout = true
        }
        

        
        self.CallUs.onClickAction = { (button) in
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
        
        
        
        GetAbout()
    }
    
    
    func GetSlides(){
        self.sliderImages.removeAll()
        SlideAPI.GetSlides { Slide in
            self.sliderImages = Slide
            self.SliderView.reloadData()
        }
    }
    
    
    @IBOutlet weak var TextViewHight: NSLayoutConstraint!
    
    var phone = ""
    var youtube = ""
    var facebook = ""
    var instagram = ""
    var twitter = ""
    func GetAbout(){

        
        AboutAPI.GetAbout { about in
            //var xx = "";
            self.youtube = about.youtube
            self.facebook = about.facebook
            self.instagram = about.instagram
            self.twitter = about.twitter
            
            print(about.youtube)
            
            if about.instagram == ""{
                self.Instagram.isHidden = true
            }
            
            if about.facebook == ""{
                self.FaceBook.isHidden = true
            }
            
            if about.youtube == ""{
                self.YouTube.isHidden = true
            }
            
            if about.twitter == ""{
                self.Twitter.isHidden = true
            }
            
            
            self.AboutUsText.text = about.about
//            if (self.AboutUsText.text != ""){
//                do {
//                    xx = try ((self.AboutUsText.text.strippingHTML()))!
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//
//            self.AboutUsText.attributedText = xx.html2AttributedString
            self.AboutUsText.adjustUITextViewHeight()
            self.view.layoutIfNeeded()
            
            
                self.phone = about.phone
  
        }
    }
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CheckInternet.Connection() == false{
            self.InternetStack.isHidden = false
            self.ScrollView.isHidden = true
        }else{
            self.InternetStack.isHidden = true
            self.ScrollView.isHidden = false
        }
        
        if UserDefaults.standard.bool(forKey: "Login") == true{
            self.Lougout.setTitle("Lougout", for: .normal)
            self.IsLogout = false
            self.Name.text = UserDefaults.standard.string(forKey: "Name")
            self.PhoneNumber.text = UserDefaults.standard.string(forKey: "PhoneNumber")
        }else{
            self.Name.text = ""
            self.PhoneNumber.text = ""
            self.Lougout.setTitle("Login", for: .normal)
            self.IsLogout = true
        }
        
    }


    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL)
        }
    }
    
    
}
extension AboutUsVC: FSPagerViewDataSource,FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if sliderImages.count == 0{
            return 0
        }
        return sliderImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if sliderImages.count != 0{print("p[p[p[p")
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
        }
    }

}




extension String {
  
    func strippingHTML() throws -> String?  {
        if isEmpty {
            return nil
        }
        
        if let data = data(using: .utf8) {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType : NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            var string = attributedString.string
            
            // These steps are optional, and it depends on how you want handle whitespace and newlines
            string = string.replacingOccurrences(of: "\u{FFFC}",
                                                 with: "",
                                                 options: .regularExpression,
                                                 range: nil)
            string = string.replacingOccurrences(of: "(\n){3,}",
                                                 with: "\n\n",
                                                 options: .regularExpression,
                                                 range: nil)
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return nil
    }
}



extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension StringProtocol where Index == String.Index {
    var isEmptyField: Bool {
        return trimmingCharacters(in: .whitespaces) == ""
    }
}


extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
