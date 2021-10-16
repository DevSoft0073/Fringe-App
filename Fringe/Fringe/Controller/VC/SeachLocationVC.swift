//
//  SeachLocationVC.swift
//  Fringe
//
//  Created by MyMac on 10/13/21.
//
import UIKit
import Foundation
import GooglePlaces
import IQKeyboardManagerSwift

class SeachLocationVC : BaseVC , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tblLocation: UITableView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var locationArray = [String]()
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func setup() {
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        tblLocation.delegate = self
        tblLocation.dataSource = self
        
        let identifier = String(describing: SearchLocationCell.self)
        let nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblLocation.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
    }
    
    //------------------------------------------------------
        
    //MARK: Google place API request
    
    func googlePlacesResult(input: String, completion: @escaping (_ result: NSArray) -> Void) {
        let searchWordProtection = input.replacingOccurrences(of: " ", with: "");        if searchWordProtection.count != 0 {
            let urlString = NSString(format: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment|geocode&location=%@,%@&radius=500&language=en&key= your key",input,"\(PreferenceManager.shared.lat ?? 0.0)","\(PreferenceManager.shared.long ?? 0.0)")
            print(urlString)
            let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
            print(url!)
            let defaultConfigObject = URLSessionConfiguration.default
            let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
            let request = NSURLRequest(url: url! as URL)
            let task =  delegateFreeSession.dataTask(with: request as URLRequest, completionHandler:
            {
                (data, response, error) -> Void in
                if let data = data
                {
                    do {
                        let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                        let results:NSArray = jSONresult["predictions"] as! NSArray
                        let status = jSONresult["status"] as! String
                        if status == "NOT_FOUND" || status == "REQUEST_DENIED"
                        {
                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as? [String : AnyObject])
                            let arr:NSArray = [newError]
                            completion(arr)
                            return
                        }
                        else
                        {
                            completion(results)
                        }
                    }
                    catch
                    {
                        print("json error: \(error)")
                    }
                }
                else if let error = error
                {
                    print(error)
                }
            })
            task.resume()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchLocationCell.self)) as? SearchLocationCell {
            
            return cell
        }
        return UITableViewCell()
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnUpdateLocation(_ sender: Any) {
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
