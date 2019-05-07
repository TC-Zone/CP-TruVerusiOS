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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var state : String = ""
   // var userdata = [User]()
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance().clientID = "231942660556-p7tmduue9lbaite5g5abfukivdd7onra.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self as? GIDSignInDelegate
        GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/plus.me"]
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            
            //userdata.removeAll()
            print("User Has Already signed in using google")
            state = "logedin"
            
//            let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
//
//            do {
//
//                let userdata = try PercistanceService.context.fetch(fetchRequest)
//                self.userdata = userdata
//
//            } catch {
//
//                print("Error occured while fetching core data")
//
//            }
//
//            print("user data ::: \(userdata)")
//            let img = userdata.last
//
//            if (userdata.count != 0) {
//
//                StructProfile.ProfilePicture.ProfilePicURL = img!.profileimageurl!
//                StructProfile.ProfilePicture.email = img!.email!
//                StructProfile.ProfilePicture.name = img!.name!
            
//            }
            
        } else if FBSDKAccessToken.current() != nil {
            
            print("user is already logged in using facebook")
            //fetchProfile()
            state = "logedin"
        }
        else {
            print("user is not logged in")
            state = "logedout"
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Truverus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

