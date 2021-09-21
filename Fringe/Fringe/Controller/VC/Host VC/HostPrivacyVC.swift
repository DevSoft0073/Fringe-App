//
//  HostPrivacyVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 02/09/21.
//

import UIKit
import Foundation
import WebKit

class HostPrivacyVC : BaseVC, WKNavigationDelegate {
    
    @IBOutlet weak var privacyWebView: WKWebView!
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
        privacyWebView.frame = view.bounds
        privacyWebView.navigationDelegate = self
        
        let url = URL(string: "https://www.dharmani.com/fringe/webservices/Privacy.html")!
        let urlRequest = URLRequest(url: url)
        
        privacyWebView.load(urlRequest)
        privacyWebView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
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
        NavigationManager.shared.isEnabledBottomMenuForHost = false
    }
    
    //------------------------------------------------------
}
