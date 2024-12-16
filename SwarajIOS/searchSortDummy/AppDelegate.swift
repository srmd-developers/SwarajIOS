//
//  AppDelegate.swift
//  searchSortDummy
//
//  Created by Infonium on 28/03/17.
//  Copyright © 2017 niket. All rights reserved.
//
//

import UIKit
import AudioToolbox
import AVFoundation
import Firebase
import UserNotifications
import FirebaseMessaging
import Fabric
import Crashlytics

extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, webServicesDelegate {
    
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var webReq : webServices!
    var callSyncMethod = false
    var isSyncInProgress = false

    // MARK: -
    // MARK: - Did Finish Launching Mtehods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        cfg.wd = (self.window?.frame.size.width)!
        cfg.ht = (self.window?.frame.size.height)!
        
        //When set to true, this means the screen will never dim or go to sleep while your app is running
        UIApplication.shared.isIdleTimerDisabled = true
        
        //Configure IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        
        //Intialize global variables from UserDefaults
        self.intializeAndLoadOfflineDataFromUserDefaults()
        
        
        //Cofiguration AVAudioSession
        var error: NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: .default)
        } catch let error1 as NSError{
            error = error1
            print("could not set session. err:\(error!.localizedDescription)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error1 as NSError{
            error = error1
            print("could not active session. err:\(error!.localizedDescription)")
        }
        
        
        //Register for remote notification
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
        
        
        //Fabric code(Intialialize Crashlytics)
        Fabric.with([Crashlytics.self])
        
        //Configure Firebase (FCM)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
                 
         //Initialize webservice
         webReq = webServices()
         webReq.delegate = self
         
         //Reachabilty
         self.callSyncMethod = true
         NotificationCenter.default.removeObserver(self)
         NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
         Reach().monitorReachabilityChanges()
         
        
        return true
    }
    
   
    // MARK: -
    // MARK: - Intialize global variables from UserDefaults
    func intializeAndLoadOfflineDataFromUserDefaults() {
        
        let defaults = UserDefaults.standard
        
        //For User Data
        if let data = defaults.object(forKey: cfg.ud_key_log) as? String {
            cfg.uid = data
        }
        if let data = defaults.object(forKey: cfg.ud_key_password) as? String {
            cfg.password = data
        }
        if let data = defaults.object(forKey: cfg.ud_key_logN) as? String {
            cfg.logName = data
        }
        
        //For Weekly Taget Data
        if let data = defaults.object(forKey: cfg.ud_key_weekTarget) as? String {
            let val = data.components(separatedBy: "|")
            cfg.weekSK1T = Int(val[0])!
            cfg.weekSK2T = Int(val[1])!
            cfg.weekEngT = Int(val[2])!
        }
        
        //For Weekly Data
        if let data = defaults.object(forKey: cfg.ud_key_weekLog) as? String {
            let val = data.components(separatedBy: "|")
            if getWeekNumber() == Int(val[0])! {
                cfg.weekNo = Int(val[0])!
                cfg.weekSK1 = Int(val[1])!
                cfg.weekSK2 = Int(val[2])!
                cfg.weekEng = Int(val[3])!
            } else{
                cfg.weekSK1 = 0
                cfg.weekSK2 = 0
                cfg.weekEng = 0
            }
        }
        
        //For Monthly Data
        if let data = defaults.object(forKey: cfg.ud_key_monthly) as? String {
            let val = data.components(separatedBy: "|")
            if getMonthNumber() == Int(val[0])!
            {
                cfg.monthNo = Int(val[0])!
                cfg.monthSK1 = Int(val[1])!
                cfg.monthSK2 = Int(val[2])!
                cfg.monthEng = Int(val[3])!
                cfg.monthIntrupt = Int(val[4])!
            }
            else{
                cfg.monthSK1 = 0
                cfg.monthSK2 = 0
                cfg.monthEng = 0
                cfg.monthIntrupt = 0
            }
        }
        
        //For Today Count Data
        if let data = defaults.object(forKey: cfg.ud_key_offlineLog) as? String {
            let val = data.components(separatedBy: "|")
            if getCurrentDate() == val[0] {
                cfg.SK1 = Int(val[1])!
                cfg.SK2 = Int(val[2])!
                cfg.Eng = Int(val[3])!
                cfg.Intrupt = Int(val[4])!
            } else {
                cfg.SK1 = 0
                cfg.SK2 = 0
                cfg.Eng = 0
                cfg.Intrupt = 0
            }
        }
        
        //For Offline Records of Weekly Count/Interruption Count, Using for synch to server
        if let data = defaults.object(forKey: cfg.ud_key_dataStack) as? [String : String] {
            cfg.dataStack = data
        }
        
        if let data = defaults.object(forKey: cfg.ud_key_dataStack2) as? [String] {
            cfg.dataStack2 = data
        }
        
        if let data = defaults.object(forKey: cfg.ud_key_dataStackI) as? [String] {
            cfg.dataStackI = data
        }
        
    }
    
   
    // MARK: - Date Time Functions
        func getWeekNumber() -> Int
        {
            let calendar = Calendar.current
            let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow:0))
            debugPrint("Current Week Of Year ==\(weekOfYear)")
            return weekOfYear
        }
    
    
       func getMonthNumber() -> Int
       {
           let calendar = Calendar.current
           let monthOfYear = calendar.component(.month, from: Date.init(timeIntervalSinceNow: 0))
           debugPrint("Current Month Of Year ==\(monthOfYear)")
           return monthOfYear
       }
       
       func getCurrentDate() -> String
       {
           let date = Date()
           let df : DateFormatter = DateFormatter()
           df.dateFormat = "dd-MMMM_yyyy"
           return df.string(from: date)
        
       }
       
    
    // MARK: -
    // MARK: - APNs Notifications Delegates Methods
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.hexString()
        debugPrint("token *****************: ", deviceTokenString)
        let defaults:UserDefaults = UserDefaults.standard
        
        defaults.set(deviceTokenString, forKey: cfg.kuser_Default_DeviceToken)
        defaults.synchronize()
        
    }
    
    
    //Call on tap of notification
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Push notification received: \(response)")
        let notificationDict:NSDictionary = response.notification.request.content.userInfo as NSDictionary
        if let Type:String = notificationDict.value(forKey: "type") as? String{
            debugPrint("Type: \(Type)")
            /*
             switch Type{
             case "1":
             // notification
             self.moveToNotification()
             break
             default:
             break
             }
             */
        }
        completionHandler()
        
    }
    
    //Call on to present notification when app in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.content.title == "Reminder" {
            if UIApplication.shared.applicationState == .active
            {
                let banner = Banner(title: "Reminder", subtitle: notification.request.content.body, image: UIImage(named: "AppIcon"), backgroundColor: UIColor.lightGray)
                banner.dismissesOnTap = true
                banner.show(duration: 300.0)
                
            }
            
            completionHandler([])
        }else{
            completionHandler([.alert, .badge, .sound])
        }
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print(userInfo)
        var msgTitle = ""
        var msgBody = ""
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["title"] as? String {
                    //Do stuff
                    msgTitle = message
                }
                if let bodyMsg = alert["title"] as? String {
                    //Do stuff
                    msgBody = bodyMsg
                }
            }
        }
        
        self.showNotificationAlert(header: msgTitle, msg: msgBody)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // MARK: - Notification Alerts
    
    
    func showNotificationAlert(header:String, msg:String)  {
        let banner = Banner(title: header, subtitle: msg, image: UIImage(named: "AppIcon"), backgroundColor: UIColor.lightGray)
        banner.dismissesOnTap = true
        banner.show(duration: 2.0)
        
    }
    // MARK: -
    // MARK: - FCM Notifications Delegates Methods
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    //    func application(received remoteMessage: MessagingRemoteMessage) {
    //        print(remoteMessage.appData)
    //        debugPrint("======FCM Messaging Remote Message Recieved======")
    //    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("======FCM TOPIC 1111  didReceiveRegistrationToken======\(String(describing: fcmToken))")
        Messaging.messaging().subscribe(toTopic: "swarajNoti")
        
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
        debugPrint("======FCM TOPIC 2222  didRefreshRegistrationToken======\(fcmToken)")
        
        Messaging.messaging().subscribe(toTopic: "swarajNoti")
        
    }
    
    // MARK: -
    // MARK: - UIApplication Life Cycle Delegates Methods
    
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
        if let topVC = UIApplication.getTopViewController() {
            debugPrint("topVC=======\(topVC)")
            
            //Refresh weekly counts data
            if topVC is moreVC {
                let moreVC = topVC as? moreVC
                //For refresh/intialize offline data on change current day, week and month
                kAppDelegate.intializeAndLoadOfflineDataFromUserDefaults()
                //Set weekly data and check for weekly target achieve
                moreVC?.setWeeklyData()
            }
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    // MARK: -
    // MARK: - CHEK NETWORK STATUS
    class func hasConnectivity() -> Bool {
        
        let reachability = Reachability()
        
        if (reachability?.currentReachabilityStatus == .reachableViaWWAN) {
            return true
        }
        else if (reachability?.currentReachabilityStatus == .reachableViaWiFi) {
            return true
        }
        else if (reachability?.currentReachabilityStatus == .notReachable) {
            return false
        }
        else {
            return false
        }
        
        
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        debugPrint("reachabilty userInfo=====\(String(describing: userInfo))")
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            self.callSyncMethod = true
            debugPrint("AppDelegate Not connected")
            self.refreshMeditationAudioList()
            break
        case .online(.wwan):
            debugPrint("AppDelegate Connected via WWAN")
            self.syncSwarajKriyaData()
            break
        case .online(.wiFi):
            debugPrint("AppDelegate Connected via WiFi")
            self.syncSwarajKriyaData()
            break
        }
    }
    // MARK: -
    // MARK: - Refresh Meditaion Audios On Netwok Change
    func refreshMeditationAudioList(){
        if let topVC = UIApplication.getTopViewController() {
            debugPrint("topVC=======\(topVC)")
            
            //Refresh weekly counts data
            if topVC is otherMeditationVC {
                let otherMediVC = topVC as? otherMeditationVC
                otherMediVC?.refreshMeditationAudioList()
            }
        }
    }
    // MARK: -
    // MARK: - Sync Offline Data When Internet Available
   func syncSwarajKriyaData(){
        if callSyncMethod == true
        {
            self.callSyncMethod = false
            debugPrint("=======SYNCHED FUNCTION CALLED========")
            self.syncOfflineData()
        }
        
    }
    
    func syncOfflineData(){
        //Refresh Meditaion Audios On Netwok Change
        self.refreshMeditationAudioList()

        //Call sync data API
        let reqq = "\(cfg.url)upload_offline_data_new.php?"
        
        print("Sync data records AppDelegate===\(cfg.dataStack)")
        
        var jsonReqString : String = ""
        for (_,strWeeklyData) in cfg.dataStack
        {
            let weeklyData = strWeeklyData.components(separatedBy: "|")
            var dictReqData : [String : String] = [:]
            dictReqData["uniqueId"] = cfg.uid
            dictReqData["date"] = "\(Int(weeklyData[0].components(separatedBy: "-")[0])!)"
            dictReqData["SKL1"] = weeklyData[1]
            dictReqData["SKL2"] = weeklyData[2]
            dictReqData["Energization"] = weeklyData[3]
            dictReqData["interruption"] = weeklyData[4]
            dictReqData["tableName"] = weeklyData[0].components(separatedBy: "-")[1].lowercased()
            var jsonDataString : String = ""
            do {
                let data = try JSONSerialization.data(withJSONObject: dictReqData, options: .prettyPrinted)
                jsonDataString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            }
            catch{
                print(error)
            }
            if jsonReqString == ""
            {
                jsonReqString = jsonDataString
            }
            else{
                jsonReqString = jsonReqString+","+jsonDataString
            }
        }
        
        if jsonReqString != "" {
            if self.isSyncInProgress == false{
                self.isSyncInProgress = true
                let postparamq = "jsonString=[\(jsonReqString)]"
                webReq.postRequest(reqStr: reqq, postParams: postparamq.data(using: String.Encoding.utf8)! as AnyObject, reqId: "offlineData")
            }
            
        }
        
    }

    
    //MARK: -
    //MARK: - API Calls
    //MARK: - Webservice Delegate Methods
    
    func responseData(data: NSData, reqId: String) {
         
        if reqId == "offlineData"
        {
            self.isSyncInProgress = false
            
            let strResponseData = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            print("Response Sync Offline Data AppDelegate===\(strResponseData ?? "")")

            if let dataStr = strResponseData{
                
                if dataStr.contains("success")
                {
                    cfg.dataStack = [:]
                    cfg.SK1 = 0
                    cfg.SK2 = 0
                    cfg.Eng = 0
                    cfg.Intrupt = 0
                    
                    //Save current day counts data to UserDefaults
                    let currentDay = "\(getCurrentDate())|\(cfg.SK1)|\(cfg.SK2)|\(cfg.Eng)|\(cfg.Intrupt)"
                    //cfg.dataStack[getCurrentDate()] = currentDay
                    UserDefaults.standard.set(currentDay, forKey: cfg.ud_key_offlineLog)
                    UserDefaults.standard.set(cfg.dataStack, forKey: cfg.ud_key_dataStack)
                    UserDefaults.standard.synchronize()

                }
            }
        }
    }
    
    func errorResponse(err: String, reqId: String) {
        print("Response AppDelegate \(reqId) err===\(err)")
        if  reqId == "offlineData"
        {
            kAppDelegate.isSyncInProgress = false
        }
        
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
// MARK: UIApplication extensions

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
