//
//  moreVC.swift
//  searchSortDummy
//
//  Created by Infonium on 23/04/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit

class moreVC: UIViewController, webServicesDelegate {
    
    @IBOutlet weak var lblsk1Count: UILabel!
    @IBOutlet weak var lblsk1Target: UILabel!
    @IBOutlet weak var lblsk2Count: UILabel!
    @IBOutlet weak var lblsk2Target: UILabel!
    @IBOutlet weak var lblEngCount: UILabel!
    @IBOutlet weak var lblEngTarget: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var view1: SpringView!
    @IBOutlet weak var view2: SpringView!
    @IBOutlet weak var view3: SpringView!
    
    var webReq : webServices!
    //MARK: -
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.doInitialSetUp()
    }
    
    //MARK: -
    //MARK: - General Methods
    func doInitialSetUp() {
        //Initialize webservice
        webReq = webServices()
        webReq.delegate = self
        
        //Set logged username
        lblUserName.text = cfg.logName
        
        //For refresh/intialize offline data on change current day, week and month
        kAppDelegate.intializeAndLoadOfflineDataFromUserDefaults()
        
        //Set weekly data and check for weekly target achieve
        self.setWeeklyData()
        
        //Setup and load data from APIs
        self.setupAndUpdateAllData()
    }
  
    
    //MARK: -
    //MARK: - IBActions
    @IBAction func btnMedidateAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitLogAction(_ sender: UIButton) {
        //Check Internet connectivity
        if (AppDelegate.hasConnectivity() == false) {
            alertDialog(msg: cfg.no_internet)
            return
        }
        self.syncOfflineData("submitlog")
    }
    @IBAction func btnReviewThisMonthAction(_ sender: UIButton) {
        //Sync data if exist
        self.syncOfflineData("offlineData")
//        ReviewVC.type = "curr"
//        self.performSegue(withIdentifier: "reviewVC", sender: self)
        
        self.performSegue(withIdentifier: "monthWiseVC", sender: self)
    }
    @IBAction func btnReviewThisYearAction(_ sender: UIButton) {
        //Sync data if exist
        self.syncOfflineData("offlineData")
        
//        performSegue(withIdentifier: "toYearReview", sender: self)
        performSegue(withIdentifier: "yearWiseVC", sender: self)
    }
    @IBAction func btnSpecialAudiosAction(_ sender: Any) {
        //Sync data if exist
        self.syncOfflineData("offlineData")
        
        self.performSegue(withIdentifier: "toOtherMeditations", sender: self)
        
    }
    @IBAction func btnGoToSRMYoutubeChannelAction(_ sender: UIButton) {
        //Sync data if exist
        self.syncOfflineData("offlineData")
        
        let youtubeID =  "channel/UCRFZ-belq2nXuMHoWZGRu1Q" // Your Youtube ID here
        let youtubeChannelURL = NSURL(string: "youtube://www.youtube.com/\(youtubeID)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(youtubeChannelURL as URL) {
            if #available(iOS 10.0, *) {
                application.open(youtubeChannelURL as URL)
            } else {
                performSegue(withIdentifier: "toResources", sender: self)
            }
        } else {
            // if Youtube app is not installed, open URL inside the App
            performSegue(withIdentifier: "toResources", sender: self)
        }
        
    }
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        //Sync data if exist
        self.syncOfflineData("offlineData")
        
        self.alertDialogLogut() {
            self.logoutFromApp()
        }
    }
    
    @IBAction func btnPreferenceAction(_ sender: UIButton) {
        //Sync data if exist
        self.syncOfflineData("offlineData")
        
        self.performSegue(withIdentifier: "preferenceVC", sender: self)
    }
    
    //MARK: -
    //MARK: - Functions
    
    //Call APIs get weekly data and sync data if exist
    func setupAndUpdateAllData()  {
        
        //Call API get weekly target data
        self.getWeeklyTargetDetails()
        
        //Get weekly count data
        self.getWeeklyCounts()
        
        //Sync data if exist
        self.syncOfflineData("offlineData")
    }
    
    //For get weekly target details
    func getWeeklyTargetDetails() {
        //let req = "\(cfg.url)fetch_session_details_from_user_login.php?"
        let req = "\(cfg.url)fetch_session_details_from_user_login_v2.php?"
        let postparam = "uniqueId=\(cfg.uid)"
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "getDetails")
    }
    
    //Call get weekly counts data API
    func getWeeklyCounts() {
        let req2 = "\(cfg.url)week.php?"
        let postparam = "uniqueId=\(cfg.uid)"
        webReq.postRequest(reqStr: req2, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "weeklyCounts")
    }
    
    //Set weekly data and check for weekly target achieve
    func setWeeklyData()
    {
       //Set weekly counts
        lblsk1Count.text = "\(cfg.weekSK1)"
        lblsk2Count.text = "\(cfg.weekSK2)"
        lblEngCount.text = "\(cfg.weekEng)"
        
        //Set weekly targets
        lblsk1Target.text = "\(cfg.weekSK1T) MORE TO GO"
        lblsk2Target.text = "\(cfg.weekSK2T) MORE TO GO"
        lblEngTarget.text = "\(cfg.weekEngT) MORE TO GO"
        
        compareData(d1: cfg.weekSK1, d2: cfg.weekSK1T, lbl: lblsk1Target)
        compareData(d1: cfg.weekSK2, d2: cfg.weekSK2T, lbl: lblsk2Target)
        compareData(d1: cfg.weekEng, d2: cfg.weekEngT, lbl: lblEngTarget)
    }
    
    func compareData(d1 : Int, d2 : Int, lbl : UILabel)
    {
        if d1 >= d2
        {
            lbl.text = "0"//"TARGET ACHIEVED"
        }
        else{
            lbl.text = lbl == lblsk1Target ? "\(d2 - d1)" : "\(d2 - d1) MORE TO GO"
        }
    }
    

    func syncOfflineData(_ idStr:String) {
        
        let defaults = UserDefaults.standard
        
        //For User Data
        
        let reqq = "\(cfg.url)upload_offline_data_new.php?"
        
        /*
         //For Test
         cfg.dataStack = [:]
         cfg.SK1 = 0
         cfg.SK2 = 0
         cfg.Eng = 0
         cfg.Intrupt = 0
         let currentDay = "\(getCurrentDate())|\(cfg.SK1)|\(cfg.SK2)|\(cfg.Eng)|\(cfg.Intrupt)"
         cfg.dataStack[getCurrentDate()] = currentDay
         */
        
        print("Sync data records MoreVC===\(cfg.dataStack)")
        
        var jsonReqString : String = ""
        for (_,strWeeklyData) in cfg.dataStack {
            let weeklyData = strWeeklyData.components(separatedBy: "|")
            var dictReqData : [String : String] = [:]
            dictReqData["uniqueId"] = cfg.uid
            dictReqData["date"] = "\(Int(weeklyData[0].components(separatedBy: "-")[0])!)"
            dictReqData["SKL1"] = weeklyData[1]
            dictReqData["SKL2"] = weeklyData[2]
            dictReqData["Energization"] = weeklyData[3]
            dictReqData["interruption"] = weeklyData[4]
            dictReqData["tableName"] = weeklyData[0].components(separatedBy: "-")[1].lowercased()
            
//            if let sk1Data = defaults.object(forKey: cfg.ud_key_dailyTarget_SK1) as? String, let sk2Data = defaults.object(forKey: cfg.ud_key_dailyTarget_SK2) as? String {
//                if (sk1Data == getCurrentDate1() || sk2Data == getCurrentDate1()) && weeklyData[4] != "1" {
//                    return
//                }
//            }
////            if let sk2Data = defaults.object(forKey: cfg.ud_key_dailyTarget_SK2) as? String  {
////                if sk2Data == getCurrentDate1() && weeklyData[4] != "1" {
////                    return
////                }
////            }
//            
//            if weeklyData[1] != "0" {
//                UserDefaults.standard.set(getCurrentDate1(), forKey: cfg.ud_key_dailyTarget_SK1)
//            }
//            if weeklyData[2] != "0" {
//                UserDefaults.standard.set(getCurrentDate1(), forKey: cfg.ud_key_dailyTarget_SK2)
//            }
//            UserDefaults.standard.synchronize()
            
            var jsonDataString : String = ""
            do {
                let data = try JSONSerialization.data(withJSONObject: dictReqData, options: .prettyPrinted)
                jsonDataString = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            } catch {
                print(error)
            }
            if jsonReqString == "" {
                jsonReqString = jsonDataString
            } else {
                jsonReqString = jsonReqString+","+jsonDataString
            }
        }
        
        if jsonReqString != "" {
            if kAppDelegate.isSyncInProgress == false{
                kAppDelegate.isSyncInProgress = true
                let postparamq = "jsonString=[\(jsonReqString)]"
                webReq.postRequest(reqStr: reqq, postParams: postparamq.data(using: String.Encoding.utf8)! as AnyObject, reqId: idStr)
                loadingView(flag: true)
            }
        } else {
            
            if idStr == "submitlog" {
                alertDialog(msg: cfg.sync_completed)
            }
        }
    }
    
    //For logout user from app
    func logoutFromApp() {
        UserDefaults.standard.set("NO", forKey: cfg.is_user_logged)
        UserDefaults.standard.set(cfg.uid, forKey: cfg.ud_key_log)
        UserDefaults.standard.set(cfg.logName, forKey: cfg.ud_key_logN)
        UserDefaults.standard.set(cfg.password, forKey: cfg.ud_key_password)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let homeController =  mainStoryboard.instantiateViewController(withIdentifier: "login") as! LoginVC
        appDelegate?.window?.rootViewController = homeController
    }
    
    
    
    //MARK: -
    //MARK: - API Calls
    //MARK: - Webservice Delegate Methods
    
    func responseData(data: NSData, reqId: String) {
        let responseData = JSON(data: data as Data)
        if reqId == "getDetails"
        {
            print("Response Weekly Target Data===\(responseData)")
            
            let webResData = responseData.object as AnyObject
            
            var SKL1_Target = 0
            var SKL2_Target = 0
            var SKL3_Target = 0
            
            var strDeativated = ""
            if let data = webResData["result"] as? String{
                strDeativated = data
            }
            
            if strDeativated == "deactivated"{
                
                let alrt = UIAlertController(title: cfg.alert_title, message: cfg.deactivated_msg, preferredStyle: UIAlertController.Style.alert)
                
                let cancel = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (action) in
                    self.logoutFromApp()
                }
                alrt.addAction(cancel)
                alrt.view.tintColor = UIColor.blue
                self.present(alrt, animated: true, completion: nil)
                
            }else{
                
                guard let detailsArr = webResData["result"] as? [AnyObject] else {
                    return
                }
                guard let detailsDict = detailsArr[0] as? [String : Any] else {
                    return
                }
                
                if let strSKL1Count =  detailsDict["SKL1Target"] as? String, let strSKL2Count =  detailsDict["SKL2Target"] as? String, let strSKL3Count =  detailsDict["EnergizationTarget"] as? String{
                    if let intSKL1Count = Int(strSKL1Count){
                        SKL1_Target = intSKL1Count
                    }
                    if let intSKL2Count = Int(strSKL2Count){
                        SKL2_Target = intSKL2Count
                    }
                    if let intSKL3Count = Int(strSKL3Count){
                        SKL3_Target = intSKL3Count
                    }
                }
    
                
                cfg.weekSK1T = SKL1_Target
                cfg.weekSK2T = SKL2_Target
                cfg.weekEngT = SKL3_Target
                                
                //Save weekly target counts data to UserDefaults
                let weeklyTarget = "\(SKL1_Target)|\(SKL2_Target)|\(SKL3_Target)"
                UserDefaults.standard.set(weeklyTarget, forKey: cfg.ud_key_weekTarget)
                UserDefaults.standard.synchronize()
                
                
                //Set weekly data and check for weekly target achieve
                self.setWeeklyData()
            }
            
        }
        else if reqId == "weeklyCounts" {
            print("Response Weekly Counts Data===\(responseData)")
            
            let webResData = responseData.object as AnyObject
            
            guard let detailsArr = webResData["result"] as? [AnyObject] else {
                return
            }
            guard let detailsDict = detailsArr[0] as? [String : Any] else {
                return
            }
            
            if let intSKL1Count =  detailsDict["SKL1"] as? Int, let intSKL2Count =  detailsDict["SKL2"] as? Int, let intSKL3Count =  detailsDict["Energization"] as? Int{
                
                lblsk1Count.text = "\(intSKL1Count)"
                lblsk2Count.text = "\(intSKL2Count)"
                lblEngCount.text = "\(intSKL3Count)"
                
                cfg.weekSK1 = intSKL1Count
                cfg.weekSK2 = intSKL2Count
                cfg.weekEng = intSKL3Count
                
                debugPrint("Week No:\(cfg.weekNo), SwarajKriya1 Count:\(cfg.weekSK1), SwarajKriya2 Count:\(cfg.weekSK2), Energization Count:\(cfg.weekEng)  ")
                
                //Save weekly counts data to UserDefaults
                let weeklyCount = "\( getWeekNumber())|\(intSKL1Count)|\(intSKL2Count)|\(intSKL3Count)"
                UserDefaults.standard.set(weeklyCount, forKey: cfg.ud_key_weekLog)
                UserDefaults.standard.synchronize()
            }
            
            //Set weekly data and check for weekly target achieve
            self.setWeeklyData()
            
        }
        else if reqId == "submitlog" || reqId == "offlineData"
        {
             kAppDelegate.isSyncInProgress = false
            
            let strResponseData = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))

            if reqId == "submitlog" {
                alertDialog(msg: cfg.sync_completed)

                print("Response Sync(submitlog) Offline Data MoreVC===\(strResponseData ?? "")")
            }else{
                print("Response Sync Offline Data MoreVC===\(strResponseData ?? "")")
            }
            
            loadingView(flag: false)
            
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
                    
                    //Get weekly count data
                    self.getWeeklyCounts()
                }
            }
            
          
        }

    }
    
    func errorResponse(err: String, reqId: String) {
        print("Response \(reqId) err===\(err)")
        
        if reqId == "submitlog" || reqId == "offlineData"
        {
            kAppDelegate.isSyncInProgress = false
        }
        if reqId == "submitlog"
        {
            loadingView(flag: false)
            alertDialog(msg: err)
        }
        if reqId == "offlineData"
        {
            loadingView(flag: false)
        }
        
        
    }
    
    
}
