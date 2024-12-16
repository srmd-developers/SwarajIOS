//
//  otherMeditationTVC.swift
//  searchSortDummy
//
//  Created by Shivam Dubey on 26/10/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit
import SDWebImage

class otherMeditationTVC: UITableViewCell {

    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var vewHolder: UIView!
    @IBOutlet weak var indicatorActv: UIActivityIndicatorView!
    
    @IBOutlet weak var lblDownload: UIButton!
    @IBOutlet weak var btnControl: UIImageView!
    
    //MARK: -
    //MARK: - Load Data on Table Cell

    func populateData(data : OthersMeditation) {
        vewHolder.layer.cornerRadius = 10
        vewHolder.layer.borderColor = UIColor.lightGray.cgColor
        vewHolder.layer.borderWidth = 1
        vewHolder.layer.masksToBounds = false
        
        lblDownload.layer.cornerRadius = 5
        lblDownload.layer.masksToBounds = false
        
        lblName.text = data.Name
        lblDuration.text = "\(String(describing: data.length!)) MINUTES"
        lblDescription.text = ""//data.desc
        lblSize.text = "15 MB"
        
        imgBg.sd_setImage(with: URL(string: "\(cfg.baseUrl)\(data.large ?? "")"), placeholderImage: UIImage(named: "placholder_logo"))

        /*
        imgBg.loadImageUsingCache(withUrl: "\(cfg.baseUrl)\(String(describing: data.large!))")
        
        if imgBg.image == nil {
            imgBg.image = UIImage(named: "placholder_logo")
        }*/
        
        let audioUrl = URL(string: "\(cfg.baseUrl)\(String(describing: data.Path!))")!
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
        //debugPrint(destinationUrl)
        let audioCondition = existInCache(urlString: destinationUrl.path)//"\(cfg.baseUrl)\(data["Path"] as! String)")
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            if data.isAudioPlay!{
                 btnControl.image = #imageLiteral(resourceName: "stopOrg")
            }else{
                btnControl.image = #imageLiteral(resourceName: "play")
            }
           
            indicatorActv.alpha = 0
            lblDownload.isHidden = true
            btnControl.isHidden = false
        }
        else if audioCondition {
            indicatorActv.startAnimating()
            lblDownload.isHidden = true
            
             //Check nework connection
            if (AppDelegate.hasConnectivity() == false) {
                indicatorActv.alpha = 0
                btnControl.isHidden = false
                btnControl.image = #imageLiteral(resourceName: "download")
            }else{
                indicatorActv.alpha = 1
                btnControl.isHidden = true
            }
        }
        else {
            btnControl.image = #imageLiteral(resourceName: "download")
            indicatorActv.alpha = 0
            lblDownload.isHidden = true
            btnControl.isHidden = false
        }
    }
    
    func existInCache(urlString : String) -> Bool
    {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            debugPrint(cachedImage)
            return true
        }
        else {
            return false
        }
    }
}

//MARK: -
//MARK: - Download Image From Url
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                debugPrint(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
