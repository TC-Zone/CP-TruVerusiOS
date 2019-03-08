//
//  AppDelegate.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/20/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    let tb = CustomTabbarController()
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let myTabBar = self.window?.rootViewController as! UITabBarController // Getting Tab Bar
        GIDSignIn.sharedInstance().clientID = "552344458557-n8domd6feu1ecpllsnud9t2cos3jp53o.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self as? GIDSignInDelegate
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().delegate = self as? GIDSignInDelegate
        /* check for user's token */
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("User Has Already signed in")
        
            myTabBar.selectedIndex = 1
        } else {
            print("User Has Not signed in")
        }
        
        if FBSDKAccessToken.current() != nil {
            print("user is already logged in using facebook")
            myTabBar.selectedIndex = 1
        }
        else {
            print("user is not logged in using facebook")
        }
        
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
    }
    
}

extension CPHomeViewController  {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let layout = collection.collectionViewLayout as? SnapPagingLayout else { return }
        layout.willBeginDragging()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collection.collectionViewLayout as? SnapPagingLayout else { return }
        layout.willEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
}

