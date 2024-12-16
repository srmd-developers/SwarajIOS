
import UIKit

extension UIViewController {
    
    
    func existInCache(urlString : String) -> Bool
    {
        if imageCache.object(forKey: urlString as NSString) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func updateCache(urlString : String, value : AnyObject) {
        imageCache.setObject(value, forKey: urlString as NSString)
    }
    
    //Monday-Sunday
//    func getWeekNumber() -> Int
//    {
//        let calendar = Calendar.current
//        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: -60*60*24))
//        print(weekOfYear)
//        return weekOfYear
//    }
    
    //Sunday-Saturday-(On Server too)
    func getWeekNumber() -> Int
    {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow:0))
        debugPrint("Current Week Of Year ==\(weekOfYear)")
        return weekOfYear
    }
    func getMonthNumber() -> Int
    {
        let calendar = Calendar.current
        let monthOfYear = calendar.component(.month, from: Date.init(timeIntervalSinceNow: 0))
        debugPrint("Current Month Of Year ==\(monthOfYear)")
        return monthOfYear
    }
    
    func getCurrentDate() -> String
    {
        let date = Date()
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "dd-MMMM_yyyy"
        return df.string(from: date)
    }
    func getCurrentDate1() -> String
    {
        let date = Date()
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "dd-MMMM-yyyy"
        return df.string(from: date)
    }
    
    func getCurrentDateTime() -> String
    {
        let date = Date()
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"//dd-MMMM_yyyy"
        return df.string(from: date)
    }
	
    func alertDialog(msg : String){
        var cancelActionTitle = "Dismiss"
        var alertTitle = "Alert"
        if msg == cfg.sync_completed {
            cancelActionTitle = "Close"
            alertTitle = "Thank you"
        }
        let alrt = UIAlertController(title: alertTitle, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: cancelActionTitle, style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alrt.addAction(cancel)
        alrt.view.tintColor = UIColor.blue
        self.present(alrt, animated: true, completion: nil)
    }
    
    func alertNoEarphoneConnectedDialog2Btns(completion: @escaping () -> ()){
        let alrt = UIAlertController(title: "Alert", message: cfg.err_no_ear, preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alrt.addAction(cancel)
        let ok = UIAlertAction(title: "Proceed", style: UIAlertAction.Style.default) { (action) in
            completion()
        }
        alrt.addAction(ok)
        alrt.view.tintColor = UIColor.blue
        self.present(alrt, animated: true, completion: nil)
    }
    
    func alertAirplaneModeDialog2Btns(completion: @escaping () -> ()){
        let alrt = UIAlertController(title: "Alert", message: "To avoid any interruptions, put your phone on Airplane mode.", preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alrt.addAction(cancel)
        let ok = UIAlertAction(title: "Proceed", style: UIAlertAction.Style.default) { (action) in
            completion()
        }
        alrt.addAction(ok)
        alrt.view.tintColor = UIColor.blue
        self.present(alrt, animated: true, completion: nil)
    }
    
    func alertDialog(header : String,msg : String){
        let alrt = UIAlertController(title: header, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alrt.addAction(cancel)
        alrt.view.tintColor = UIColor.blue
        self.present(alrt, animated: true, completion: nil)
    }
    
    func alertDialogLogut(completion: @escaping () -> ()){
        let alrt = UIAlertController(title: "Alert", message: cfg.logout_conf_msg, preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alrt.addAction(cancel)
        let ok = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) { (action) in
            completion()
        }
        alrt.addAction(ok)
        alrt.view.tintColor = UIColor.blue
        self.present(alrt, animated: true, completion: nil)
    }
    
    func uniq<S: Sequence, E: Hashable>(source: S) -> [E] where E==S.Iterator.Element {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
    }
	
	func isValidEmail(testStr:String) -> Bool {
		// println("validate calendar: \(testStr)")
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: testStr)
	}
    
	func isValidPhone(value: String) -> Bool {
		let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
		let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
		let result =  phoneTest.evaluate(with: value)
		return result
	}
	
	func loadingView(flag : Bool){
		if flag {
            let v = UIView(frame: CGRect(x: 0,y : 0,width : cfg.wd, height : cfg.ht))
			v.backgroundColor = colorCode.blur
            let activityView = UIActivityIndicatorView(style: .whiteLarge)
            activityView.center = v.center
            activityView.startAnimating()
            v.addSubview(activityView)
			self.view.addSubview(v)
		}
		else {
			let c = self.view.subviews.count
			self.view.subviews[c-1].removeFromSuperview()
		}
	}
}

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    

    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

public extension UITableView {
    
    func registerCellClass(cellClass: AnyClass) {
        let identifier = String.className(aClass: cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(cellClass: AnyClass) {
        let identifier = String.className(aClass: cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(viewClass: AnyClass) {
        let identifier = String.className(aClass: viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(viewClass: AnyClass) {
        let identifier = String.className(aClass: viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

extension UIApplication {
    
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        
       // if let slide = viewController as? SlideMenuController {
          //  return topViewController(viewController: slide.mainViewController)
       // }
        return viewController
    }
    
  

}

extension Dictionary {
    
    func removeNull() -> Dictionary {
        let mainDict = NSMutableDictionary.init(dictionary: self)
        for _dict in mainDict {
            if _dict.value is NSNull {
                mainDict.removeObject(forKey: _dict.key)
            }
            if _dict.value is NSDictionary {
                let test1 = (_dict.value as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
                let mutableDict = NSMutableDictionary.init(dictionary: _dict.value as! NSDictionary)
                for test in test1 {
                    mutableDict.removeObject(forKey: test.key)
                }
                mainDict.removeObject(forKey: _dict.key)
                mainDict.setValue(mutableDict, forKey: _dict.key as? String ?? "")
            }
            if _dict.value is NSArray {
                let mutableArray = NSMutableArray.init(object: _dict.value)
                for (index,element) in mutableArray.enumerated() where element is NSDictionary {
                    let test1 = (element as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
                    let mutableDict = NSMutableDictionary.init(dictionary: element as! NSDictionary)
                    for test in test1 {
                        mutableDict.removeObject(forKey: test.key)
                    }
                    mutableArray.replaceObject(at: index, with: mutableDict)
                }
                mainDict.removeObject(forKey: _dict.key)
                mainDict.setValue(mutableArray, forKey: _dict.key as? String ?? "")
            }
        }
        return mainDict as! Dictionary<Key, Value>
    }
}

extension UIView {
    @IBInspectable
    var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension Date {
    func monthName() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
    func yearNum()-> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("yyyy")
        return df.string(from: self)
    }
}

import UIKit

// MARK: Add Toast method function in UIView Extension so can use in whole project.
extension UIView {
    func showToast(toastMessage: String, duration: CGFloat) {
    // View to blur bg and stopping user interaction
    let bgView = UIView(frame: self.frame)
    bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
    bgView.tag = 555

    // Label For showing toast text
    let lblMessage = UILabel()
    lblMessage.numberOfLines = 0
    lblMessage.lineBreakMode = .byWordWrapping
    lblMessage.textColor = .white
    lblMessage.backgroundColor = .black
    lblMessage.textAlignment = .center
    lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
    lblMessage.text = toastMessage

    // calculating toast label frame as per message content
    let maxSizeTitle: CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
    var expectedSizeTitle: CGSize = lblMessage.sizeThatFits(maxSizeTitle)
    // UILabel can return a size larger than the max size when the number of lines is 1
    expectedSizeTitle = CGSize(width: maxSizeTitle.width.getMinimum(value2: expectedSizeTitle.width), height: maxSizeTitle.height.getMinimum(value2: expectedSizeTitle.height))
    lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2), y: (self.bounds.size.height) - ((expectedSizeTitle.height+46)), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
    lblMessage.layer.cornerRadius = 8
    lblMessage.layer.masksToBounds = true
    lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    bgView.addSubview(lblMessage)
    self.addSubview(bgView)
    lblMessage.alpha = 0

    UIView.animateKeyframes(withDuration: TimeInterval(duration), delay: 0, options: [], animations: {
        lblMessage.alpha = 1
    }, completion: { success in
        UIView.animate(withDuration: TimeInterval(duration), delay: 8, options: [], animations: {
        lblMessage.alpha = 0
        bgView.alpha = 0
        })
        bgView.removeFromSuperview()
    })
}
}

extension CGFloat {
    func getMinimum(value2: CGFloat) -> CGFloat {
    if self < value2 {
        return self
    } else
    {
        return value2
        }
    }
}
        
        // MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.
        
        extension UILabel {
        private struct AssociatedKeys {
            static var padding = UIEdgeInsets()
        }
        
        var padding: UIEdgeInsets? {
            get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
            }
            set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            }
        }
        
        override open func draw(_ rect: CGRect) {
            if let insets = padding {
                self.drawText(in: rect.inset(by: insets))
            } else {
            self.drawText(in: rect)
            }
        }
        
        override open var intrinsicContentSize: CGSize {
            get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
            }
        }
    }
