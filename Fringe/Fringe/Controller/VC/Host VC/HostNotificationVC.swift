//
//  HostNotificationVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit
import Foundation
import KRPullLoader

class HostNotificationVC : BaseVC, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblNotification: UITableView!
    
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
    
    func setup() {
        tblNotification.delegate = self
        tblNotification.dataSource = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        
//        let loadMoreView = KRPullLoadView()
//        loadMoreView.delegate = self
//        tblNotification.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: HostNotificationCell.self)

        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblNotification.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    
    //------------------------------------------------------
    
   //MARK: UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostNotificationCell.self)) as? HostNotificationCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
