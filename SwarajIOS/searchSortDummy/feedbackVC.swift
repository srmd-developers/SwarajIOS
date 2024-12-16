//
//  feedbackVC.swift
//  searchSortDummy
//
//  Created by Deepak Anil Shakyavanshi on 05/07/17.
//  Copyright © 2017 niket. All rights reserved.
//
//=>Not Using

import UIKit

class feedbackVC: UIViewController, webServicesDelegate, UITextViewDelegate {

    @IBOutlet weak var txtmsgs: UITextView!
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    var webReq : webServices!
    var webRes: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*btnLogin.layer.shadowColor = UIColor.gray.cgColor
        btnLogin.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        btnLogin.layer.shadowOpacity = 1
        //btnLogin.layer.shadowOffset = CGSize.zero
        //btnLogin.layer.shadowRadius = 10
        btnLogin.layer.masksToBounds = false
        */
        webReq = webServices()
        webReq.delegate = self
        
        txtmsgs.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type Here.."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (txtmsgs.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtmsgs.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtmsgs.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtmsgs.text.isEmpty
        
        txtmsgs.layer.borderWidth = 1
        txtmsgs.layer.borderColor = UIColor.lightGray.cgColor
        txtmsgs.layer.cornerRadius = 5

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func responseData(data: NSData, reqId: String) {
        let dte = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        print(dte!)
    
        if reqId == "msg"
        {
            alertDialog(msg: dte!)
            txtmsgs.text = ""
        }
    }
    
    func errorResponse(err: String, reqId: String) {
        print(err)
        alertDialog(msg: err)
    }

    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if txtmsgs.text != ""
        {
            let req = "\(cfg.url)submit_feedback.php?"
            let postparam = "uniqueId=\(cfg.uid)&message=\(txtmsgs.text!)"
            
            webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "msg")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
