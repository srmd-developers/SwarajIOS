//
//  dashboardVC.swift
//  searchSortDummy
//
//  Created by Infonium on 28/03/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import Crashlytics

class dashboardVC: UIViewController, webServicesDelegate, URLSessionDownloadDelegate {
    
    @IBOutlet weak var inspireview: SpringView!
    
    @IBOutlet weak var moreView: SpringView!
    var webReq : webServices!
    var webResImage: AnyObject!
    
    let transitionManager = TransitionAnimator()
    @IBOutlet weak var imgView1: SpringImageView!
    @IBOutlet weak var imgView2: SpringImageView!
    @IBOutlet weak var imgView3: SpringImageView!
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    @IBOutlet weak var btnSK1: UIButton!
    @IBOutlet weak var btnSK2: UIButton!
    @IBOutlet weak var btnSK3: UIButton!
    
    var PR_sk1 : UICircularProgressRingView!
    var PR_sk2 : UICircularProgressRingView!
    var PR_eng : UICircularProgressRingView!
    var PR_sk4 : UICircularProgressRingView!
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.doInitialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //For check audio file exist or not in Document Directory
        self.checkAudioFilesStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check More View Controller is alrady presented
        if playerVC.moveIt == true {
            playerVC.moveIt = false
            //Move to More View Controller
            self.moveToMoreVC()
        }
    }
    
    //MARK: -
    //MARK: - General Methods
    func doInitialSetUp() {
        /*
         //Code for force crashlytic crash
         let button = UIButton(type: .roundedRect)
         button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
         button.setTitle("Crash", for: [])
         button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
         view.addSubview(button)
         
         */
        
        webReq = webServices()
        webReq.delegate = self
        
        //Call Get Weekly Target Data API
        self.getWeeklyTargetDetails()
        
        //Call get weekly counts data API
        self.getWeeklyCounts()
        
        //Call Inspiration Data API
        self.openInspirationTab()
        
        //Call Get Special Meditations Audios Data API
        self.getSpecialAudios()
        
    }
    
    //For check audio file exist or not in Document Directory
    func checkAudioFilesStatus() {
        //Set animation on Inspire and More Tab
        inspireview.animation = "slideDown"
        inspireview.animate()
        
        moreView.animation = "slideUp"
        moreView.animate()
        
        //Check audio file exist or not in Document Directory
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        
        let destinationURLForFile1 = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(cfg.SK1FileName).mp3")
        if fileManager.fileExists(atPath: destinationURLForFile1.path!){
            imgView1.image = #imageLiteral(resourceName: "play")
            self.manageSKFilesDownlodingButtonActions(flag: true, fileName: cfg.SK1FileName)
        }
        
        let destinationURLForFile2 = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(cfg.SK2FileName).mp3")
        if fileManager.fileExists(atPath: destinationURLForFile2.path!){
            imgView2.image = #imageLiteral(resourceName: "play")
            self.manageSKFilesDownlodingButtonActions(flag: true, fileName: cfg.SK2FileName)
        }
        
        let destinationURLForFile3 = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(cfg.SK3FileName).mp3")
        if fileManager.fileExists(atPath: destinationURLForFile3.path!){
            imgView3.image = #imageLiteral(resourceName: "play")
            self.manageSKFilesDownlodingButtonActions(flag: true, fileName: cfg.SK3FileName)
        }
        
        let destinationURLForFile4 = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(cfg.SK4FileName).mp3")
        if fileManager.fileExists(atPath: destinationURLForFile4.path!){
            imgView3.image = #imageLiteral(resourceName: "play")
            self.manageSKFilesDownlodingButtonActions(flag: true, fileName: cfg.SK4FileName)
        }
    }
    /*
     @IBAction func crashButtonTapped(_ sender: AnyObject) {
     Crashlytics.sharedInstance().crash()
     }*/
    
    
    //MARK: -
    //MARK: - IBActions
    @IBAction func btnLogOutAction(_ sender: Any) {
        self.alertDialogLogut() {
            self.logoutFromApp()
        }
    }
    
    @IBAction func btnSK1Action(_ sender: Any) {
        playerVC.fileName = cfg.SK1FileName
        
//        if (cfg.weekSK1T + 1 - cfg.weekSK1 <= 0) {
//            
//            //let b = String(describing: cfg.weekSK1);
//            //let c = String(describing: cfg.weekSK1T);
//            //var sonam = "Target achieved, Come back next week.";
////            alertDialog(header: "Alert", msg: "Target achieved, Come back next week.");
//        } else {
            let currentRoute = AVAudioSession.sharedInstance().currentRoute
            for description in currentRoute.outputs {
                if convertFromAVAudioSessionPort(description.portType) == convertFromAVAudioSessionPort(AVAudioSession.Port.headphones) {
                    debugPrint("headphone plugged in")
                    if imgView1.image == #imageLiteral(resourceName: "play")
                    {
                        alertAirplaneModeDialog2Btns() {
                            self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView1)
                        }
                    }
                    else{
                        checkFile(fileName: playerVC.fileName, imgVew: self.imgView1)
                    }
                } else {
                    if imgView1.image == #imageLiteral(resourceName: "play")
                    {
                        self.alertNoEarphoneConnectedDialog2Btns() {
                            self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView1)
                        }
                    }else{
                        self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView1)
                        
                    }
                    
                }
            }
//        }
    }
    
    @IBAction func btnSK2Action(_ sender: Any) {
        playerVC.fileName = cfg.SK2FileName
        
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        for description in currentRoute.outputs {
            if convertFromAVAudioSessionPort(description.portType) == convertFromAVAudioSessionPort(AVAudioSession.Port.headphones) {
                debugPrint("headphone plugged in")
                if imgView2.image == #imageLiteral(resourceName: "play")
                {
                    alertAirplaneModeDialog2Btns() {
                        self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView2)
                    }
                }
                else{
                    checkFile(fileName: playerVC.fileName, imgVew: self.imgView2)
                }
            } else {
                if imgView2.image == #imageLiteral(resourceName: "play")
                {
                    
                    self.alertNoEarphoneConnectedDialog2Btns() {
                        self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView2)
                    }
                    
                }else{
                    self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView2)
                }
            }
        }
        
        
    }
    
    @IBAction func btnErgAction(_ sender: UIButton) {
        playerVC.fileName = cfg.SK4FileName//cfg.SK3FileName
        
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        for description in currentRoute.outputs {
            if convertFromAVAudioSessionPort(description.portType) == convertFromAVAudioSessionPort(AVAudioSession.Port.headphones) {
                debugPrint("headphone plugged in")
                if imgView3.image == #imageLiteral(resourceName: "play")
                {
                    alertAirplaneModeDialog2Btns() {
                        self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView3)
                    }
                }
                else{
                    checkFile(fileName: playerVC.fileName, imgVew: self.imgView3)
                }
            } else {
                if imgView3.image == #imageLiteral(resourceName: "play")
                {
                    self.alertNoEarphoneConnectedDialog2Btns() {
                        self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView3)
                    }
                    
                }else{
                    self.checkFile(fileName: playerVC.fileName, imgVew: self.imgView3)
                }
            }
        }
        
    }
    
    
    @IBAction func btnPreferenceAcrion(_ sender: Any) {
        self.performSegue(withIdentifier: "preferenceVC", sender: self)
    }
    
    @IBAction func btnInspireAction(_ sender: UIButton) {
        
        if webResImage != nil {
            performSegue(withIdentifier: "toImages", sender: self)
        }else{
            //Check nework connection
            if (AppDelegate.hasConnectivity() == false) {
                alertDialog(msg: cfg.no_internet)
            }else{
                self.openInspirationTab()
            }
        }
    }
    
    
    @IBAction func btnMoreAction(_ sender: UIButton) {
        //Move to player View Controller
        self.moveToMoreVC()
    }
    
    //MARK: -
    //MARK: - Functions
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
    
    //For get Inspiration data
    func openInspirationTab()  {
        let req1 = "\(cfg.url)inspire_tab.php?"
        webReq.getRequest(reqStr: req1, reqId: "inspire")
    }
    //For get special meditation auidos
    func getSpecialAudios() {
        let req = "\(cfg.url)special_meditation1.php?"
        let postparam = ""
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "getSpecialMeditationsAudios")
    }
    
    
    //For move to Player View Controller
    func moveToPlayerVC(){
        self.performSegue(withIdentifier: "toPlayerVC", sender: self)
    }
    //For move to More View Controller
    func moveToMoreVC(){
        self.performSegue(withIdentifier: "moreVC", sender: self)
    }
    
    //For logout from app
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
    
    //For check audio exist or not in Document Directory
    func checkFile(fileName : String, imgVew : UIImageView)
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        
        let destinationURLForFile = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(fileName).mp3")
        debugPrint(destinationURLForFile)
        
        if fileManager.fileExists(atPath: destinationURLForFile.path!){
            
            //Update audio file status
            self.updateFileStatus(fileName: fileName)
            
            //Move to player View Controller
            self.moveToPlayerVC()
        }
        else{
            //Check Internet connectivity
            if (AppDelegate.hasConnectivity() == false) {
                alertDialog(msg: cfg.no_internet)
                return
            }
            
            //Cifigure progress imageview
            let progressRing = UICircularProgressRingView(frame: CGRect(x: -10, y: -10, width: imgVew.frame.width + 10, height: imgVew.frame.height + 10))
            // Change any of the properties you'd like
            progressRing.maxValue = 100
            progressRing.outerRingWidth = 0.5
            progressRing.outerRingColor = UIColor.clear
            progressRing.innerRingColor = UIColor.red
            progressRing.innerRingWidth = 2
            progressRing.backgroundColor = colorCode.btnClr
            
            //let sampleAudioUrl = "http://www.hubharp.com/web_sound/BachGavotteShort.mp3"//16Second
            
            //Set Audio file URLs
            var urlStr = ""
            switch(fileName)
            {
            case cfg.SK1FileName :
                PR_sk1 = progressRing
                PR_sk1.font = UIFont.systemFont(ofSize: 14)
                imgVew.addSubview(PR_sk1)
//                urlStr = "\(cfg.baseUrl)audio/SwaRajKriya6.mp3"//For 2021
                urlStr = "\(cfg.baseUrl)audio/SwaRajKriya7_2023.mp3"//For 2021
                
                break
            case cfg.SK2FileName :
                PR_sk2 = progressRing
                PR_sk2.font = UIFont.systemFont(ofSize: 14)
                imgVew.addSubview(PR_sk2)
                urlStr = "\(cfg.baseUrl)audio/SwarajKriya2.mp3"//Server
                
                break
            case cfg.SK3FileName :
                PR_eng = progressRing
                PR_eng.font = UIFont.systemFont(ofSize: 14)
                imgVew.addSubview(PR_eng)
                urlStr = "\(cfg.baseUrl)audio/SwaRajKriya7_2023_extended.mp3"//For 2021
                
                break
                
            case cfg.SK4FileName :
                PR_sk4 = progressRing
                PR_sk4.font = UIFont.systemFont(ofSize: 14)
                imgVew.addSubview(PR_sk4)
                urlStr = "\(cfg.baseUrl)audio/BreathingMusic.mp3"//For 2023

                break

            default :
                break
            }
            
            self.manageSKFilesDownlodingButtonActions(flag: false, fileName: fileName)
            
            //Configure URLSession to downloading audio files
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: fileName)
            backgroundSession = URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            downloadTask = backgroundSession.downloadTask(with: URL(string: urlStr)! )
            downloadTask.resume()
            
        }
    }
    
    //For update aduios file status
    func updateFileStatus(fileName : String)
    {
        if fileName == cfg.SK1FileName{
            imgView1.image = #imageLiteral(resourceName: "play")
        }
        else if fileName == cfg.SK2FileName{
            imgView2.image = #imageLiteral(resourceName: "play")
        }
        else if fileName == cfg.SK3FileName{
            imgView3.image = #imageLiteral(resourceName: "play")
        }
        else if fileName == cfg.SK4FileName{
            imgView3.image = #imageLiteral(resourceName: "play")
        }
    }
    
    //Manage (Enable/Disable) SKFiles Downloding Button Actions
    func manageSKFilesDownlodingButtonActions(flag: Bool, fileName : String)
    {
        if fileName == cfg.SK1FileName{
            btnSK1.isUserInteractionEnabled = flag
        }
        else if fileName == cfg.SK2FileName{
            btnSK2.isUserInteractionEnabled = flag
        }
        else if fileName == cfg.SK3FileName{
            btnSK3.isUserInteractionEnabled = flag
        }
        else if fileName == cfg.SK4FileName{
            btnSK3.isUserInteractionEnabled = flag
        }
    }
    //MARK: -
    //MARK: - UIStoryboardSegue delegates method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImages" {
            let vc = segue.destination as! ImageVC
            vc.webImg = webResImage
            vc.transitioningDelegate = self.transitionManager
        }
        
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
            
            //Check if user Authentication has been deactivated, logged out from app
            if strDeativated == "deactivated"{
                
                let alrt = UIAlertController(title: cfg.alert_title, message: cfg.deactivated_msg, preferredStyle: UIAlertController.Style.alert)
                
                let cancel = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (action) in
                    self.logoutFromApp()
                }
                alrt.addAction(cancel)
                alrt.view.tintColor = UIColor.blue
                self.present(alrt, animated: true, completion: nil)
                
            }else{
                
                //Parse Weekly Target Data
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
                let weeklyTarget = "\(SKL1_Target)|\(SKL2_Target)|\(SKL3_Target)"
                
                //Save Weekly Target Data Offline
                UserDefaults.standard.set(weeklyTarget, forKey: cfg.ud_key_weekTarget)
                UserDefaults.standard.synchronize()
                
                //Set Weekly Target Data
                cfg.weekSK1T = SKL1_Target
                cfg.weekSK2T = SKL2_Target
                cfg.weekEngT = SKL3_Target
            }
            
        }
        else if reqId == "inspire" {
            print("Response inspirations Data===\(responseData)")
            
            webResImage = responseData.object as AnyObject
            
        }else if reqId == "weeklyCounts" {
            print("Response Weekly Counts Data===\(responseData)")
            
            let webResData = responseData.object as AnyObject
            
            guard let detailsArr = webResData["result"] as? [AnyObject] else {
                return
            }
            guard let detailsDict = detailsArr[0] as? [String : Any] else {
                return
            }
            
            if let intSKL1Count =  detailsDict["SKL1"] as? Int, let intSKL2Count =  detailsDict["SKL2"] as? Int, let intSKL3Count =  detailsDict["Energization"] as? Int{
              
                cfg.weekSK1 = intSKL1Count
                cfg.weekSK2 = intSKL2Count
                cfg.weekEng = intSKL3Count
                
                debugPrint("Week No:\(cfg.weekNo), SwarajKriya1 Count:\(cfg.weekSK1), SwarajKriya2 Count:\(cfg.weekSK2), Energization Count:\(cfg.weekEng)  ")
                
                //Save weekly counts data to UserDefaults
                let weeklyCount = "\( getWeekNumber())|\(intSKL1Count)|\(intSKL2Count)|\(intSKL3Count)"
                UserDefaults.standard.set(weeklyCount, forKey: cfg.ud_key_weekLog)
                UserDefaults.standard.synchronize()
            }
            
        }else if  reqId == "getSpecialMeditationsAudios"{
            
            print("Response Meditations Audios===\(responseData)")
            
            guard let otherMeditationsData = (responseData.object as AnyObject)["result"] as? [AnyObject] else {
                return
            }
            
            //Save Special Meditation Audios Data Offline
            UserDefaults.standard.set(otherMeditationsData, forKey: cfg.ud_key_special)
            UserDefaults.standard.synchronize()
            
        }
    }
    
    
    func errorResponse(err: String, reqId: String) {
        print("Response \(reqId) err===\(err)")
    }
    
    //MARK: -
    //MARK: - URLSession delegates mathods
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint(location)
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        //let destinationURLForFile = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(playerVC.fileName).mp3")//.stringByAppendingString("/file.pdf"))
        let destinationURLForFile = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(session.configuration.identifier ?? "").mp3")

        debugPrint("File identifier===\(session.configuration.identifier ?? "") destinationURLForFile==\(destinationURLForFile), didFinishDownloadingTo called")

        try? fileManager.removeItem(at: destinationURLForFile as URL)
        if fileManager.fileExists(atPath: destinationURLForFile.path!){
            do {
                try _ = fileManager.replaceItemAt(destinationURLForFile as URL , withItemAt: location)
                
                self.updateFileStatus(fileName: session.configuration.identifier ?? "")
                self.manageSKFilesDownlodingButtonActions(flag: true, fileName: session.configuration.identifier ?? "")
            }catch{
                debugPrint("An error occurred while moving file to destination url")
            }
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile as URL)
                self.updateFileStatus(fileName: session.configuration.identifier ?? "")
                self.manageSKFilesDownlodingButtonActions(flag: true, fileName: session.configuration.identifier ?? "")
            }catch{
                debugPrint("An error occurred while moving file to destination url")
            }
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
        let percentComplete = 100.0 * Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        debugPrint("File identifier===\(session.configuration.identifier ?? "") Progress===\(percentComplete)")
        switch(session.configuration.identifier!)
        {
        case cfg.SK1FileName :
            PR_sk1.setProgress(value: CGFloat(percentComplete), animationDuration: 1.0)
            break
            
        case cfg.SK2FileName :
            PR_sk2.setProgress(value: CGFloat(percentComplete), animationDuration: 1.0)
            break
            
        case cfg.SK3FileName :
            PR_eng.setProgress(value: CGFloat(percentComplete), animationDuration: 1.0)
            break
            
        case cfg.SK4FileName :
            PR_sk4.setProgress(value: CGFloat(percentComplete), animationDuration: 1.0)
            break
            
        default :
            break
        }
        //debugPrint("\(totalBytesWritten)|\(totalBytesExpectedToWrite)")
        //debugPrint(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        //progressView.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        //progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        if (error != nil) {
            print(error!)
        }else{
            debugPrint("The task finished transferring data successfully")
        }
        switch(session.configuration.identifier!)
        {
        case cfg.SK1FileName :
            PR_sk1.removeFromSuperview()
            break
            
        case cfg.SK2FileName :
            PR_sk2.removeFromSuperview()
            break
            
        case cfg.SK3FileName :
            PR_eng.removeFromSuperview()
            break
            
        case cfg.SK4FileName :
            PR_sk4.removeFromSuperview()
            break
            
        default :
            break
        }
    }
        
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionPort(_ input: AVAudioSession.Port) -> String {
    return input.rawValue
}
