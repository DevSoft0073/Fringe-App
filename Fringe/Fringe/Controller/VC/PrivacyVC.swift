//
//  PrivacyVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 27/08/21.
//

import UIKit
import WebKit
import Foundation

class PrivacyVC : BaseVC, WKNavigationDelegate{
    
    @IBOutlet weak var privacyPolicyView: WKWebView!
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
        privacyPolicyView.frame = view.bounds
        privacyPolicyView.navigationDelegate = self
        
        let url = URL(string: PreferenceManager.shared.userBaseURL + "/Privacy.html")!
        let urlRequest = URLRequest(url: url)
        
        privacyPolicyView.load(urlRequest)
        privacyPolicyView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
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
