//
//  PostVC.swift
//  WomanApp
//
//  Created by botan pro on 10/5/21.
//

import UIKit
import YoutubePlayerView
import YouTubeVideoPlayer
class PostVC: UIViewController {

    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var Dismiss: UIButton!
    @IBOutlet weak var proimage: UIImageView!
    @IBOutlet weak var procat: UILabel!
    @IBOutlet weak var Name2: UILabel!
    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var proname: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
  
    @IBOutlet weak var Image2: UIImageView!

    
    

    

    
    @IBOutlet weak var ImageHight: NSLayoutConstraint!
    @IBOutlet weak var ytHight: NSLayoutConstraint!
    @IBOutlet weak var YoutubeView: YouTubeVideoPlayer!
    var yt = ""
    var ProId = ""
    var Array : PostsObjects!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.Imagee.layer.borderColor = UIColor.black.cgColor
        self.Imagee.layer.borderWidth = 0.5
        self.Imagee.layer.cornerRadius = self.Imagee.bounds.width / 2
        
        self.Image2.layer.borderWidth = 0.5
        self.Image2.layer.cornerRadius = 10
        self.Image2.layer.borderColor = UIColor.lightGray.cgColor
        

        
  
        
        self.Name.text = Array.name
        self.Name2.text = Array.name
        self.proname.text = Array.proname
        self.procat.text = Array.procategory
        self.date.text = Array.date
        self.desc.text = Array.disc
        self.ProId = Array.profile_id
        self.yt = Array.youtube
        print(";pp;p;p;p;p;")
        print(Array.youtube)
        
        if Array.youtube == ""{print("fffff")
            self.ytHight.constant = 0
            self.YoutubeView.isHidden = true
        }else{
            YoutubeView.play(videoId: self.yt, sourceView: self.YoutubeView)
        }
        

        
        if Array.proname == ""{
            self.ProfileStack.isHidden = true
        }
        let strUrl = "\(API.NewsImages)\(Array.post_image)";
        guard let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return  }
        let Url = URL(string: urlString)
        self.Imagee?.sd_setImage(with: Url, completed: nil)
        self.Image2?.sd_setImage(with: Url, completed: nil)
        
        
        let prostrUrl = "\(API.profileImageURL)\(Array.proimage)";
        guard let prourlString = prostrUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return  }
        let proUrl = URL(string: prourlString)
        self.proimage?.sd_setImage(with: proUrl, completed: nil)
        
        
        self.proimage.layer.cornerRadius = self.proimage.bounds.width / 2
        self.Dismiss.layer.cornerRadius = self.Dismiss.bounds.width / 2
    }
    
    @IBOutlet weak var ProfileStack: UIStackView!
    

    

    
    @IBAction func GoToProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
        myVC.ProfileID = self.ProId
        myVC.modalPresentationStyle = .fullScreen
        self.present(myVC, animated: true, completion: nil)
    }
}
