//
//  otherMeditationVC.swift
//  searchSortDummy
//
//  Created by Shivam Dubey on 26/10/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit
import AVFoundation


class otherMeditationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate, URLSessionDownloadDelegate {
    
    
    @IBOutlet weak var tableMeditation: UITableView!
    //Custom Audio Player Bottom container view
    @IBOutlet weak var viewContainerBottom: UIView!
    @IBOutlet weak var imgVwBottom: UIImageView!
    @IBOutlet weak var lblBottomDesc: UILabel!
    @IBOutlet weak var btnPlayPauseBottom: UIButton!
    @IBOutlet weak var lblTitleBottom: UILabel!
    @IBOutlet weak var bottomViewHeightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var btnPlayBottomHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var lblTitleBottomHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var lblTitleBottomTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var lblTitleBottomBelowConstarint: NSLayoutConstraint!
    @IBOutlet weak var lblDescBottomBelowConstarint: NSLayoutConstraint!
    @IBOutlet weak var tblBottomHeightConstarint: NSLayoutConstraint!
    
    
    //Custom Audio Player Full container view
    @IBOutlet weak var viewContainerFullView: UIView!
    @IBOutlet weak var lblTitleFullContainer: UILabel!
    @IBOutlet weak var imgVwFullContainer: UIImageView!
    @IBOutlet weak var lblAudioProgress: UILabel!
    @IBOutlet weak var lblAudioLength: UILabel!
    @IBOutlet weak var progressBarFullContainer: UIProgressView!
    @IBOutlet weak var btnPrevFullContainer: UIButton!
    @IBOutlet weak var btnPlayPauseFullContainer: UIButton!
    @IBOutlet weak var btnNextFullContainer: UIButton!
    @IBOutlet weak var lblTitleFullView: UILabel!
    @IBOutlet weak var lblDescFullView: UILabel!
    
    var seletedMeditationIndexPath:IndexPath!
    var selectedRowIndex = 0
    
    var audioPlayer:AVAudioPlayer!
    var isPlaying = false
    var playIdx = -1
    var timer = Timer()
    
    var webReq : webServices!
    var webRes = [AnyObject]()
    var arrMeditations = [OthersMeditation]()
    
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.doInitialSetUp()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Invalidate Audio Playing Progress Timer
        timer.invalidate()
    }
    
    
    //MARK: -
    //MARK: - General Methods
    func doInitialSetUp() {
        //Initialize webservice
        webReq = webServices()
        webReq.delegate = self
        
        //Hide containers
        setConstarintToHideBottomInfoView()
        viewContainerFullView.isHidden = true
        
        //Set Table Estimated Row Height
        tableMeditation.estimatedRowHeight = 90
        tableMeditation.rowHeight = UITableView.automaticDimension
        
        //Reload Special Meditation Audios Data Offline
        self.parseAndReloadMeditationData()
        
        //Call Get Special Meditations Audios Data API
        let req = "\(cfg.url)special_meditation1.php?"
        let postparam = ""
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "getSpecialMeditationsAudios")
    }
    func refreshMeditationAudioList()  {
        //Check nework connection
        tableMeditation.reloadData()
        if (AppDelegate.hasConnectivity() == false) {
            alertDialog(msg: cfg.no_internet)
            return
        }
        
    }
    //MARK: -
    //MARK: - IBActions
    
    @IBAction func btnBackAction(_ sender: Any) {
        if isPlaying {
            stopPaying()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: -
    //MARK: - TableView Delegate and DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMeditations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell : otherMeditationTVC = tableMeditation.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! otherMeditationTVC
        
        cell.populateData(data: arrMeditations[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selMediObj:OthersMeditation = arrMeditations[indexPath.row]
        let urlString = "\(cfg.baseUrl)\(String(describing: selMediObj.Path!))"
        
        let cell : otherMeditationTVC = tableMeditation.cellForRow(at: indexPath) as! otherMeditationTVC
        
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(URL(string: urlString)!.lastPathComponent)
        debugPrint(destinationUrl)
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            self.showsBottomInfoView(indexPath: indexPath)
            selMediObj.isDowloading = false
            tableMeditation.reloadData()
        }else{
            seletedMeditationIndexPath = indexPath
            
            cell.lblDownload.isHidden = true
            cell.btnControl.isHidden = true
            cell.indicatorActv.alpha = 1
            cell.indicatorActv.startAnimating()
            downloadFile(urlString: urlString)
        }
        
        
    }
    
    //MARK: -
    //MARK: - Downloading File Methods
    
    func downloadFile(urlString : String)
    {
        if let audioUrl = URL(string: urlString) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            debugPrint(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                debugPrint("The file already exists at path")
                tableMeditation.reloadData()
                // if the file doesn't exist
            } else {
                
                //Check nework connection
                if (AppDelegate.hasConnectivity() == false) {
                    tableMeditation.reloadData()
                    alertDialog(msg: cfg.no_internet)
                    return
                }
                
                let selMediObj:OthersMeditation = arrMeditations[seletedMeditationIndexPath.row]
                
                if selMediObj.isDowloading == false{
                    selMediObj.isDowloading = true
                    
                    imageCache.setObject(destinationUrl as AnyObject, forKey: destinationUrl.path as NSString)
                    // you can use NSURLSession.sharedSession to download the data asynchronously
                    
                    let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: destinationUrl.path)
                    backgroundSession = URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
                    downloadTask = backgroundSession.downloadTask(with: audioUrl )
                    downloadTask.resume()
                }
                
            }
        }
        
    }
    
    //MARK: - URLSessionDownload Delegate Methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint(location)
        let fileManager = FileManager()
        let destinationURLForFile = NSURL(fileURLWithPath: session.configuration.identifier!)//.stringByAppendingString("/file.pdf"))
        debugPrint (destinationURLForFile)
        try? fileManager.removeItem(at: destinationURLForFile as URL)
        if fileManager.fileExists(atPath: destinationURLForFile.path!){
            debugPrint(destinationURLForFile)
            do {
                _ = try fileManager.replaceItemAt(destinationURLForFile as URL , withItemAt: location)
                
            }catch{
                debugPrint("An error occurred while moving file to destination url")
            }
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile as URL)
                
            }catch{
                debugPrint("An error occurred while moving file to destination url")
            }
        }
        imageCache.removeObject(forKey: session.configuration.identifier! as NSString)
        self.tableMeditation.reloadData()
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
        let percentComplete = 100.0 * Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        debugPrint(percentComplete)
        //progressRing.setProgress(value: CGFloat(percentComplete), animationDuration: 1.0)
        //switch(session.configuration.identifier!)
        
        //debugPrint("\(totalBytesWritten)|\(totalBytesExpectedToWrite)")
        //debugPrint(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        //progressView.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        //progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        
        }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        if (error != nil) {
            debugPrint("Error in downloading ======\(error?.localizedDescription ?? "")")
        }else{
            debugPrint("The task finished transferring data successfully")
        }
        imageCache.removeObject(forKey: session.configuration.identifier! as NSString)
        self.tableMeditation.reloadData()
        
    }
    
    
    
    //MARK: -
    //MARK: - Audio Files Playing Methods
    
    func play(url: URL) {
        debugPrint("playing \(url)")
        let selMediObj:OthersMeditation = arrMeditations[seletedMeditationIndexPath.row]
        
        do {
            
            if(self.audioPlayer != nil){
                self.audioPlayer.play()
            }else{
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                //audioPlayer.enableRate = true
                //audioPlayer.rate = 60
                audioPlayer.prepareToPlay()
                audioPlayer.delegate = self
                //audioPlayer.volume = volProgess.progress
                //player.volume = 100.0
                audioPlayer.play()
            }
            
            var finalTime = Int(audioPlayer.duration)
            if finalTime > 900 {
                finalTime = 1800
            }
            let fminutes = finalTime/60
            let fseconds = finalTime - fminutes * 60
            let ft = NSString(format: "%02d:%02d", fminutes,fseconds) as String
            lblAudioLength.text = "\(ft)"
            
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playerVC.updateTime), userInfo: nil, repeats: true)
            progressBarFullContainer.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
            
        } catch let error as NSError {
            //self.player = nil
            debugPrint(error.localizedDescription)
            selMediObj.isAudioPlay = false
            btnPlayPauseBottom.setImage(#imageLiteral(resourceName: "ic_play_arrow_black_36"), for: .normal)
            btnPlayPauseFullContainer.setImage(#imageLiteral(resourceName: "uamp_ic_play_arrow_white_48"), for: .normal)
            
            self.alertDialog(header: "Error", msg: error.localizedDescription)
        } catch {
            selMediObj.isAudioPlay = false
            btnPlayPauseBottom.setImage(#imageLiteral(resourceName: "ic_play_arrow_black_36"), for: .normal)
            btnPlayPauseFullContainer.setImage(#imageLiteral(resourceName: "uamp_ic_play_arrow_white_48"), for: .normal)
            self.alertDialog(header: "Error", msg: cfg.something_went_wrong)
            
            debugPrint("AVAudioPlayer init failed")
        }
    }
    func stopPaying() {
        if isPlaying && self.audioPlayer != nil{
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        if isPlaying {
            isPlaying = false
            playIdx = -1
        }
        
    }
    func pausePaying() {
        if isPlaying && self.audioPlayer != nil{
            audioPlayer.pause()
        }
        if isPlaying {
            isPlaying = false
            playIdx = -1
        }
        
    }
    @objc func updateTime() {
        if(self.audioPlayer != nil){
            //audioPlayer.rate = 2.0
            let currentTime = Int(audioPlayer.currentTime)
            let minutes = currentTime/60
            let seconds = currentTime - minutes * 60
            
            let ct = NSString(format: "%02d:%02d", minutes,seconds) as String
            lblAudioProgress.text = "\(ct)"
            
            let pr:Float = Float(audioPlayer.currentTime/audioPlayer.duration)
            debugPrint("Special audio playing progress======\(pr)")
            
            progressBarFullContainer.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
        }
        
    }
    //MARK: - AVAudioPlayer Delegates Methods
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        playIdx = -1
        refreshTableAndSetupUI()
    }
    
    
}


//MARK: -
//MARK: - API Calls

extension otherMeditationVC : webServicesDelegate {
    //MARK: - Webservice Delegate Methods
    func responseData(data: NSData, reqId: String) {
        let responseData = JSON(data: data as Data)
        print("Response Meditations Audios===\(responseData)")

        if reqId == "getSpecialMeditationsAudios"
        {
            guard let oherMeditationsData = (responseData.object as AnyObject)["result"] as? [AnyObject] else {
                return
            }
            
            webRes = oherMeditationsData
            
            //Save Special Meditation Audios Data Offline
            UserDefaults.standard.set(webRes, forKey: cfg.ud_key_special)
            UserDefaults.standard.synchronize()
            
            //Refresh and Reload Offline Special Meditation Audios Data
            self.parseAndReloadMeditationData()
        
        }
    }
    
    func errorResponse(err: String, reqId: String) {
        print("Response Meditations Audios err===\(err)")
    }
    
    //MARK: - Refresh and Reload Offline Special Meditation Audios Data

    func parseAndReloadMeditationData()   {
        arrMeditations.removeAll()
        if let data = UserDefaults.standard.object(forKey: cfg.ud_key_special) as? [AnyObject] {
            webRes = data
            
            for otherMeditationsDict in webRes{
                let objMeditation = OthersMeditation()
                objMeditation.isAudioPlay = false
                objMeditation.isDowloaded = false
                objMeditation.isDowloading = false
                
                let otherMeditationsTempDict = otherMeditationsDict as! [String:Any]

                debugPrint("Other Meditations Audios Data===%@",otherMeditationsTempDict)

                if let name = otherMeditationsTempDict.removeNull()["Name"] {
                    objMeditation.Name =  String(describing: name)
                }
                if let path = otherMeditationsTempDict.removeNull()["Path"] {
                    objMeditation.Path =  String(describing: path)
                }
                if let desc = otherMeditationsTempDict.removeNull()["desc"] {
                    objMeditation.desc =  String(describing: desc)
                }
                if let large = otherMeditationsTempDict.removeNull()["large"] {
                    objMeditation.large =  String(describing: large)
                }
                if let length = otherMeditationsTempDict.removeNull()["length"] {
                    objMeditation.length =  String(describing: length)
                }
                arrMeditations.append(objMeditation)
            }
        }
        
        tableMeditation.reloadData()
    }
}
//MARK:-
//MARK:- Custom Audio Player View
extension otherMeditationVC  {
    
    //MARK: - Audio Control Actions

        @IBAction func backButtonContainerClicked(_ sender: Any) {
            viewContainerFullView.isHidden = true
            refreshTableOnBackButton()
        }
        @IBAction func btnPlayPauseBottomViewClicked(_ sender: Any) {
            
            if checkdedMeditaionFileIsDownloded() {
                playPauseAudio(isPauseAduio: true)
                
            }else{
                self.alertDialog(msg: cfg.alert_download_file)
            }
        }
        
        
        @IBAction func btnPlayPauseFullViewClicked(_ sender: Any) {
            if checkdedMeditaionFileIsDownloded() {
                playPauseAudio(isPauseAduio: true)

            }else{
                self.alertDialog(msg: cfg.alert_download_file)
            }
        }
        @IBAction func btnPrevFullViewClicked(_ sender: Any) {
            self.audioPlayer = nil
            //Refresh table
             refreshTableAndSetupUI()
            
            selectedRowIndex -= 1
            
            if selectedRowIndex < 0 {
                return
            }
            debugPrint("PREVE Clicked Selected Row Index ====== %@",selectedRowIndex)

            disablePreOrNextButton()
            
            let selIndexPath = IndexPath(row: selectedRowIndex, section: 0)
            seletedMeditationIndexPath = selIndexPath
            
            setupMeditationInfoOnViews(indexPath: seletedMeditationIndexPath)
            
             playPauseAudio(isPauseAduio: false)
            
            
        }
        @IBAction func btnNextFullViewClicked(_ sender: Any) {
            self.audioPlayer = nil
             //Refresh table
            refreshTableAndSetupUI()
            selectedRowIndex += 1
           
            if selectedRowIndex == arrMeditations.count {
                return
            }
            debugPrint("NEXT Clicked Selected Row Index====== %@",selectedRowIndex)
            disablePreOrNextButton()
            
            let selIndexPath = IndexPath(row: selectedRowIndex, section: 0)
            seletedMeditationIndexPath = selIndexPath
            setupMeditationInfoOnViews(indexPath: seletedMeditationIndexPath)

            playPauseAudio(isPauseAduio: false)
            
            
        }
    
    
    //MARK: - Others Gerneral Methods

        func playPauseAudio(isPauseAduio:Bool)  {
            let selMediObj:OthersMeditation = arrMeditations[seletedMeditationIndexPath.row]
            
            let urlString = "\(cfg.baseUrl)\(String(describing: selMediObj.Path!))"
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(URL(string: urlString)!.lastPathComponent)
            debugPrint(destinationUrl)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                if isPlaying == false {
                    isPlaying = true
                    playIdx = seletedMeditationIndexPath.row
                    play(url: destinationUrl)
                    
                    selMediObj.isAudioPlay = true
                    btnPlayPauseBottom.setImage(#imageLiteral(resourceName: "ic_pause_black_36"), for: .normal)
                    btnPlayPauseFullContainer.setImage(#imageLiteral(resourceName: "uamp_ic_pause_white_48"), for: .normal)
                    
                }
                else {
                    if playIdx == seletedMeditationIndexPath.row {
                        if isPauseAduio{
                             pausePaying()
                        }else{
                             stopPaying()
                        }
                      
                        
                        selMediObj.isAudioPlay = false
                        btnPlayPauseBottom.setImage(#imageLiteral(resourceName: "ic_play_arrow_black_36"), for: .normal)
                        btnPlayPauseFullContainer.setImage(#imageLiteral(resourceName: "uamp_ic_play_arrow_white_48"), for: .normal)
                        
                    }
                }
                //tableMeditation.reloadData()
                tableMeditation.reloadRows(at: [seletedMeditationIndexPath], with: .none)
            }
        }
        func setConstarintToHideBottomInfoView()  {
            viewContainerBottom.isHidden = true
            //bottomViewHeightConstarint.priority = UILayoutPriority(999.0)
            btnPlayBottomHeightConstarint.constant = 0
            bottomViewHeightConstarint.constant = 0
            lblTitleBottomHeightConstarint.constant = 0
            lblTitleBottomTopConstarint.constant = 0
            lblTitleBottomBelowConstarint.constant = 0
            lblDescBottomBelowConstarint.constant = 0
            tblBottomHeightConstarint.constant = 0
            
        }
        
        func setConstarintToShowBottomInfoView()  {
            viewContainerBottom.isHidden = false
            //bottomViewHeightConstarint.priority = UILayoutPriority(250.0)
            btnPlayBottomHeightConstarint.constant = 30
            bottomViewHeightConstarint.constant = 90//100
            lblTitleBottomHeightConstarint.constant = 90//21
            lblTitleBottomTopConstarint.constant = 0//8
            lblTitleBottomBelowConstarint.constant = 0//8
            lblDescBottomBelowConstarint.constant = 8
            tblBottomHeightConstarint.constant = 8
            
        }
        func showsBottomInfoView(indexPath:IndexPath) {
            self.audioPlayer = nil
            setConstarintToShowBottomInfoView()
          
            //Refresh table
            refreshTableAndSetupUI()
            
            //Set selected index
            seletedMeditationIndexPath = indexPath
            selectedRowIndex = indexPath.row
            
            let selMediObj:OthersMeditation = arrMeditations[indexPath.row]
            setupMeditationInfoOnViews(indexPath: indexPath)
            selMediObj.isAudioPlay = false
            
            //Add tap gesture to open full view
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            viewContainerBottom.isUserInteractionEnabled = true
            viewContainerBottom.addGestureRecognizer(tap)
            
            //Play audio
            self.playPauseAudio(isPauseAduio: false)
            
        }
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            showFullInfoView()
        }
        
        func showFullInfoView() {
            disablePreOrNextButton()
            viewContainerFullView.isHidden = false
            
            setupMeditationInfoOnViews(indexPath: seletedMeditationIndexPath)

        }
        func disablePreOrNextButton()  {
            btnPrevFullContainer.isEnabled = true
            btnNextFullContainer.isEnabled = true
            if selectedRowIndex == 0 {
                btnPrevFullContainer.isEnabled = false
            }
            if selectedRowIndex == arrMeditations.count - 1 {
                btnNextFullContainer.isEnabled = false
            }
        }
        func setupMeditationInfoOnViews(indexPath:IndexPath) {
            //Bottom View
            let selMediObj:OthersMeditation = arrMeditations[indexPath.row]
            lblTitleBottom.text = selMediObj.Name
            imgVwBottom.sd_setImage(with: URL(string: "\(cfg.baseUrl)\(selMediObj.large ?? "")"), placeholderImage: UIImage(named: "placholder_logo"))

            //imgVwBottom.loadImageUsingCache(withUrl: "\(cfg.baseUrl)\(String(describing: selMediObj.large!))")
            lblBottomDesc.text = ""//selMediObj.desc
            
            //Full View
            lblTitleFullContainer.text = "Special Audios"//selMediObj.Name
            imgVwFullContainer.sd_setImage(with: URL(string: "\(cfg.baseUrl)\(selMediObj.large ?? "")"), placeholderImage: UIImage(named: "placholder_logo"))

            //imgVwFullContainer.loadImageUsingCache(withUrl: "\(cfg.baseUrl)\(String(describing: selMediObj.large!))")
            lblTitleFullView.text = selMediObj.Name
            lblDescFullView.text = ""//selMediObj.desc
            lblAudioLength.text = "\(String(describing: selMediObj.length!)):00"
            lblAudioProgress.text = "00:00"
  
            progressBarFullContainer.setProgress(0.0, animated: true)

        }
        func refreshTableAndSetupUI()  {
            //Stop audio playing
            stopPaying()
            
            let selIndexPath = IndexPath(row: selectedRowIndex, section: 0)
            seletedMeditationIndexPath = selIndexPath
            let selMediObj:OthersMeditation = arrMeditations[seletedMeditationIndexPath.row]
            selMediObj.isAudioPlay = false
            tableMeditation.reloadData()
                    
            btnPlayPauseBottom.setImage(#imageLiteral(resourceName: "ic_play_arrow_black_36"), for: .normal)
            btnPlayPauseFullContainer.setImage(#imageLiteral(resourceName: "uamp_ic_play_arrow_white_48"), for: .normal)
        }
        func refreshTableOnBackButton()  {
            let selIndexPath = IndexPath(row: selectedRowIndex, section: 0)
            seletedMeditationIndexPath = selIndexPath
            let selMediObj:OthersMeditation = arrMeditations[seletedMeditationIndexPath.row]
            
            if let isTempAudioPlay = selMediObj.isAudioPlay  {
                if isTempAudioPlay{
                    btnPlayPauseBottom.setImage(#imageLiteral(resourceName: "ic_pause_black_36"), for: .normal)
                    btnPlayPauseFullContainer.setImage(#imageLiteral(resourceName: "uamp_ic_pause_white_48"), for: .normal)
                    
                }else{
                    btnPlayPauseBottom.setImage(#imageLiteral(resourceName: "ic_play_arrow_black_36"), for: .normal)
                    btnPlayPauseFullContainer.setImage(#imageLiteral(resourceName: "uamp_ic_play_arrow_white_48"), for: .normal)
                    
                }
            }
            tableMeditation.reloadData()
        }
        
        func checkdedMeditaionFileIsDownloded() -> Bool  {
            
            let selIndexPath = IndexPath(row: selectedRowIndex, section: 0)
            seletedMeditationIndexPath = selIndexPath
            let selMediObj:OthersMeditation = arrMeditations[seletedMeditationIndexPath.row]

            let urlString = "\(cfg.baseUrl)\(String(describing: selMediObj.Path!))"
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(URL(string: urlString)!.lastPathComponent)
            debugPrint(destinationUrl)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                return true
            }else{
               return false
            }
            
        }
        
        func playSelectedMeditaionAudio(audioUrl:URL) {
            play(url: audioUrl)
        }
}
//MARK: -
//MARK: - Blur Image Method
  
extension UIImageView
{
    func makeBlurImage(targetImageView:UIImageView?)
    {
        //let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        var blurEffect:UIBlurEffect = UIBlurEffect()

        if #available(iOS 10.0, *) { //iOS 10.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark) //extraLight, light, dark
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 0.5

        targetImageView?.addSubview(blurEffectView)
    }
}
