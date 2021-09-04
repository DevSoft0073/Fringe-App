//
//  HomeListingVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 25/08/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class HomeListingVC : BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var txtSearchFld: FGRegularTextField!
    @IBOutlet weak var tblListing: UITableView!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup(){
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        tblListing.delegate = self
        tblListing.dataSource = self
        
        
        let identifier = String(describing: HomeListingTBCell.self)
        let nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblListing.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
    }
    
    static func instantiate() -> HomeListingVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "HomeListingVC") as! HomeListingVC
    }
    
    func updateUI() {
        
        tblListing.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    @IBAction func btnNotification(_ sender: Any) {
        let controller = NavigationManager.shared.notificationVC
        push(controller: controller)
        
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListingTBCell.self)) as? HomeListingTBCell {
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
//        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
