//
//  MyCourses.swift
//  WomanApp
//
//  Created by botan pro on 10/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import CustomLoader
class MyCourses: UIViewController {
    
    @IBAction func Dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    var Array : [CourseObject] = []
    @IBOutlet weak var TableView: UITableView!{didSet{self.GetCourse()}}
    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.register(UINib(nibName: "CoursesTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        TableView.cr.addHeadRefresh {
            self.GetCourse()
        }
    }
    
    func GetCourse(){
        self.Array.removeAll()
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_course",
            "phone":UserDefaults.standard.string(forKey: "PhoneNumber") ?? ""
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                for (_ , val) in jsonData{
                    let course = CourseObject(name: val["course_name"].string ?? "", time: val["course_time"].string ?? "", id: val["id"].string ?? "")
                    self.Array.append(course)
                }
                
                self.TableView.reloadData()
            case .failure(let error):
                
                print(error);
            }
        }
        self.TableView.cr.endHeaderRefresh()
    }
    
    
    
    @objc func End(sender: UIButton) {
        let alert = UIAlertController(title: "End Course", message: "Are you sure you want to end your course \(sender.accessibilityIdentifier!)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            _ = LoadingView.standardProgressBox.show(inView: self.view)
            let stringUrl = URL(string: API.URL);
            let param: [String: Any] = [
                "key":API.key,
                "username":API.UserName,
                "fun":"delete_course",
                "id":sender.tag
            ]
            AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
                switch respons.result{
                case .success:
                    let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    self.GetCourse()
                    self.view.removeLoadingViews(animated: true)
                case .failure(let error):
                    
                    print(error);
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}




extension MyCourses : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Array.count == 0{
            return 0
        }
        return Array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CoursesTableViewCell
        if Array.count != 0{
            cell.Name.text = Array[indexPath.row].name
            cell.Time.text = Array[indexPath.row].time
            cell.End.accessibilityIdentifier = Array[indexPath.row].name
            cell.End.tag = (Array[indexPath.row].id as NSString).integerValue
            cell.End.addTarget(self, action: #selector(self.End(sender:)), for:.touchUpInside)
        }
        return cell
    }


    func callSegueFromProductCell(myData: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
        myVC.ProfileID = "\(myData)"
        myVC.modalPresentationStyle = .fullScreen
        self.present(myVC, animated: true, completion: nil)
    }

    
}



class CourseObject{
    var name = ""
    var time = ""
    var id = ""

    
    init(name : String , time : String , id : String) {
        self.id = id
        self.time = time
        self.name = name
    }
}
