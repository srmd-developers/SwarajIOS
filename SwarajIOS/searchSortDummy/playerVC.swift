//
//  playerVC.swift
//  searchSortDummy
//
//  Created by Infonium on 23/04/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit
import AVFoundation

class playerVC: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var playedTime: UILabel!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var lblPlayPause: UILabel!
    @IBOutlet weak var vewVol: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var volProgess: UIProgressView!
    
    var audioPlayer: AVAudioPlayer!
    var isPlaying = false
    var timer = Timer()
    var timeInMin = 0
    static var fileName = ""
    var isIntrupt = false
    static var moveIt : Bool = false
    
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.doInitialSetUp()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.audioRouteChangeListener),
            name: AVAudioSession.routeChangeNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Save Audio Files Play Counts Data To UserDefaults
        self.saveAudioFilesPlayCountsDataToUserDefaults()
    }
    
    //MARK: -
    //MARK: - Preferred Status Bar Style Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
    //MARK: -
    //MARK: - General Methods
    //Initail Setup
    func doInitialSetUp() {
        // UIApplication.shared.statusBarStyle = .lightContent
        
        //When set to true, this means the screen will never dim or go to sleep while your app is running
        UIApplication.shared.isIdleTimerDisabled = true
        playerVC.moveIt = false
        isIntrupt = false
        
        lblHead.text = playerVC.fileName
        
        if playerVC.fileName == cfg.SK1FileName{
            imgBg.image = #imageLiteral(resourceName: "bg1")
            lblHead.text = "SwaRaj Kriya"
        }
        else if playerVC.fileName == cfg.SK2FileName{
            imgBg.image = #imageLiteral(resourceName: "bg1")
            lblHead.text = playerVC.fileName
        }
        else if playerVC.fileName == cfg.SK3FileName{
            imgBg.image = #imageLiteral(resourceName: "bg1")
            lblHead.text = "Meditation Music"
        }
        
    }
    
    //MARK: -
    //MARK: - IBActions
    @IBAction func btnBackAction(sender: AnyObject) {
        if isPlaying {
            isIntrupt = true
            self.updateInterruptionInAudioPlayingCounts()
        }
        else {
            //Dissmiss View Controller
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //Increase Audio Volume
    @IBAction func btnPlusAction(_ sender: Any) {
        if isPlaying {
            volProgess.setProgress(audioPlayer.volume + 0.1, animated: true)
            audioPlayer.volume = volProgess.progress
        }
        else {
            volProgess.setProgress(volProgess.progress + 0.1, animated: true)
        }
    }
    
    //Decrease Audio Volume
    @IBAction func btnMinusAction(_ sender: Any) {
        if isPlaying {
            volProgess.setProgress(audioPlayer.volume - 0.1, animated: true)
            audioPlayer.volume = volProgess.progress
        }
        else {
            volProgess.setProgress(volProgess.progress - 0.1, animated: true)
        }
    }
    
    //Play/Pause Audio
    @IBAction func playOrPauseMusic(sender: AnyObject) {
        
        if isPlaying {
            btnPlay.setImage(#imageLiteral(resourceName: "playWhite"), for: .normal)
            lblPlayPause.text = "Play"
            isIntrupt = true
            if timeInMin < 27/*Minutes*/ {
                self.updateInterruptionInAudioPlayingCounts()
            } else {
                audioPlayer.stop()
                audioPlayer.currentTime = 0
                timer.invalidate()
                isPlaying = false
                NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            isPlaying = true
            btnPlay.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            lblPlayPause.text = "Stop"
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let fileManager = FileManager()
            
            let destinationURLForFile = NSURL(fileURLWithPath: "\(documentDirectoryPath)/\(playerVC.fileName).mp3")//.stringByAppendingString("/file.pdf"))
            debugPrint(destinationURLForFile)
            
            if fileManager.fileExists(atPath: destinationURLForFile.path!){
                let audioFileUrl = NSURL.fileURL(withPath: destinationURLForFile.path!)
                play(url: audioFileUrl)
            }
            
        }
    }
    
    
    //MARK: -
    //MARK: - Functions
    //Play Audio through URL
    func play(url: URL) {
        debugPrint("playing \(url)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            //audioPlayer.enableRate = true
            //audioPlayer.rate = 60
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.volume = volProgess.progress
            //player.volume = 100.0
            audioPlayer.play()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playerVC.updateTime), userInfo: nil, repeats: true)
        } catch let error as NSError {
            //self.player = nil
            debugPrint(error.localizedDescription)
            btnPlay.setImage(#imageLiteral(resourceName: "playWhite"), for: .normal)
            lblPlayPause.text = "Play"
            isPlaying = false
            self.alertDialog(header: "Error", msg: error.localizedDescription)
        } catch {
            debugPrint("AVAudioPlayer init failed")
            btnPlay.setImage(#imageLiteral(resourceName: "playWhite"), for: .normal)
            lblPlayPause.text = "Play"
            isPlaying = false
            self.alertDialog(header: "Error", msg: cfg.something_went_wrong)
        }
    }
    
    //Display Audio progress
    @objc func updateTime() {
        //audioPlayer.rate = 2.0
        let currentTime = Int(audioPlayer.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        var finalTime = Int(audioPlayer.duration)
        if finalTime > 900 {
            finalTime = 1800
        }
        //let fminutes = finalTime/60
        //let fseconds = finalTime - fminutes * 60
        let playedAudioTime = NSString(format: "%02d:%02d", minutes,seconds) as String
        //let ft = NSString(format: "%02d:%02d", fminutes,fseconds) as String
        //let pc = Double(currentTime)/Double(finalTime)
        //debugPrint(audioPlayer.volume)
       // debugPrint("SECONDS:::", currentTime)
      //  debugPrint("MINUTES:::", minutes)
        timeInMin = minutes
        if currentTime == 27*60 { //2024
            updateAudioSuccessfullyFinishCounts()
        }
        debugPrint("Played Audio Time===\(playedAudioTime)")
        playedTime.text = "\(playedAudioTime)"//"/\(ft)"
        
    }
    
    //Update Adudio Files Successfully Finished Counts
    func updateAudioSuccessfullyFinishCounts() {
        
        //For refresh/intialize offline data on change current day, week and month
          kAppDelegate.intializeAndLoadOfflineDataFromUserDefaults()
                
//        timer.invalidate()
        if playerVC.fileName == cfg.SK1FileName{
            debugPrint("INSIDE updateAudioSuccessfullyFinishCounts")
            cfg.monthSK1 += 1
            cfg.weekSK1 += 1
            cfg.SK1 += 1
            cfg.dataStack2.append("\(getCurrentDate())|\(getCurrentDateTime())|SKL1")
        }
        else if playerVC.fileName == cfg.SK2FileName{
            cfg.monthSK2 += 1
            cfg.weekSK2 += 1
            cfg.SK2 += 1
            cfg.dataStack2.append("\(getCurrentDate())|\(getCurrentDateTime())|SKL2")
        }
        else if playerVC.fileName == cfg.SK3FileName{
            cfg.monthEng += 1
            cfg.weekEng += 1
            cfg.SK1 += 1
            cfg.dataStack2.append("\(getCurrentDate())|\(getCurrentDateTime())|SKL3")
        }
        else if playerVC.fileName == cfg.SK4FileName {
            print("SK4")
            cfg.monthSK1 += 1
            cfg.weekSK1 += 1
            cfg.SK1 += 1
            debugPrint("INSIDE updateAudioSuccessfullyFinishCounts SK4FileName")
            cfg.dataStack2.append("\(getCurrentDate())|\(getCurrentDateTime())|SKL1")
        }
        
        //Save Swaraj Kriya Files Data to UserDefaults
        UserDefaults.standard.set(cfg.dataStack2, forKey: cfg.ud_key_dataStack2)
        
        //Dissmiss View Controller
//        self.dismiss(animated: true, completion: nil)
    }
    
    //Update Adudio Files Interruption Counts
    func updateInterruptionInAudioPlayingCounts() {
        if isIntrupt {
            if isPlaying//audioPlayer != nil && audioPlayer.isPlaying
            {
                //For refresh offline data on cahnge current day, week an month
                  kAppDelegate.intializeAndLoadOfflineDataFromUserDefaults()
                
                audioPlayer.stop()
                audioPlayer.currentTime = 0
                timer.invalidate()
                isPlaying = false
                if playerVC.fileName == cfg.SK3FileName {
                    //do not increase intrruption counts
                } else {
                    cfg.Intrupt += 1
                    cfg.monthIntrupt += 1
                }
                cfg.dataStackI.append("\(getCurrentDate())|\(getCurrentDateTime())")
                //Save Interruption Counts To UserDefaults
                self.view.showToast(toastMessage: "Interruption Occured", duration: 3.0)
                UserDefaults.standard.set(cfg.dataStackI, forKey: cfg.ud_key_dataStackI)
            }
            
            //Remove Route Change Notification
            NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
            
            //Dissmiss View Controller
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    //Save Audio Files Play Counts Data To UserDefaults
    func saveAudioFilesPlayCountsDataToUserDefaults() {
          
        //Remove Route Change Notification
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
        
        // UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        let weekly = "\(getWeekNumber())|\(cfg.weekSK1)|\(cfg.weekSK2)|\(cfg.weekEng)"
        let monthly = "\(getMonthNumber())|\(cfg.monthSK1)|\(cfg.monthSK2)|\(cfg.monthEng)|\(cfg.monthIntrupt)"
        let currentDay = "\(getCurrentDate())|\(cfg.SK1)|\(cfg.SK2)|\(cfg.Eng)|\(cfg.Intrupt)"
        
        //Store everyday data on date basis
        cfg.dataStack[getCurrentDate()] = "\(getCurrentDate())|\(cfg.SK1)|\(cfg.SK2)|\(cfg.Eng)|\(cfg.Intrupt)"
        
        //Save Audio Files Play Counts Data To UserDefaults
        UserDefaults.standard.set(weekly, forKey: cfg.ud_key_weekLog)
        UserDefaults.standard.set(monthly, forKey: cfg.ud_key_monthly)
        UserDefaults.standard.set(currentDay, forKey: cfg.ud_key_offlineLog)
        UserDefaults.standard.set(cfg.dataStack, forKey: cfg.ud_key_dataStack)
        UserDefaults.standard.synchronize()
        
        //Flag to open MoreVC on dismiss PlayerVC
        playerVC.moveIt = true
    }
    
    //MARK: -
    //MARK: - AVAudioPlayer Delegates Methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            if playerVC.fileName != cfg.SK4FileName {
                self.updateAudioSuccessfullyFinishCounts()
            }
            self.timer.invalidate()
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    //MARK: -
    //MARK: - Audio Route Change Listener Notification
    //Called on plugged in/out headphone
    @objc private func audioRouteChangeListener(notification: NSNotification){
        
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
            debugPrint("headphone plugged in")
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
            isIntrupt = true
            debugPrint("headphone pulled out")
            DispatchQueue.main.async {
                self.updateInterruptionInAudioPlayingCounts()
            }
        default:
            break
        }
    }
    
}
