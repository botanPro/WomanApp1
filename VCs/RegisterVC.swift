//
//  RegisterVC.swift
//  WomanApp
//
//  Created by botan pro on 10/11/21.
//

import UIKit
import CustomLoader
import Alamofire
import SwiftyJSON
class RegisterVC: UIViewController {

    @IBAction func Dismiss(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    var CourseNamee = ""
    var CourseTime = ""
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Register: UIButton!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var CourseName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CourseName.text = self.CourseNamee
        self.Name.text = UserDefaults.standard.string(forKey: "Name")
        self.Phone.text = UserDefaults.standard.string(forKey: "PhoneNumber")
    }
    
    @IBAction func Register(_ sender: Any) {
        _ = LoadingView.standardProgressBox.show(inView: self.view)
        let stringUrl = URL(string: API.URL);
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"course_add",
            "course_name":self.CourseNamee,
            "course_time":self.CourseTime,
            "phone":self.Phone.text!,
            "user_name":self.Name.text!,
            "address":self.Address.text!,
            "email":self.Email.text!,
            "lang":lang
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(respons)
                self.view.removeLoadingViews(animated: true)
                let alert = UIAlertController(title: "Registred", message: "Your course registred, please white until we calling your number \(self.Phone.text!)", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            case .failure(let error):
                
                print(error);
            }
        }
    }
}
