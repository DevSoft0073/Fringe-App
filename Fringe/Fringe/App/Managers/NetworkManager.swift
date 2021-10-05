////
////  NetworkManager.swift
////  Fringe
////
////  Created by MyMac on 10/5/21.
////
////
//
//import Foundation
//import Alamofire
//import SVProgressHUD
//
//public enum NetworkResponseStatus {
//    case success
//    case error(string: String?)
//}
//
//public class NetworkManager {
////    public var baseURL: String = "https://www.dharmani.com/letters/webservices/"
//    public var baseURL: String = "https://www.dharmani.com/fringe/webservices"
//
//    public static let shared: NetworkManager = NetworkManager()
//    private init () {
//
//    }
//}
//
//extension NetworkManager {
//
//    func postJSONResponse(path: String, parameters: [String:Any]?,isLoder:Bool = true, isHeader:Bool = false,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
//        let requestPath = baseURL + path
//        if isLoder {
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.show()
//        }
//        //print(requestPath)
//        var updateParams = parameters
//        let userId =   PreferenceManager.shared.userId
//        if !(userId?.isEmpty) {
//            updateParams?["userId"] = userId
//        }
//
//        let headerValue: HTTPHeaders? = nil
//
//        Alamofire.request(requestPath,method: .post,parameters: updateParams,encoding: JSONEncoding.default,headers: isHeader ? headerValue : nil).responseJSON { response in
//
////            if let data =  response.data {
////                let str = String(decoding: data, as: UTF8.self)
////            print("JSON:\(str)")
////            }
//
//            switch response.result {
//            case .success(let value):
//                // //print(value)
//                if let json = value as? [String: Any] {
//                    completionHandler(json, .success)
//                }
//            case .failure(let error):
////                if let data = response.data,
////                let str = String(data: data, encoding: String.Encoding.utf8){
////                    //print("Server Error: " + str)
////                }
//                completionHandler(nil, .error(string: error.localizedDescription))
//            }
//            DispatchQueue.main.async {
//                if isLoder {
//                    SVProgressHUD.dismiss()
//                }
//            }
//        }
//    }
//    func getJSONResponse(path: String, parameters: [String:Any]?, isHeader:Bool = false,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
//        let requestPath = baseURL + path
//        SVProgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.show()
//        let headerValue: HTTPHeaders? = nil
//        Alamofire.request(requestPath,method: .get,parameters: parameters, encoding: JSONEncoding.default,headers: isHeader ? headerValue : nil).responseJSON { response in
//            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
//            }
//            switch response.result {
//            case .success(let value):
//                if let json = value as? [String: Any] {
//                    completionHandler(json, .success)
//                }
//            case .failure(let error):
//                completionHandler(nil, .error(string: error.localizedDescription))
//            }
//        }
//    }
//
//    func postImageJSONResponse(path: String, parameters: [String: Any],isLoder:Bool = true, isHeader:Bool = false,image:Data!,imageName:String!,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
//        if isLoder {
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.show()
//        }
//        let urlString = baseURL + path
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data",
//            "Accept": "application/json"
//        ]
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if let temp = value as? String {
//                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
//                    }
//                }
//                if image != nil {
//        multipartFormData.append(image, withName: imageName, fileName: "image.png", mimeType: "image/png")
//                }
//            },
//            to: urlString, //URL Here
//            method: .post,
//            headers: headers)
//            .responseJSON { (resp) in
//
////                if let data =  resp.data {
////                    let str = String(decoding: data, as: UTF8.self)
////                //print("JSON:\(str)")
////                }
//
//                defer { DispatchQueue.main.async {
//                    SVProgressHUD.dismiss()
//                }
//
//                }
////                //print("resp is \(resp)")
//                switch resp.result {
//                case .success(let value):
//                    if let json = value as? [String: Any] {
//                        completionHandler(json, .success)
//                    }
//                case .failure(let error):
//                    completionHandler(nil, .error(string: error.localizedDescription))
//                }
//
//            }
//    }
//    func postImageVideoJSONResponse(path: String, parameters: [String: Any],isLoder:Bool = true, isHeader:Bool = false,image:Data!,videoPathUrl:URL,imageName:String!,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
//        if isLoder {
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.show()
//        }
//        let urlString = baseURL + path
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data",
//            "Accept": "application/json"
//        ]
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if let temp = value as? String {
//                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
//                    }
//                }
//                if image != nil {
//        multipartFormData.append(image, withName: imageName, fileName: "image.png", mimeType: "image/png")
//                }
//        multipartFormData.append(videoPathUrl, withName: "letterVideo", fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "mp4")
//
//            },
//            to: urlString, //URL Here
//            method: .post,
//            headers: headers)
//            .responseJSON { (resp) in
//
////                if let data =  resp.data {
////                    let str = String(decoding: data, as: UTF8.self)
////                //print("JSON:\(str)")
////                }
//
//                defer { DispatchQueue.main.async {
//                    SVProgressHUD.dismiss()
//                }
//
//                }
////                //print("resp is \(resp)")
//                switch resp.result {
//                case .success(let value):
//                    if let json = value as? [String: Any] {
//                        completionHandler(json, .success)
//                    }
//                case .failure(let error):
//                    completionHandler(nil, .error(string: error.localizedDescription))
//                }
//
//            }
//    }
//    func postAddletrsJSONResponse(path: String, parameters: [String: Any],isLoder:Bool = true, isHeader:Bool = false,signature:Data?,paperImage:Data?,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
//        if isLoder {
//            SVProgressHUD.show()
//        }
//        let urlString = baseURL + path
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data",
//            "Accept": "application/json"
//        ]
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if let temp = value as? String {
//                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
//                    }
//                }
//                if let signatureSS = signature {
//                multipartFormData.append(signatureSS, withName: "signature", fileName: "signature.png", mimeType: "image/png")
//                }
//                if let paperImageSS = paperImage {
//                    multipartFormData.append(paperImageSS, withName: "paperImage", fileName: "paperImage.png", mimeType: "image/png")
//                }
//
//            },
//            to: urlString, //URL Here
//            method: .post,
//            headers: headers)
//            .responseJSON { (resp) in
//                defer { DispatchQueue.main.async {
//                    SVProgressHUD.dismiss()
//                }
//
//                }
//              //  print("resp is \(resp)")
//                switch resp.result {
//                case .success(let value):
//                    if let json = value as? [String: Any] {
//                        completionHandler(json, .success)
//                    }
//                case .failure(let error):
//                    completionHandler(nil, .error(string: error.localizedDescription))
//                }
//
//            }
//    }
//    func postUpdateProfileImageJSONResponse(path: String, parameters: [String: Any],isLoder:Bool = true, isHeader:Bool = false,image:Data?,imageName:String?,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
//        if isLoder {
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.show()
//        }
//        let urlString = baseURL + path
//        let headers: HTTPHeaders = [
//            "Content-type": "multipart/form-data",
//            "Accept": "application/json"
//        ]
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if let temp = value as? String {
//                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
//                    }
//                }
//                if let imName = imageName {
//                    if let isms = image {
//                        multipartFormData.append(isms, withName: imName, fileName: "image.png", mimeType: "image/png")
//                    }
//                }
//            },
//            to: urlString, //URL Here
//            method: .post,
//            headers: headers)
//            .responseJSON { (resp) in
//                defer { DispatchQueue.main.async {
//                    SVProgressHUD.dismiss()
//                }
//
//                }
//                //print("resp is \(resp)")
//                switch resp.result {
//                case .success(let value):
//                    if let json = value as? [String: Any] {
//                        completionHandler(json, .success)
//                    }
//                case .failure(let error):
//                    completionHandler(nil, .error(string: error.localizedDescription))
//                }
//
//            }
//    }
//    func getMusicListJSONResponse(path: String, parameters: [String:Any]?, isHeader:Bool = false,completionHandler: @escaping (_ response: Any?,_ status: NetworkResponseStatus) -> Void) {
//        let requestPath = "https://api.napster.com/v2.2/tracks/top?apikey=ZTk2YjY4MjMtMDAzYy00MTg4LWE2MjYtZDIzNjJmMmM0YTdm&limit=200"
//        SVProgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.show()
//        let url = URL(string: requestPath)!
//
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            SVProgressHUD.dismiss()
//            guard let data = data else { return }
//            do {
//                // make sure this JSON is in the format we expect
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // try to read out a string array
//                    completionHandler(json, .success)
//
//                }
//            } catch let error as NSError {
//                                completionHandler(nil, .error(string: error.localizedDescription))
//            }
//        }
//        task.resume()
//
////        AF.request(requestPath,method: .get,parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
////            DispatchQueue.main.async {
////                SVProgressHUD.dismiss()
////            }
////            switch response.result {
////            case .success(let value):
////                if let json = value as? [String: Any] {
////                    completionHandler(json, .success)
////                }
////            case .failure(let error):
////                completionHandler(nil, .error(string: error.localizedDescription))
////            }
////        }
//    }
//}
