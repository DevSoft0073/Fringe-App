//
//  MyBookingVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 19/08/21.
//

import UIKit
import Foundation

class MyBookingVC : BaseVC , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tblBooking: UITableView!
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
        tblBooking.delegate = self
        tblBooking.dataSource = self
       
        
//        let loadMoreView = KRPullLoadView()
//        loadMoreView.delegate = self
//        tblNotification.addPullLoadableView(loadMoreView, type: .refresh)
        
        let identifier = String(describing: MyBookingTVCell.self)

        let nibRequestCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblBooking.register(nibRequestCell, forCellReuseIdentifier: identifier)
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyBookingTVCell.self)) as? MyBookingTVCell {
            cell.imgMain.roundCornersLeft( [.topLeft, .bottomLeft],radius: 16)
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
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}
