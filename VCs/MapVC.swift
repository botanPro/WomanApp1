//
//  MapVC.swift
//  WomanApp
//
//  Created by botan pro on 9/3/21.
//

import UIKit
import MapKit
import SDWebImage
import CoreLocation
import Alamofire
import SwiftyJSON
import Toast_Swift
import CustomLoader
import TableViewReloadAnimation

class MapVC: UIViewController ,MKMapViewDelegate ,CLLocationManagerDelegate ,UITextFieldDelegate{
    var SearchArray : [GetProfilesByCategoryObjects] = []
    var IsSearched = false
    var IsSubCat = false
    var workitem = WorkItem()
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.SearchArray.removeAll()
        self.MainCategory.removeAll()
        if textField.text?.count == 1 {print(";,;,;,;,")
            self.IsSubCat = false
            self.IsSearched = false
            self.MainCategory.removeAll()
            self.GetAllCatrgories(CityId:self.CityID)
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
                        if jsonData.count == 0{
                            self.SearchArray.removeAll()
                            self.TableView.reloadData()
                        }
                            for (_,val) in jsonData{
                                let profile = GetProfilesByCategoryObjects(id: val["id"].string ?? "", name: val["name"].string ?? "", image: val["image"].string ?? "", latitude: val["latitude"].string ?? "", longitude: val["longitude"].string ?? "", rate: val["rate"].string ?? "")
                                self.SearchArray.append(profile)
                            }
                            self.TableView.reloadData()
                    case .failure(let error):
                        print("error 520 : error while getting product in search")
                        print(error);
                    }
                }
            }
        }
        return true
    }
    
    
    
    
    
    
    
    @IBOutlet weak var BackToCat: UIButton!
    
    
    @IBOutlet weak var SearchTextRight: NSLayoutConstraint!
    @IBOutlet weak var MainViewBottom: NSLayoutConstraint!
    @IBOutlet weak var SearchView: UIView!
    var profileIn : [profile] = []
    @IBOutlet weak var MapView: MKMapView!
    var AnnotationArray : [Place] = []
    private var locationManager: CLLocationManager!
    private var location: MKAnnotation!
    private var currentLocation: CLLocation?
    var SelectedCity : CityObject?
    var MainCategory : [MainCategoryObjects] = []
    var MainSubCategory : [SubCategoryObjects] = []
    @IBOutlet weak var TableView: UITableView!{didSet{self.TableView.delegate = self ; self.TableView.dataSource = self}}
    
    @IBOutlet weak var CityCollectionView: UICollectionView!{didSet{GetAllCity()}}
    var CityArray : [CityObject] = []
    
    @IBOutlet weak var SearchTableViewTop: NSLayoutConstraint!
    
    
    @IBAction func BackToMainCategories(_ sender: Any) {
        self.MainCategory.removeAll()
        self.SearchTableViewTop.constant = 0
        self.IsSubCat = false
        self.GetAllCatrgories(CityId:self.CityID)
    }
    
    
    var lat = ""
    var long = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MapView.delegate = self
        SearchView.layer.cornerRadius = 12
        SearchView.layer.shadowColor = UIColor.lightGray.cgColor
        SearchView.layer.shadowOffset = .zero
        SearchView.layer.shadowRadius = 5.0
        SearchView.layer.shadowOpacity = 0.4
        self.SearchText.delegate = self
        self.SearchText.isUserInteractionEnabled = false
        
        TableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        CityCollectionView.register(UINib(nibName: "CityCollectonViewCell", bundle: nil), forCellWithReuseIdentifier: "CityCell")
        self.MapView.showsUserLocation = true

        XLocations.Shared.GetUserLocation()
        XLocations.Shared.GotLocation = {
           self.lat =  String(XLocations.Shared.latitude)
           self.long =  String(XLocations.Shared.longtude)
       }
        
        
        
        ///#
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        GetAllCatrgories(CityId: CityID)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.MapView.addGestureRecognizer(tap)
        

    }
    
    var CityID = ""
    func GetAllCity(){
        self.CityArray.removeAll()
        CityAPI.GetAllCity { City in
            self.CityArray = City
            self.SelectedCity = City[0]
            self.GetAllCatrgories(CityId: City[0].id)
            self.CityID = City[0].id
            self.TableView.cr.endHeaderRefresh()
            self.CityCollectionView.reloadData()
        }
    }
    
    
    
    func GetAllCatrgories(CityId : String){
        self.MainCategory.removeAll()
        self.SearchArray.removeAll()
        MainCategoryAPI.GetMainCategory(CityId: CityId) { MainCategory in
            self.MainCategory = MainCategory
            self.TableView.reloadData(with: .simple(duration: 0.2, direction: .left(useCellsFrame: true), constantDelay: 0.1))
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        IsSearchViewTaped = false
        UIView.animate(withDuration: 0.3) {
            self.MainViewBottom.constant = 319
            self.SearchTextRight.constant = 16
            self.TableView.alpha = 0
            self.CityCollectionView.alpha = 0
            self.BackToCat.alpha = 0
            self.SearchText.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }
    }

    @IBOutlet weak var MainView: UIView!
    @objc func SwipeViewToTop(_ panRecognizer: UIPanGestureRecognizer) {
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CheckInternet.Connection() == false{
            self.MainViewBottom.constant = 380
        }else{
            GetAllCity()
            self.MainViewBottom.constant = 319
            self.TableView.alpha = 0
            self.CityCollectionView.alpha = 0
            self.BackToCat.alpha = 0
            
        }
    }
    
    

    @IBOutlet weak var SearchText: UITextField!
    
    var SeeProfileId = ""
    var IsSearchViewTaped = false
    @IBAction func SearchStackAction(_ sender: Any) {
        if IsSearchViewTaped == false{
         IsSearchViewTaped = true
        UIView.animate(withDuration: 0.3) {
            self.MainViewBottom.constant = 0
            self.SearchTextRight.constant = 55
            self.SearchText.isUserInteractionEnabled = true
            self.TableView.alpha = 1
            self.CityCollectionView.alpha = 1
            self.BackToCat.alpha = 1
            self.view.layoutIfNeeded()
        }
        self.TableView.reloadData(with: .simple(duration: 0.2, direction: .left(useCellsFrame: true), constantDelay: 0.1))
        }
    }
    
    
    @IBAction func Dismiss(_ sender: Any) {
        IsSearchViewTaped = false
        UIView.animate(withDuration: 0.3) {
            self.MainViewBottom.constant = 319
            self.SearchTextRight.constant = 16
            self.SearchText.text = ""
            self.TableView.alpha = 0
            self.CityCollectionView.alpha = 0
            self.BackToCat.alpha = 0
            self.SearchText.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ///#
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      defer { currentLocation = locations.last }

      if currentLocation == nil {
          if let userLocation = locations.last {
              let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 8000, longitudinalMeters: 8000)
              MapView.setRegion(viewRegion, animated: false)
          }
      }
  }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
        }else{
            if let profileID = view.annotation as? profile {
                print(profileID)
                self.SeeProfileId = profileID.profileId
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "GoToPro") as! ProfileVC
                myVC.ProfileID = self.SeeProfileId
                myVC.modalPresentationStyle = .fullScreen
                self.present(myVC, animated: true, completion: nil)
            }
            
        }
    }
    
}




extension MapVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if IsSearched == false{
            if IsSubCat == false{
                if MainCategory.count == 0 {
                    return 0
                }
                return MainCategory.count
            }else{
                if MainSubCategory.count == 0 {
                    return 0
                }
                return MainSubCategory.count
            }
        }else{
            if SearchArray.count == 0 {
                return 0
            }
            return SearchArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        if IsSearched == false{
            if IsSubCat == false{
                cell.Name.text = self.MainCategory[indexPath.row].name
                cell.Check.isHidden = true
            }else{
                cell.Name.text = self.MainSubCategory[indexPath.row].name
                cell.Check.isHidden = true
            }
        }else{
            cell.Name.text = self.SearchArray[indexPath.row].name
            cell.Check.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (MainCategory.count != 0 && indexPath.row <= self.MainCategory.count) || (SearchArray.count != 0 && indexPath.row <= self.SearchArray.count){
            if IsSearched == false{
            if IsSubCat == false{
                _ =  LoadingView.standardProgressBox.show(inView: self.view)
                self.MainSubCategory.removeAll()
                SubCategoryAPI.GetSubCategory(MainCategoryID: self.MainCategory[indexPath.row].id) { SubCategory in
                    print("1111")
                    self.view.removeLoadingViews(animated: true)
                    print(SubCategory.count)
                    if SubCategory.count != 0{
                        self.IsSubCat = true
                        self.MainSubCategory = SubCategory
                        self.SearchTableViewTop.constant = 45
                        self.TableView.reloadData(with: .simple(duration: 0.2, direction: .left(useCellsFrame: true), constantDelay: 0.1))
                        self.view.removeLoadingViews(animated: true)
                    } else {
                        _ = LoadingView.standardProgressBox.show(inView: self.view)
                        GetProfilesByCategoryAPI.GetProfilesByCategory(MainCategoryID: self.MainCategory[indexPath.row].id) { Profiles in
                            print("2222")
                            print(Profiles.count)
                            self.view.removeLoadingViews(animated: true)
                            if Profiles.count != 0{
                                self.MapView.removeAnnotations(self.MapView.annotations.filter { $0 !== self.MapView.userLocation })
                                for loc in Profiles{
                                    let lat = Double(loc.latitude)
                                    let long = Double(loc.longitude)
                                    if let latt = lat, let longg = long{
                                        let profileInfo = profile()
                                        profileInfo.profileId = loc.id
                                        profileInfo.coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                                        self.MapView.addAnnotation(profileInfo)
                                        let viewRegion = MKCoordinateRegion(center: self.MapView.userLocation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
                                        self.MapView.setRegion(viewRegion, animated: true)
                                        self.view.removeLoadingViews(animated: true)
                                    }
                                }
                                
                            }else{
                                self.view.removeLoadingViews(animated: true)
                                self.view.makeToast("Empty list", duration: 2.0, position: .center)
                            }
                        }
                    }
                }
                
            }else{
                _ = LoadingView.standardProgressBox.show(inView: self.view)
                self.MapView.removeAnnotations(self.MapView.annotations.filter { $0 !== self.MapView.userLocation })
                GetProfilesBySubCategoryAPI.GetProfilesBySubCategory(SubCategoryId: self.MainSubCategory[indexPath.row].id) { Profiles in
                    self.view.removeLoadingViews(animated: true)
                    if Profiles.count != 0{
                        for loc in Profiles{
                            let lat = Double(loc.latitude)
                            let long = Double(loc.longitude)
                            if let latt = lat, let longg = long{
                                let profileInfo = profile()
                                profileInfo.profileId = loc.id
                                profileInfo.coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                                self.MapView.addAnnotation(profileInfo)
                                let viewRegion = MKCoordinateRegion(center: self.MapView.userLocation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
                                self.MapView.setRegion(viewRegion, animated: true)
                                
                            }
                        }
                    }else{
                        self.view.removeLoadingViews(animated: true)
                        self.view.makeToast("Empty list", duration: 2.0, position: .center)
                    }
                }
            }
            }else{
                _ = LoadingView.standardProgressBox.show(inView: self.view)
                self.MapView.removeAnnotations(self.MapView.annotations.filter { $0 !== self.MapView.userLocation })
                let lat = Double(SearchArray[indexPath.row].latitude)
                let long = Double(SearchArray[indexPath.row].longitude)
                if let latt = lat, let longg = long{
                    let profileInfo = profile()
                    profileInfo.profileId = SearchArray[indexPath.row].id
                    profileInfo.coordinate = CLLocationCoordinate2D(latitude: latt, longitude: longg)
                    self.MapView.addAnnotation(profileInfo)
                    let viewRegion = MKCoordinateRegion(center: self.MapView.userLocation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
                    self.MapView.setRegion(viewRegion, animated: true)
                    self.view.removeLoadingViews(animated: true)
                }else{
                    self.view.removeLoadingViews(animated: true)
                    self.view.makeToast("Empty list", duration: 2.0, position: .center)
                }
            }
        }
    }
}






extension MapVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.CityArray.count == 0{
            return 0
        }
        return self.CityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath as IndexPath) as! CityCollectonViewCell
        cell.ViewOver.layer.cornerRadius = 6
        cell.Image.layer.cornerRadius = 6
        cell.Update(city: self.CityArray[indexPath.row])
        
        if self.SelectedCity?.id == self.CityArray[indexPath.row].id{
            UIView.animate(withDuration: 0.2) {
                cell.SelectedCellView.backgroundColor = #colorLiteral(red: 0.6636810899, green: 0.3209502697, blue: 0.1211987212, alpha: 1)
            }
        } else {
            cell.SelectedCellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.CityArray[indexPath.row].Name
        let width = estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
        return CGSize(width: width + 28, height: 40)
        
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
        return UIEdgeInsets(top: 0.0, left: 9.0, bottom: 0.0, right: 9.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if CityArray.count != 0 && indexPath.row <= CityArray.count{
            self.SelectedCity = self.CityArray[indexPath.row]
            self.IsSubCat = false
            self.IsSearched = false
            self.SearchTableViewTop.constant = 0
            GetAllCatrgories(CityId: self.CityArray[indexPath.row].id)
            self.CityCollectionView.reloadData()
        }
    }
    
    
}


class Place :  NSObject , MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var profileId = ""
    var title :String?
    var subtitle: String?
    
    init(coordinate : CLLocationCoordinate2D , profileId : String,title : String? , subtitle :String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.profileId = profileId
    }
    
}


class uitabbar : UITabBar{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.unselectedItemTintColor = UIColor.gray
    }
}

class profile : MKPointAnnotation {
    var profileId = ""
}
