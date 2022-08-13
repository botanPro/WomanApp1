//
//  loginVC.swift
//  WomanApp
//
//  Created by botan pro on 10/9/21.
//

import UIKit
import Firebase
import FirebaseAuth
import Alamofire
import SwiftyJSON
class loginVC: UIViewController {
    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var Dismiss: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func Login(_ sender: Any) {
        if self.Name.text != "" && self.PhoneNumber.text != ""{
            PhoneProvide()
        }else{
            EmptyPhon()
        }
    }
    
    
    
    
    
    
    
    var phone = ""
    func PhoneProvide(){
        let first4 = String(self.PhoneNumber.text!.prefix(4))
        let first3 = String(self.PhoneNumber.text!.prefix(3))
        if first4 == "+964" || first3 == "964"{
            self.phone = "\(self.PhoneNumber.text!)";
        }else{
            self.phone = "+964\(self.PhoneNumber.text!)";
        }
        print(self.PhoneNumber.text!.count)
        if self.PhoneNumber.text!.count < 11{
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                print("helooooooooo")
                print(error)
                let myMessage = error.localizedDescription
                let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
                return
            }
            
            
            
            
            self.VerificationId = verificationID ?? ""
            print(verificationID?.description as Any)
            self.Alert()
        }
        }else{
            var myMessage = ""
            if XLanguage.get() == .English{
               myMessage = "please use (750) instead of (0750)."
            }
            if XLanguage.get() == .Arabic{
                myMessage = "الرجاء استخدم (750) بدلا من (0750)"
            }
            if XLanguage.get() == .Kurdish{
                myMessage = "هیڤیە (750) ل جهێ (0750) بکاربینە."
            }
            let myAlert = UIAlertController(title: nil, message: myMessage, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    var VerificationId = ""
    func Alert(){
        let alert = UIAlertController(title: "Verification Code", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
        textField.placeholder = "Enter Code Here"
        textField.textAlignment = .center
            textField.keyboardType = .phonePad
        }
        
        alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text != ""{
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: self.VerificationId ,
                    verificationCode: textField?.text ?? "")
                
                
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        let myMessage = error.localizedDescription
                        let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
                        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(myAlert, animated: true, completion: nil)
                        return
                    }
                    
                    
                    if ((authResult?.user) != nil){
                        UserDefaults.standard.set(authResult?.user.uid, forKey: "UserId")
                        UserDefaults.standard.set(true, forKey: "Login")
                        UserDefaults.standard.set(self.Name.text!, forKey: "Name")
                        UserDefaults.standard.set(self.phone, forKey: "PhoneNumber")
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func EmptyPhon(){
        if self.PhoneNumber.text == ""{
            if XLanguage.get() == .Arabic{
                let myAlert = UIAlertController(title: "الرجاء ادخال رقم الهاتف.", message: nil, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "نعم", style: UIAlertAction.Style.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
            }else if XLanguage.get() == .Kurdish{
                let myAlert = UIAlertController(title: "هيڤييه ژمارا تێلەفونێ بنڤيسه.", message: nil, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "بەلێ", style: UIAlertAction.Style.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
            }else if XLanguage.get() == .English{
                let myAlert = UIAlertController(title: "Pleas enter your phone number.", message: nil, preferredStyle: UIAlertController.Style.alert)
                myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
            }
         }
        
        
        if self.Name.text == "" {
           if XLanguage.get() == .Arabic{
               let myAlert = UIAlertController(title:"الرجاء ادخل اسمك.", message: nil, preferredStyle: UIAlertController.Style.alert)
               myAlert.addAction(UIAlertAction(title: "نعم", style: UIAlertAction.Style.default, handler: nil))
               self.present(myAlert, animated: true, completion: nil)
           }else if XLanguage.get() == .Kurdish{
               let myAlert = UIAlertController(title:  "هیڤیە ناڤێ خو بنڤیسە.", message: nil, preferredStyle: UIAlertController.Style.alert)
               myAlert.addAction(UIAlertAction(title: "بەلێ", style: UIAlertAction.Style.default, handler: nil))
               self.present(myAlert, animated: true, completion: nil)
           }else if XLanguage.get() == .English{
               let myAlert = UIAlertController(title: "Pleas enter your name.", message: nil, preferredStyle: UIAlertController.Style.alert)
               myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
               self.present(myAlert, animated: true, completion: nil)
           }
        }
    }
}
extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            guard let digit = Self.formatter.number(from: String($0)) else {
                assertionFailure("Can not convert to number from: \(original)")
                return (original, original)
            }
            guard let localized = Self.formatter.string(from: digit) else {
                assertionFailure("Can not convert to string from: \(digit)")
                return (original, original)
            }
            return (original, localized)
        }

        var converted = self
        for map in maps { converted = converted.replacingOccurrences(of: map.original, with: map.converted) }
        return converted
    }
}

