//
//  classess.swift
//  AdamGroup
//
//  Created by Botan Amedi on 9/7/20.
//  Copyright © 2020 AdamGrouping. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



//MARK:---------MainCategory-----------

class MainCategoryObjects{
    
    var id = ""
    var name = ""
    var image = ""
    var option = ""
    
    
    init(id : String , name : String , image : String , option : String) {
        self.id  = id
        self.name = name
        self.image = image
        self.option = option
    }
    
    
}

class MainCategoryAPI{
    static func GetMainCategory(CityId: String, completion : @escaping (_ MainCategory : [MainCategoryObjects])->()){
        var Category = [MainCategoryObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        print("pooooooooooo")
        print(lang)
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"get_category",
            "city_id": CityId
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print("opopopopop")
                print(jsonData)
                    for (_,val) in jsonData{
                        let cat = MainCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "", option: val["option"].string ?? "0")
                        Category.append(cat);
                        UserDefaults.standard.set(cat.option, forKey: "options")
                    }
               
                    completion(Category);
            case .failure(let error):
                print("error 420 : error while getting mainCategory")
                print(error);
            }
        }
    }
}
//MARK:---------MainCategory-----------






























//MARK:---------SubCategory-----------

class SubCategoryObjects{
    
    var id = ""
    var name = ""
    var image = ""
    
    
    init(id : String , name : String , image : String) {
        self.id  = id
        self.name = name
        self.image = image
    }
    
    
}

class SubCategoryAPI{
    static func GetSubCategory(MainCategoryID : String, completion : @escaping (_ SubCategory : [SubCategoryObjects])->()){
        var Category = [SubCategoryObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"get_sub_category",
            "id": MainCategoryID
        ]
        print(MainCategoryID)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let cat = SubCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "")
                        Category.append(cat);
                    }
                    completion(Category);
            case .failure(let error):
                print("error 450 : error while getting subCategory")
                print(error);
            }
        }
    }
}
//MARK:---------SubCategory-----------












class GetProfilesByCategoryObjects{
    
    var id = ""
    var name = ""
    var image = ""
    var rate = ""
    var latitude = ""
    var longitude = ""
    
    init(id : String , name : String , image : String, latitude : String , longitude : String, rate : String) {
        self.id  = id
        self.name = name
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.rate = rate
    }
    
    
}

class GetProfilesByCategoryAPI{
    static func GetProfilesByCategory(MainCategoryID : String, completion : @escaping (_ Profiles : [GetProfilesByCategoryObjects])->()){
        var profils = [GetProfilesByCategoryObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"profile_by_category",
            "category_id": MainCategoryID
        ]
        print(MainCategoryID)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let profil = GetProfilesByCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "", latitude: val["latitude"].string ?? "", longitude: val["longitude"].string ?? "", rate: val["rate"].string ?? "")
                        profils.append(profil)
                    }
                    completion(profils);
            case .failure(let error):
                print("error 450 : error while getting subCategory")
                print(error);
            }
        }
    }
    
    
    
    static func GetALlProfiles(CityId : String, completion : @escaping (_ Profiles : [GetProfilesByCategoryObjects])->()){
        var profils = [GetProfilesByCategoryObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"profile_all",
            "city_id":CityId
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let profil = GetProfilesByCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "", latitude: val["latitude"].string ?? "", longitude: val["longitude"].string ?? "", rate: val["rate"].string ?? "")
                        profils.append(profil)
                    }
                    completion(profils);
            case .failure(let error):
                print("error 450 : error while getting subCategory")
                print(error);
            }
        }
    }
}

class UIXTabBarStyle : UITabBar{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.3
        self.layer.borderColor = #colorLiteral(red: 0.526606679, green: 0.6378489137, blue: 0.7278677821, alpha: 1)
        self.layer.masksToBounds = true
  
    }
}




class GetProfilesBySubCategoryObjects{
    
    var id = ""
    var name = ""
    var image = ""
    var rate = ""
    var latitude = ""
    var longitude = ""
    
    init(id : String , name : String , image : String, latitude : String , longitude : String , rate:String) {
        self.id  = id
        self.name = name
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.rate = rate
    }
    
    
}

class GetProfilesBySubCategoryAPI{
    static func GetProfilesBySubCategory(SubCategoryId : String, completion : @escaping (_ Profiles : [GetProfilesBySubCategoryObjects])->()){
        var profils = [GetProfilesBySubCategoryObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"profile_by_sub",
            "sub_id": SubCategoryId
        ]
        print(SubCategoryId)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let profil = GetProfilesBySubCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "", latitude: val["latitude"].string ?? "", longitude: val["longitude"].string ?? "", rate: val["rate"].string ?? "")
                        profils.append(profil)
                    }
                    completion(profils);
            case .failure(let error):
                print("error 450 : error while getting subCategory")
                print(error);
            }
        }
    }
}







class  CommentObject {
    var name = ""
    var comment = ""
    var date = ""
    init(name : String ,comment : String, date:String ) {
        self.name = name
        self.comment = comment
        self.date = date
    }
}



class CommentObjectAPI {
    
    static func GetComment(id : Int,completion : @escaping(_ SlideImage : [CommentObject])->()){
        var comments = [CommentObject]()
               let stringUrl = URL(string: API.URL);
               let param: [String: Any] = [
                   "key":API.key,
                   "username":API.UserName,
                   "fun" : "get_comment",
                   "id" : id,
               ]
        
               AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
                   switch response.result
                   {
                   case .success(_):
                       let jsonData = JSON(response.data ?? "")
                       print(jsonData)
                           for (_,val) in jsonData{
                            let comment = CommentObject(name: val["user_name"].string ?? ""
                                                         , comment: val["comment"].string ?? ""
                                                         , date: val["date"].string ?? "")
                            comments.append(comment)
                           }
                           completion(comments)
                   case .failure(let error):
                       print(error);
                   }
               }
    }
    
    
    static func GetFav(completion : @escaping(_ SlideImage : [GetProfilesByCategoryObjects])->()){
        
        guard let Phone = UserDefaults.standard.string(forKey: "PhoneNumber") else { return }
        var profils = [GetProfilesByCategoryObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun" : "get_favorite",
            "lang":lang,
            "phone":Phone
        ]
        
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { (response) in
            switch response.result
            {
            case .success(_):
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let profile = GetProfilesByCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "", latitude: val["latitude"].string ?? "", longitude: val["longitude"].string ?? "", rate: val["rate"].string ?? "")
                        profils.append(profile)
                    }
                    completion(profils)
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    static func SetToWishList(ProductID : Int,AddOrDelete : Int, completion : @escaping (_ state : String)->()){
        guard let UserName = UserDefaults.standard.string(forKey: "Name") else { return }
        guard let Phone = UserDefaults.standard.string(forKey: "PhoneNumber") else { return }
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun": "add_dell_favorite",
            "user_name": UserName,
            "id":ProductID,
            "add_dell":AddOrDelete,
            "phone":Phone
        ]
        print(UserName)
        print(ProductID)
        print(AddOrDelete)
        print(Phone)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData["status"].string ?? "")
                completion(jsonData["status"].string ?? "")
            case .failure(let error):
                print(error);
            }
        }
    }
}








class ViewProfilObjects{
    
    var id = ""
    var name = ""
    var image = ""
    var desc = ""
    var rate = ""
    var latitude = ""
    var longitude = ""
    var address = ""
    var phone = ""
    var category = ""
    var sub_category = ""
    var views = ""
    
    var facebook = ""
    var instagram = ""
    var youtube = ""
    var twitter = ""
    var youtube_video = ""
    
    init(id : String , name : String , desc : String, image : String, latitude : String , longitude : String, rate : String , address : String, phone : String , category : String, sub_category : String, views : String , youtube : String , facebook : String ,instagram : String , twitter : String , youtube_video: String) {
        self.id  = id
        self.name = name
        self.desc = desc
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        
        self.rate  = rate
        self.address = address
        self.phone = phone
        self.category = category
        self.views = views
        self.sub_category = sub_category
        
        self.youtube_video = youtube_video
        
        self.facebook = facebook
        self.instagram = instagram
        self.twitter = twitter
        self.youtube = youtube
    }
    
    
}

class ViewProfilObjectsAPI{
    static func ViewProfil(ProfileId : String, completion : @escaping (_ Profiles : ViewProfilObjects)->()){
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"view_profile",
            "profile_id": ProfileId,
            "mobile_id": deviceID
        ]
        print(ProfileId)
        print(deviceID)
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let profil = ViewProfilObjects(
                            id: val["id"].string ?? "",
                            name: val["name"].string ?? "", desc: val["disc"].string ?? "",
                            image: val["image"].string ?? "",
                            latitude: val["latitude"].string ?? "",
                            longitude: val["longitude"].string ?? "",
                            rate: val["rate"].string ?? "",
                            address: val["address"].string ?? "",
                            phone: val["phone"].string ?? "",
                            category: val["category"].string ?? "",
                            sub_category: val["sub_category"].string ?? "",
                            views: val["views"].string ?? "",
                            youtube: val["youtube"].string ?? "",
                            facebook: val["facebook"].string ?? "",
                            instagram: val["instagram"].string ?? "",
                            twitter: val["twitter"].string ?? "",
                            youtube_video: val["youtube_video"].string ?? "")
                        completion(profil)
                    }
            case .failure(let error):
                print("error 450 : error while getting subCategory")
                print(error);
            }
        }
    }
}














//MARK:---------city-----------

class CityObject{
    var id = ""
    var Name = ""
    var Image = ""
    
    init(id : String , Name : String, Image : String) {
        self.id = id
        self.Name = Name
        self.Image = Image
    }
}

class CityAPI {
    static func GetAllCity(completion : @escaping (_ City : [CityObject])->()){
        var city = [CityObject]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"get_city"
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print("[][][]]]]]]]]]]]][[[[[[[[[00000")
                print(jsonData)
                    for (_,val) in jsonData{
                        let City = CityObject(id: val["id"].string ?? "", Name: val["name"].string ?? "", Image: val["image"].string ?? "")
                        city.append(City)
                    }
                    completion(city);
            case .failure(let error):
                print("error 430 : error while getting citys")
                print(error);
            }
        }
    }
}

//MARK:---------city-----------
































//MARK:---------slide-----------

class SlideObject{
    var id = ""
    var link = ""
    var image = ""
    
    init(id : String , link : String , image : String) {
        
        self.id  = id
        self.link = link
        self.image = image
    }
}


class SlideAPI {
    static func GetSlides(completion : @escaping (_ Slide : [SlideObject])->()){
        var slide = [SlideObject]()
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_slides"
        ]
        
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let Slide = SlideObject(id: val["id"].string ?? "", link: val["link"].string ?? "", image: val["image"].string ?? "")
                        slide.append(Slide);
                    }
                    completion(slide);
            case .failure(let error):
                print("error 440 : error while getting Slide")
                print(error);
            }
        }
    }
}
//MARK:---------slide-----------









class UpdateOneSignalIdAPI{
    static func Update(onesignalUUID : String){
        let stringUrl = URL(string: API.URL);
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "mobile_id":deviceID,
            "fun":"update_onesignal",
            "one_id":onesignalUUID
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
            case .failure(let error):
                print("error 420 : error while getting onesignal UUID")
                print(error);
            }
        }
    }
}








class WorkItem {

    private var pendingRequestWorkItem: DispatchWorkItem?
    
    func perform(after: TimeInterval, _ block: @escaping () -> Void) {
        // Cancel the currently pending item
        pendingRequestWorkItem?.cancel()
        
        // Wrap our request in a work item
        let requestWorkItem = DispatchWorkItem(block: block)
        
        pendingRequestWorkItem = requestWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: requestWorkItem)
    }
}









//MARK:---------About-----------
class AboutObject{
    
    var about = ""
    var phone = ""
    var facebook = ""
    var instagram = ""
    var youtube = ""
    var twitter = ""
    
    init(about : String , phone : String , youtube : String , facebook : String ,instagram : String , twitter : String) {
        self.about = about
        self.phone = phone
        self.facebook = facebook
        self.instagram = instagram
        self.twitter = twitter
        self.youtube = youtube
    }
    
    
}

class AboutAPI{
    static func GetAbout(completion : @escaping (_ about : AboutObject)->()){
        var about : AboutObject!
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_about",
            "lang":lang
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(jsonData)
                    for (_,val) in jsonData{
                        let Subcat = AboutObject(about: val["about_us"].string ?? "" , phone: val["phone"].string ?? "", youtube: val["youtube"].string ?? "", facebook: val["facebook"].string ?? "", instagram: val["instagram"].string ?? "", twitter: val["twitter"].string ?? "")
                        about = Subcat
                    }
                    completion(about)
            case .failure(let error):
                print("error 490 : error while getting about")
                print(error);
            }
        }
    }
}

//MARK:---------About-----------





















//MARK:---------NearLocaitionObject-----------
class NearLocaitionObject{
    
    var id = ""
    var latitude = "0.0"
    var longtitude = "0.0"
    
    init(id : String , latitude : String , longtitude : String) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.id = id
    }
    
    
}

class NearLocaitionAPI{
    static func GetNearLocations(SubsectorID : String, latitude : String, longitude : String ,completion : @escaping (_ about : [NearLocaitionObject])->()){
        var loc : [NearLocaitionObject] = []
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"ner_loc",
            "sub_sector_id": SubsectorID,
            "latitude":latitude,
            "longitude":longitude
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let locations = NearLocaitionObject(id: val["id"].string ?? "", latitude: val["gps_latitude"].string ?? "0.0", longtitude: val["gps_longitude"].string ?? "0.0")
                        loc.append(locations)
                    }
                    completion(loc)
                }
            case .failure(let error):
                print("error 601 : error while getting near locations")
                print(error);
            }
        }
    }
}


//MARK:---------NearLocaitionObject-----------











//MARK:---------NotificationsObject-----------

class NotificationsObject{
    var disc = ""
    var date = ""
    var title = ""
    
    init(disc : String , date: String, title: String) {
        self.disc = disc
        self.date = date
        self.title = title
    }
}

class NotificationAPI{
    static func GetNotifications(completion : @escaping (_ note : [NotificationsObject])->()){
        var not : [NotificationsObject] = []
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_notify"
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let notif = NotificationsObject(disc: val["disc"].string ?? "", date: val["date"].string ?? "", title: val["title"].string ?? "")
                        not.append(notif)
                    }
                    completion(not)
                }
            case .failure(let error):
                print("error 630 : error while getting notifications")
                print(error);
            }
        }
    }
}

//MARK:---------NotificationsObject-----------










extension UIDevice {

    var model: String {

        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {

        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}


extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}




//MARK:---------location sector-----------

class locationSectorsObjects{
    var id = ""
    var name = ""
    var image = ""
    
    
    init(id : String , name : String , image : String) {
        self.id  = id
        self.name = name
        self.image = image
    }
    
}

class locationSectorsAPI{
    static func GetlocationSectors(completion : @escaping (_ category : [locationSectorsObjects])->()){
        var categorys : [locationSectorsObjects] = []
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let CityId = UserDefaults.standard.integer(forKey: "City")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"loc_sector",
            "lang" : lang,
            "city": CityId,
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let cat = locationSectorsObjects(id: val["id"].string ?? "", name: val["sector_name"].string ?? "", image: val["image"].string ?? "")
                        categorys.append(cat);
                    }
                    completion(categorys);
                }
            case .failure(let error):
                print("error 999 : error while getting location sector")
                print(error);
            }
        }
    }
}

//MARK:---------location sector-----------












//MARK:---------VIPLocaitionObject-----------
class VIPLocaitionObject{
    
    var id = ""
    var latitude = "0.0"
    var longtitude = "0.0"
    
    init(id : String , latitude : String , longtitude : String) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.id = id
    }
    
    
}

class VIPLocaitionAPI{
    static func GetVIPLocations(completion : @escaping (_ about : [VIPLocaitionObject])->()){
        var loc : [VIPLocaitionObject] = []
        let stringUrl = URL(string: API.URL);
        let CityId = UserDefaults.standard.integer(forKey: "City")
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "fun":"get_viploc",
            "city": CityId
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                if(jsonData[0] != "error"){
                    for (_,val) in jsonData{
                        let locations = VIPLocaitionObject(id: val["id"].string ?? "", latitude: val["gps_latitude"].string ?? "0.0", longtitude: val["gps_longitude"].string ?? "0.0")
                        loc.append(locations)
                    }
                    completion(loc)
                }
            case .failure(let error):
                print("error 602 : error while getting VIP locations")
                print(error);
            }
        }
    }
}


//MARK:---------VIPLocaitionObject-----------







class NewsObjects{
    
    var id = ""
    var name = ""
    var image = ""
    var date = ""
    var proimage = ""
    var proname = ""
    var procategory = ""
    
    init(id : String , name : String , image : String, proimage : String , proname : String , prodate : String , date : String) {
        self.id  = id
        self.name = name
        self.image = image
        self.proimage = proimage
        self.proname = proname
        self.procategory = prodate
        self.date = date
    }
    
}

class NewsObjectsAPI{
    static func GetProfilesByCategory(completion : @escaping (_ Profiles : [NewsObjects])->()){
        var profils = [NewsObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"get_news"
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let profil = NewsObjects(id: val["id"].string ?? "", name: val["title"].string ?? "", image: val["image"].string ?? "", proimage: val["proimage"].string ?? "", proname: val["proname"].string ?? "", prodate: val["procategory"].string ?? "" ,date: val["date"].string ?? "")
                        profils.append(profil)
                    }
                    completion(profils);
            case .failure(let error):
                
                print(error);
            }
        }
    }
}







class PostsObjects{
    
    var id = ""
    var name = ""
    var image = ""
    var date = ""
    var proimage = ""
    var proname = ""
    var procategory = ""
    var youtube = ""
    var disc = ""
    var profile_id = ""
    var post_id = ""
    var post_image = ""
    var type = ""
    
    init(id : String , name : String , image : String, proimage : String , proname : String , procategory : String , date : String , youtube : String , disc : String , profile_id : String , post_id : String , post_image : String , type:String) {
        self.id  = id
        self.name = name
        self.image = image
        self.proimage = proimage
        self.proname = proname
        self.procategory = procategory
        self.date = date
        self.youtube = youtube
        self.disc = disc
        self.profile_id = profile_id
        self.post_id = post_id
        self.post_image = post_image
        self.type = type
    }
    
}

class PostsObjectsAPI{
    static func GetPostsByNIdew(completion : @escaping (_ Posts : [PostsObjects])->()){
        var Posts = [PostsObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"get_post"
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                print(";[;[;[;[;")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let Post = PostsObjects(id: val["id"].string ?? "", name: val["title"].string ?? "", image: val["image"].string ?? "", proimage: val["profile_image"].string ?? "", proname: val["profile_name"].string ?? "", procategory: val["cat_name"].string ?? "" ,date: val["date"].string ?? ""    , youtube: val["youtube"].string ?? "", disc: val["disc"].string ?? "", profile_id: val["profile_id"].string ?? "" ,post_id: val["post_id"].string ?? "", post_image: val["post_image"].string ?? "" , type:val["type"].string ?? "")
                        Posts.append(Post)
                    }
                    completion(Posts)
            case .failure(let error):
                
                print(error);
            }
        }
    }
}


class ProPostIdObjectsAPI{
    static func GetPostsByNIdew(ProId : String ,completion : @escaping (_ Posts : [PostsObjects])->()){
        var Posts = [PostsObjects]()
        let lang : Int = UserDefaults.standard.integer(forKey: "Lang")
        let stringUrl = URL(string: API.URL);
        let param: [String: Any] = [
            "key":API.key,
            "username":API.UserName,
            "lang":lang,
            "fun":"get_post_by_profile",
            "id":ProId
        ]
        AF.request(stringUrl!, method: .post, parameters: param).responseData { respons in
            switch respons.result{
            case .success:
                let jsonData = JSON(respons.data ?? "")
                    print(jsonData)
                    for (_,val) in jsonData{
                        let Post = PostsObjects(id: val["id"].string ?? "", name: val["title"].string ?? "", image: val["image"].string ?? "", proimage: val["profile_image"].string ?? "", proname: val["profile_name"].string ?? "", procategory: val["cat_name"].string ?? "" ,date: val["date"].string ?? ""    , youtube: val["youtube"].string ?? "", disc: val["disc"].string ?? "", profile_id: val["profile_id"].string ?? "" ,post_id: val["post_id"].string ?? "", post_image: val["post_image"].string ?? "" , type:val["type"].string ?? "")
                        Posts.append(Post)
                    }
                    completion(Posts)
            case .failure(let error):
                
                print(error);
            }
        }
    }
}
