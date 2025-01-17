

import UIKit
import Foundation

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
class cfg : UIViewController {
    

    //Live
    static var baseUrl = "https://app.swarajkriya.com/swaraj-new/"
    static var url = "https://app.swarajkriya.com/swaraj/kavita1/"
    
    //Test1
//    static var baseUrl = "http://10.1.1.170/swaraj/"
//    static var url = "http://10.1.1.170/swaraj/kavita1/"
    
    //Test2
//    static var baseUrl = "http://180.151.6.52/swaraj/"
//    static var url = "http://180.151.6.52/swaraj/kavita1/"
    
    //Test3
//    static var baseUrl = "http://13.234.2.65/swaraj/"
//    static var url = "http://13.234.2.65/swaraj/kavita1/"
    
    static var firebaseUrl = "gs://audio-da450.appspot.com/"
    
    
    //Firebase Audio url used
    static var urlAudioSK1 = "https://firebasestorage.googleapis.com/v0/b/swarajkriya.appspot.com/o/Swarajkriya2020%2FSwarajkriya2020.mp3?alt=media&token=8d8ab284-1da6-4243-a9ba-cf6a0ef22339"
    static var urlAudioSK2 = "https://firebasestorage.googleapis.com/v0/b/swarajkriya.appspot.com/o/SwarajyaKriyaLevel2%2FSwarajKriya2.mp3?alt=media&token=f5df4962-75d9-4537-893f-dc091ffb30db"
    static var urlAudioENER = "https://firebasestorage.googleapis.com/v0/b/swarajkriya.appspot.com/o/Energisation2020%2FEnergisation2020.mp3?alt=media&token=ff2c17fb-c42e-4803-9e62-062440a75106"
   
    
    static var boardId : String = ""
    static var password : String = ""
    static var logName : String = ""
    static var mobile : String = ""
    static var uid : String = ""

    static var nvMain = ""
    static var scrnQuestion = "question"
    static var scrnSolution = "soluton"
    static var scrnFormat = "format"
    static var scrnTimetable = "timeTable"
    
    static let no_internet = "Please Check your Internet Connectivity."
    static let err_no_503 = "Service is unavailable"
    static let err_no_404 = "No Response From Server"
    static let err_no_0 = "No Response From Server"
    static let err_default = "Something went wrong, Please check your internet connection."
    static let loading = "Loading..."
    static let something_went_wrong = "Something went wrong."
    static let alert_download_file = "Please download track to listen."

    static let err_no_ear = "Please connect your Earphones/Headphones. \n\n To avoid any interruptions, put your phone on Airplane mode."
	
    //dhirendra
     static let logout_conf_msg = "Are you sure you want to logout?"
    static let deactivated_msg = "Your account is de-activated. Contact your group leader for more information."
    static let alert_title = "Alert"
    static let sync_completed = "Sync process completed."


    
	static var wd : CGFloat = 320
	static var ht : CGFloat = 480
	
	static let app_version = "1.0.0"
    
    static var dataStack : [String : String] = [:]
    static var dataStack2 : [String] = []
    static var dataStackI : [String] = []
    
    static var weekNo = 0
    static var weekSK1 = 0
    static var weekSK2 = 0
    static var weekEng = 0
    
    static var weekSK1T = 0
    static var weekSK2T = 0
    static var weekEngT = 0
    
    static var monthNo = 0
    static var monthSK1 = 0
    static var monthSK2 = 0
    static var monthEng = 0
    static var monthIntrupt = 0
    
    static var SK1 = 0
    static var SK2 = 0
    static var Eng = 0
    static var Intrupt = 0
    
    /********** USER DEFAULTS ***********/
    static let ud_key_log = "log_details"
    static let ud_key_logN = "log_detailsName"
    static let ud_key_password = "log_password"
    static let ud_key_download = "downloads"
    static let ud_key_weekLog = "weeklyLog"
    static let ud_key_weekTarget = "weeklyTarget"
    static let ud_key_dailyTarget_SK1 = "dailyTarget1"
    static let ud_key_dailyTarget_SK2 = "dailyTarget2"
    static let ud_key_offlineLog = "offlineLog"
    static let ud_key_monthly = "monthlyLog"
    static let ud_key_dataStack = "dataStack"
    static let ud_key_dataStack2 = "dataStack2"
    static let ud_key_dataStackI = "dataStackI"
    static let ud_key_special = "otherMedi"
    static let ud_key_MusicT = "otherMedi"
    static let ud_key_MusicType = "musicType"
    
    //dhirendra
    static let is_user_logged = "isuserlogged"
    static let kuser_Default_DeviceToken = "deviceToken"

    //Messages String
    static let errStd = "Oops!! \nSomething went wrong with the request!! Please check your internet and try again!!"
    
    
    /********** SK Flies Name ***********/

    static var SK1FileName = "SwaRaj Kriya Level 1"
    static var SK2FileName = "SwaRaj Kriya Level 2"
    static var SK3FileName = "Energization"
    static var SK4FileName = "SwaRaj Kriya Extended"
}

protocol triggerActionDelegate {
    func action(type : String)
}

protocol triggerIdActionDelegate {
    func action(type : Int, data: AnyObject)
}
