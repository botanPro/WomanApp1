//
//  AppDelegate.swift
//  WomanApp
//
//  Created by botan pro on 9/3/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import OneSignal
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate, OSSubscriptionObserver {
 

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(2)
        
        
        
        MainCategoryAPI.GetMainCategory(CityId: "1") { MainCategory in
           
        }
        
  
        FirebaseApp.configure()
        
        if UserDefaults.standard.integer(forKey: "Lang") == 0{
            UserDefaults.standard.set(1,forKey: "Lang")
        }
        
        
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("8ab7c5e8-318c-4aab-90f7-fdb86dae2415")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            OneSignal.add(self as OSSubscriptionObserver)
            print(OneSignal.getDeviceState().userId ?? "")
           UpdateOneSignalIdAPI.Update(onesignalUUID: OneSignal.getDeviceState().userId ?? "")
          })
        
        
        
        
        if #available(iOS 13.0, *){
            
        }else{
             self.window = UIWindow(frame: UIScreen.main.bounds)
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let newViewController = storyBoard.instantiateViewController(withIdentifier: "startVC")
             self.window!.rootViewController = newViewController
             self.window!.makeKeyAndVisible()
            
        }
        return true
    }
    
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges) {
        if !stateChanges.from.isSubscribed && stateChanges.to.isSubscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            UserDefaults.standard.set(playerId, forKey: "OneSignalId")
        }
    }


    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

