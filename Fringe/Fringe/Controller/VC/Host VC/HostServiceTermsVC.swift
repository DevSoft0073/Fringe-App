//
//  HostServiceTermsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 02/09/21.
//

import UIKit
import Foundation
import WebKit

class HostServiceTermsVC : BaseVC , WKNavigationDelegate{
    
    @IBOutlet weak var serviceWebView: WKWebView!
    
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
        serviceWebView.frame = view.bounds
        serviceWebView.navigationDelegate = self
        
        let url = URL(string: "https://www.dharmani.com/fringe/webservices/terms&conditions.html")!
        let urlRequest = URLRequest(url: url)
        
        serviceWebView.load(urlRequest)
        serviceWebView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
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
