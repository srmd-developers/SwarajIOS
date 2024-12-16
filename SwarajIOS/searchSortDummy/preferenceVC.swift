//
//  preferenceVC.swift
//  searchSortDummy
//
//  Created by Infonium on 14/04/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit
import MessageUI

class preferenceVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lblLogName: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.doInitialSetUp()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -
    //MARK: - General Methods
    func doInitialSetUp() {
        
        lblLogName.text = cfg.logName
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.lblVersion.text = "Version no - \(version)"
        }
    }
    
    //MARK: -
    //MARK: - IBActions
    @IBAction func btnFeedback(_ sender: Any) {
        self.sendEmail()
    }
    
    @IBAction func btnCancelReminder(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        //UIApplication.shared.cancelAllLocalNotifications()
        alertDialog(msg: "Reminder has canceled.")
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReminderAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toCalender", sender: self)
    }
    
    @IBAction func btnTermAndConditionAction(_ sender: Any) {
        alertDialog(header : "SwaRaj Kriya App’s Terms & Services (“Agreement”)",msg: "\nThis Agreement was last modified on December 19, 2016.\n\nPlease read these Terms of Service completely before using SwaRaj Kriya App which is owned and operated by Shrimad Rajchandra Mission, Delhi. This Agreement documents the legally binding terms and conditions attached to the use of this App.\n\nBy using or accessing the App in any way, viewing or browsing the App, or adding your own content to the App, you are agreeing to be bound by these Terms of Service.\n\n 1]Copyright Content\n\nThe App, the Meditations–Level 1, Level 2 & Energization Kriya are all original content created by Shrimad Rajchandra Mission, Delhi which reserves the sole rights of the content. Any part of the App, especially the Meditation Tracks, should not copied and/or shared to anyone else than the person authorized with the ID to use the App, i.e., your self.\n\n2]Termination\n\nShrimad Rajchandra Mission, Delhi reserves the right to terminate your access to the App’s content, without any advance notice.\n\n3]Links to Other Websites \n\nThis App contains an in-app embedded blog site for a private blog on topic of SwaRaj Kriya. Shrimad Rajchandra Mission, Delhi reserves all the rights regarding its contents. The blog contain a number of links to other websites and online resources that are not owned or controlled by Shrimad Rajchandra Mission, Delhi.\n\n4]Changes to This Agreement \n\nShrimad Rajchandra Mission, Delhi reserves the right to modify these Terms of Services at any time. We do so by posting and drawing attention to the ipdated terms in the App. Your decision to continiue to visit the App and make use of the Site after such changes have been made constitutes your formal acceptance of the new Terms of Services. Therefore, we ask that you check and review this Agreement for such changes on an occasional basis. Should you not agree to any provision of this Agreement or any changes we make to this Agreement, we ask and advise that you do not use or continue to access the SwaRaj Kriya App immediately. \n\n5]Contact Us \n\nIf you have any questions about this Agreement, please feel free to contact us at gautam.admin@shrimadrajchandradelhi.org.")
    }
    
    //MARK: -
    //MARK: - Send Email Methods
    
    func sendEmail() {
        let email = "feedback@srmdelhi.com"
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email as String])
            mail.setSubject("")
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            // give feedback to the user
        }
    }
    //MARK: - MFMailComposeViewController Delegate Methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
