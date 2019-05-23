//
//  AppDelegate.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps
protocol AppDelegateRefreshTokenProtocol {
    func refreshAccessTokenOnBase(compeletion: @escaping(APIResult<Void>)->Void)
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var state : String = ""
    var userdata = [User]()
    var FBuserdata = [FaceBookUser]()
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyDvL7BFDeuhTJMjHZgRA4Bwfs05RCVubq8")
        
        GIDSignIn.sharedInstance().clientID = "231942660556-p7tmduue9lbaite5g5abfukivdd7onra.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self as? GIDSignInDelegate
        GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/plus.me"]
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            
            //userdata.removeAll()
            print("User Has Already signed in using google")
            state = "logedin"
            
            let fetchRequest : NSFetchRequest<User> = User.fetchRequest()

            do {

                let userdata = try PercistanceService.context.fetch(fetchRequest)
                self.userdata = userdata

            } catch {

                print("Error occured while fetching core data")

            }

            print("user data ::: \(userdata)")
            let img = userdata.last

            if (userdata.count != 0) {

                StructProfile.ProfilePicture.ProfilePicURL = img!.profilepictureurl!
                StructProfile.ProfilePicture.email = img!.email!
                StructProfile.ProfilePicture.name = img!.name!
            
            }
            
        } else if FBSDKAccessToken.current() != nil {
            
            let fetchRequest : NSFetchRequest<FaceBookUser> = FaceBookUser.fetchRequest()
            
            do {
                
                let FBuserdata = try PercistanceService.context.fetch(fetchRequest)
                self.FBuserdata = FBuserdata
                
            } catch {
                
                print("Error occured while fetching core data")
                
            }
            
            print("user data ::: \(FBuserdata)")
            let img = FBuserdata.last
            
            if (FBuserdata.count != 0) {
                
                StructProfile.ProfilePicture.ProfilePicURL = img!.profilePicture!
                StructProfile.ProfilePicture.email = img!.email!
                StructProfile.ProfilePicture.name = img!.name!
                
            }
            
//            print("user is already logged in using facebook")
//            CPSocialSignInHelper.fetchProfile()
            state = "logedin"
        }
        else {
            print("user is not logged in")
            state = "logedout"
        }
        
        //UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        statusBar.backgroundColor = UIColor.black
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googles =  GIDSignIn.sharedInstance().handle(url as URL?,
                                                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let facebooks = FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        
        return googles || facebooks
        
    }
    
    private func application(application: UIApplication,
                             openURL url: URL, sourceApplication: String?, annotation: Any?) -> Bool {
        var _: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                      UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation! as AnyObject]
        let google = GIDSignIn.sharedInstance().handle(url as URL,
                                                       sourceApplication: sourceApplication,
                                                       annotation: annotation)
        
        let facebook = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return google || facebook
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PercistanceService.saveContext()
    }

    

}

