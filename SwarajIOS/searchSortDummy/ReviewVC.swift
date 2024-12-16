//
//  ReviewVC.swift
//  searchSortDummy
//
//  Created by Infonium on 15/04/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController, webServicesDelegate, UITextViewDelegate {
    
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var lblSwarajKriya: UILabel!
    @IBOutlet weak var lblEnergization: UILabel!
    @IBOutlet weak var lblInterruptions: UILabel!
    @IBOutlet weak var lblSwarajKriya2: UILabel!
    @IBOutlet weak var txtMsgs: UITextView!
    @IBOutlet weak var btnSave: UIButton!

    var placeholderLabel = UILabel()
    var webReq : webServices!
    var monthlyArray : [String] = ["fetch_interruption.php","review_fetch_monthly.php"]
    static var type : String = ""
    
    //MARK: -
    //MARK: - View Life Cycle
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
        
        //Add overlay on Save button
        btnSave.layer.shadowColor = UIColor.gray.cgColor
        btnSave.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        btnSave.layer.shadowOpacity = 1
        btnSave.layer.masksToBounds = false
        
        //Set Monthly data
        let date = Date()
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "MMMM"
        lblMonthName.text = df.string(from: date)
        
        lblSwarajKriya.text = "\(cfg.monthSK1) Times"
        lblSwarajKriya2.text = "\(cfg.monthSK2) Times"
        lblEnergization.text = "\(cfg.monthEng) Times"
        lblInterruptions.text = "\(cfg.monthIntrupt) Times"
        
        
        //Initialize Message TextView
        txtMsgs.delegate = self
        placeholderLabel.text = "Type Here.."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (txtMsgs.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtMsgs.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtMsgs.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtMsgs.text.isEmpty
        
        //Set border for TextView
        txtMsgs.layer.borderWidth = 1
        txtMsgs.layer.borderColor = UIColor.lightGray.cgColor
        txtMsgs.layer.cornerRadius = 5
        
        
        //Call get monthly data APIs
        for i in 0 ..< monthlyArray.count
        {
            let req = "\(cfg.url)\(monthlyArray[i])?"
            let postparam = "uniqueId=\(cfg.uid)"
            
            webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: monthlyArray[i])
        }
    }
    
    //MARK: - Save monthly data to offline
    func saveCurrentMonthlRecord()  {
        let monthly = "\(getMonthNumber())|\(cfg.monthSK1)|\(cfg.monthSK2)|\(cfg.monthEng)|\(cfg.monthIntrupt)"
        
        UserDefaults.standard.set(monthly, forKey: cfg.ud_key_monthly)
        UserDefaults.standard.synchronize()
    }
    
    
    //MARK: -
    //MARK: - IBActions
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if txtMsgs.text != ""
        {
            let req = "\(cfg.url)insert_message_to_leader.php?"
            let postparam = "uniqueId=\(cfg.uid)&message=\(txtMsgs.text!)"
            
            webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "msg")
        }
    }
    
    @IBAction func btnTapAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    //MARK: -
    //MARK: - UITextView Delegates Methods
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    //MARK: -
    //MARK: - API Calls
    //MARK: - Webservice Delegate Methods
    func responseData(data: NSData, reqId: String) {
        let responseData = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        if reqId == "fetch_interruption.php"
        {
            print("Response monthly Intrruption data===\(responseData ?? "")")
            
            if let dataInterruption = responseData{
                if dataInterruption != ""
                {
                    var intrruptionCount = 0
                    if let tempIntrrCount =  Int(dataInterruption){
                        intrruptionCount = tempIntrrCount
                    }
                    
                    lblInterruptions.text = dataInterruption + " Times"
                    cfg.monthIntrupt = intrruptionCount
                    self.saveCurrentMonthlRecord()
                }
            }
            
            
        }
            
        else if reqId == "msg"
        {
            print("Response Message data===\(responseData ?? "")")
            
            alertDialog(msg: responseData ?? "")
            txtMsgs.text = ""
        } else if reqId == "review_fetch_monthly.php"
        {
            print("Response monthly count data===\(responseData ?? "")")
            
            let dataMonthlyCount = responseData?.components(separatedBy: "_")
            
            var kriya1Count = 0
            var kriya2Count = 0
            var kriya3Count = 0
            if let tempK1Count =  Int((dataMonthlyCount?[0])!){
                kriya1Count = tempK1Count
            }
            if let tempK2Count =  Int((dataMonthlyCount?[1])!){
                kriya2Count = tempK2Count
            }
            if let tempK3Count =  Int((dataMonthlyCount?[2])!){
                kriya3Count = tempK3Count
            }
            
            lblSwarajKriya.text = "\(kriya1Count)"+" Times"
            lblSwarajKriya2.text = "\(kriya2Count)"+" Times"
            lblEnergization.text = "\(kriya3Count)"+" Times"
            
            cfg.monthSK1 = kriya1Count
            cfg.monthSK2 = kriya2Count
            cfg.monthEng = kriya3Count
            
            self.saveCurrentMonthlRecord()
        }
    }
    
    func errorResponse(err: String, reqId: String) {
        print("Response \(reqId) err===\(err)")
        if reqId == "msg"
        {
            alertDialog(msg: err)
        }
    }
    
}
