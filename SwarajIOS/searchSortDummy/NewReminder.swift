//
//  NewReminder.swift
//  ManageMyReminders
//
//  Created by Shivam Dubey. on 11/20/15.
//  Copyright © 2015 Shivam Dubey. All rights reserved.
//

import UIKit
import EventKit
import AVFoundation
import UserNotifications

class NewReminder: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnSave: UIButton!
    
    var eventStore: EKEventStore = EKEventStore()
    
    //MARK: -
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 5
        btnSave.layer.borderWidth = 1
        btnSave.layer.borderColor = UIColor.lightGray.cgColor
        
        datePicker.layer.cornerRadius = 5
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.lightGray.cgColor
        
        
        datePicker.timeZone = TimeZone.current
        
        datePicker.datePickerMode = UIDatePicker.Mode.time
    }
    //MARK: -
    //MARK: - IBActions
    @IBAction func saveNewReminder(sender: AnyObject) {
        
        //Cancel all previous notifications
        self.cancelAllLocalNotification()
        
        //Schedule notifications
        self.scheduleNotification()
        
    }
    
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -
    //MARK: - Schedule notifications
    func scheduleNotification() {
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Swaraj Kriya"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let date = self.datePicker.date
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        let alrt = UIAlertController(title: "Alert", message: "Reminder Saved Successfully!", preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alrt.addAction(cancel)
        alrt.view.tintColor = UIColor.blue
        self.present(alrt, animated: true, completion: nil)
    }
    //MARK: - Cancel all previous notifications
    func cancelAllLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
    }
}

extension Date {
    var localTime: String {
        return description(with: NSLocale.current)
    }
}
