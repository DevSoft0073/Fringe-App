//
//  ServiceTermsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 27/08/21.
//

import UIKit
import WebKit
import Foundation

class ServiceTermsVC : BaseVC, WKNavigationDelegate{
    
    @IBOutlet weak var termsWebView: WKWebView!
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
    
    func openLinks()  {
        termsWebView.frame = view.bounds
        termsWebView.navigationDelegate = self
        
        let url = URL(string:PreferenceManager.shared.userBaseURL + "/terms&conditions.html")!
        let urlRequest = URLRequest(url: url)
        
        termsWebView.load(urlRequest)
        termsWebView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openLinks()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = false

    }
    
    //------------------------------------------------------
}
