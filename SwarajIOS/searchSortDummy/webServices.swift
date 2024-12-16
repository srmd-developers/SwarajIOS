

import UIKit

//MARK: -
//MARK: - WebServices Delegates Methods
protocol webServicesDelegate {
    func responseData(data : NSData, reqId : String)
    func errorResponse(err : String, reqId : String)
}

class webServices {
    var delegate : webServicesDelegate? = nil
    var requestId : String = ""
    
    //MARK: -
    //MARK: - "POST" Request WebServices Method
    func postRequest(reqStr : String,postParams : AnyObject, reqId : String){
        
        print("Request Str : \(reqStr)")
		let pp = NSString(data: (postParams as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
		print("Post Params : \(pp)")
		
        let request = NSMutableURLRequest(url: NSURL(string: reqStr)! as URL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let postString = postParams
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.addValue("application/x-www-form-urlencoded",forHTTPHeaderField: "Content-Type")
        request.addValue("*/*",forHTTPHeaderField: "Accept")
        request.httpBody = postString as? NSData as Data?

        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in DispatchQueue.main.async(execute: {
                if error != nil {
                    self.delegate?.errorResponse(err: cfg.no_internet,reqId: reqId)
                }
                else {
                    let httpResponse = response as! HTTPURLResponse
                    print("httpResponse -> \(httpResponse.statusCode)")
                    switch httpResponse.statusCode {
                    case 503:
                        self.delegate?.errorResponse(err: cfg.err_no_503,reqId: reqId)
                        break
                    case 404:
                        self.delegate?.errorResponse(err: cfg.err_no_404,reqId: reqId)
                        break
                    case 200:
                        self.delegate?.responseData(data: data! as NSData,reqId: reqId)
                        break
                    case 0:
                        self.delegate?.errorResponse(err: cfg.err_no_0,reqId: reqId)
                        break
                    default:
                        self.delegate?.errorResponse(err: cfg.err_default,reqId: reqId)
                        break
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
        task.resume()
    }
    
    //MARK: -
    //MARK: - "GET" Request WebServices Method
    func getRequest(reqStr : String, reqId : String){
        
        print("Request Str : \(reqStr)")
        
        let request = NSMutableURLRequest(url: NSURL(string: reqStr)! as URL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in DispatchQueue.main.async(execute: {
                if error != nil {
                    self.delegate?.errorResponse(err: cfg.no_internet,reqId: reqId)
                }
                else {
                    let httpResponse = response as! HTTPURLResponse
                    print("httpResponse -> \(httpResponse.statusCode)")
                    switch httpResponse.statusCode {
                    case 503:
                        self.delegate?.errorResponse(err: cfg.err_no_503,reqId: reqId)
                        break
                    case 404:
                        self.delegate?.errorResponse(err: cfg.err_no_404,reqId: reqId)
                        break
                    case 200:
                        self.delegate?.responseData(data: data! as NSData,reqId: reqId)
                        break
                    case 0:
                        self.delegate?.errorResponse(err: cfg.err_no_0,reqId: reqId)
                        break
                    default:
                        self.delegate?.errorResponse(err: cfg.err_default,reqId: reqId)
                        break
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
        task.resume()
    }

}
