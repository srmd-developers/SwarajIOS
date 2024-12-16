//
//  uploadTargetVC.swift
//  searchSortDummy
//
//  Created by Infonium on 01/05/17.
//  Copyright © 2017 niket. All rights reserved.
//
//=>Not Using

import UIKit

class uploadTargetVC: UIViewController, webServicesDelegate {

    @IBOutlet weak var btnSk1: UIButton!
    @IBOutlet weak var btnSk2: UIButton!
    @IBOutlet weak var btnEng: UIButton!
    
    var sk1 = UIAlertController()
    var sk2 = UIAlertController()
    var eng = UIAlertController()
    
    var kriyaArr = [0,1,2,3,4,5,6,7,8]
    
    var webReq : webServices!
    var webRes: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webReq = webServices()
        webReq.delegate = self
        
        let controllerArray = [sk1,sk2,eng]
        for i in 0 ..< controllerArray.count
        {
            loadController(uiAc: controllerArray[i])
        }
    }
    
    func responseData(data: NSData, reqId: String) {
        let dte = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        print(dte!)
        alertDialog(msg: dte!)
    }
    
    func errorResponse(err: String, reqId: String) {
        print(err)
        alertDialog(msg: err)
    }
    
    func loadController(uiAc : UIAlertController)
    {
        //uiAc = UIAlertController()
        for key in kriyaArr
        {
            
            let action = UIAlertAction(title: "\(key)" , style: UIAlertAction.Style.default) { (ACTION) in
                if uiAc == self.sk1{
                    self.btnSk1.setTitle("\(key)", for: .normal)
                    self.btnSk1.titleLabel?.text = "2"
                }
                else if uiAc == self.sk2{
                    self.btnSk2.setTitle("\(key)", for: .normal)
                }
                else{
                    self.btnEng.setTitle("\(key)", for: .normal)
                }
            }
            uiAc.addAction(action)
        }
        uiAc.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (ACTION) in })
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSk1Action(_ sender: UIButton) {
        self.present(sk1, animated: true, completion: nil)
    }
    
    @IBAction func btnSk2Action(_ sender: UIButton) {
        self.present(sk2, animated: true, completion: nil)
    }
    
    @IBAction func btnEngAction(_ sender: UIButton) {
        self.present(eng, animated: true, completion: nil)
    }
    
    @IBAction func btnUploadAction(_ sender: UIButton) {
        let req = "\(cfg.url)upload_logs_after_complete.php?"
        let postparam = "uniqueId=\(cfg.uid)&SKL1=\(btnSk1.titleLabel!.text!)&SKL2=\(btnSk2.titleLabel!.text!)&Energization=\(btnEng.titleLabel!.text!)"
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "msg")
    }
    

}
