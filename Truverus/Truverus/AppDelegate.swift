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
import CoreNFC
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleMaps
import Alamofire
import ObjectMapper
import SVProgressHUD
import Firebase
import FirebaseMessaging
import UserNotifications
protocol AppDelegateRefreshTokenProtocol {
    func refreshAccessTokenOnBase(compeletion: @escaping(APIResult<Void>)->Void)
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var state : String = ""
    var userdata = [User]()
    var FBuserdata = [FaceBookUser]()
    var RegUserData = [RegisteredUserData]()
    var window: UIWindow?

    let defaults = UserDefaults.standard
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        
        if Messaging.messaging().fcmToken != nil {
            print("FCM Token IS : \(Messaging.messaging().fcmToken ?? "nil found")")
            
            StructProfile.ProfilePicture.FCMToken = Messaging.messaging().fcmToken ?? "not found"
            
            if self.defaults.value(forKey: keys.RegisteredUserID) != nil {
                print("user id is :: \(self.defaults.value(forKey: keys.RegisteredUserID) ?? "no user id found")")
            } else {
                print("user id not found on the device")
            }
            
            
        } else {
            print("couldnt recieve FCM token")
            
        }
        
        
        
        if defaults.value(forKey: "Refresh_Token") != nil {
            
            validateRefreshAccessToken()
            
        }
        
        
        NFCAvailability()
        
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
            

            state = "logedin"
        } else if defaults.value(forKey: keys.RegisteredUserID) !=  nil {
            
            print("im registered")
            
            let fetchRequest : NSFetchRequest<RegisteredUserData> = RegisteredUserData.fetchRequest()
            
            do {
                
                let Registereduserdata = try PercistanceService.context.fetch(fetchRequest)
                self.RegUserData = Registereduserdata
                
            } catch {
                
                print("Error occured while fetching core data")
                
            }
            
            print("user data ::: \(FBuserdata)")
            let img = RegUserData.last
            
            if (RegUserData.count != 0) {
                
                if img?.picture != nil {
                    print("picture in user defaults :: \(img!.picture!)")
                    StructProfile.ProfilePicture.ProfilePicURL = img!.picture!
                }
                if img?.email != nil {
                    StructProfile.ProfilePicture.email = img!.email!
                } else {
                    StructProfile.ProfilePicture.email = "-"
                }
                if img?.firstname != nil {
                    StructProfile.ProfilePicture.name = img!.firstname!
                } else {
                   StructProfile.ProfilePicture.name = "-"
                }
                
            }
            
            state = "logedin"
            
        }
        else {
            print("user is not logged in")
            state = "logedout"
        }
        
     
        UIApplication.shared.statusBarStyle = .lightContent
        
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
    
    func NFCAvailability(){
        
        var isNFCAvailable: Bool {
            if NSClassFromString("NFCNDEFReaderSession") == nil { return false }
            return NFCNDEFReaderSession.readingAvailable
        }
        
        if isNFCAvailable == false {
            
            let alert = UIAlertController(title: "Warning !", message: "Your phone doesn't have NFC capabilities.. you wont be able to use authentication services", preferredStyle: .alert)
            
            let actionYes = UIAlertAction(title: "Okay", style: .default, handler: { action in
                print("action yes handler")
            })
            
            
            alert.addAction(actionYes)
            
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            
        }
        
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("here 02")
        print(userInfo)
    }
    
    func extractUserInfo(userInfo: [AnyHashable : Any]) -> (title: String, body: String) {
        var info = (title: "", body: "")
        guard let aps = userInfo["aps"] as? [String: Any] else { return info }
        guard let alert = aps["alert"] as? [String: Any] else { return info }
        let title = alert["title"] as? String ?? ""
        let body = alert["body"] as? String ?? ""
        info = (title: title, body: body)
        return info
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print("here 01")
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
        let string1 = String(data: deviceToken, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        let theString:NSString = NSString(data: deviceToken, encoding: String.Encoding.ascii.rawValue)!
       
        print("apns token is :: \(theString)")
        
    }
    
  
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print(fcmToken)
        Messaging.messaging().subscribe(toTopic: "myTitleTest")
        print("subscribed to topic")
    }
    
    

    func validateRefreshAccessToken() {
        
        ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
            switch response {
            case let .success(data):
                self.serializeNewAccessToken(data: data)
                print(response)
            case .failure(let error):
                
                    GIDSignIn.sharedInstance().disconnect()
                    self.state = "logedout"
                    self.defaults.set(nil, forKey: keys.accesstoken)
                    
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    self.state = "logedout"
                    self.defaults.set(nil, forKey: keys.accesstoken)
                   
                
                print("error in retrieving new access token user has been force logged out :: \(error)")
            }
        })
        
    }
    
    func serializeNewAccessToken(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let newTokenResponse: RefreshAccessTokenData = Mapper<RefreshAccessTokenData>().map(JSONObject: json) else {
                return
            }
            
            defaults.set(newTokenResponse.access_token, forKey: "Access_Token")
            
            defaults.set(newTokenResponse.refresh_token, forKey: "Refresh_Token")
            print("User defaults updated!!")
            
        }catch {
            print(error)
        }
        
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let info = self.extractUserInfo(userInfo: userInfo)
        print(info.title)
        print(info.body)
        
        
        
        switch UIApplication.shared.applicationState {
        case .active:
            //app is currently active, can update badges count here
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            let navigationController = self.window?.rootViewController as? UINavigationController
            let homeStoryBoard : UIStoryboard = UIStoryboard(name: "Inbox", bundle: nil)
            let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPInboxViewController") as! CPInboxViewController
            
            navigationController?.pushViewController(vc, animated: true)
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            let navigationController = self.window?.rootViewController as? UINavigationController
            let storyBoard: UIStoryboard = UIStoryboard(name: "CPHomeView", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
            navigationController?.pushViewController(newViewController, animated: true)
            
            break
        default:
            break
        }

        
        
        
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        Messaging.messaging().subscribe(toTopic: "myTitleTest") { error in
            print("Subscribed to test topic")}
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message data", remoteMessage.appData)
        
    }
    
}


