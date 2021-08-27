//
//  CheckAvailabilityVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift
import FSCalendar

class CheckAvailabilityVC : BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myCalendar: FSCalendar!
    @IBOutlet weak var tblAvailability: UITableView!
    
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
        tblAvailability.delegate = self
        tblAvailability.dataSource = self
        var identifier = String(describing: CheckAvailabilityHeaderView.self)
        var nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblAvailability.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: CheckAvailabilityTBCell.self)
        nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblAvailability.register(nibProfileCell, forCellReuseIdentifier: identifier)
        myCalendar.appearance.headerMinimumDissolvedAlpha = 0
    }
    func updateUI() {
        
        tblAvailability.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBooking(_ sender: Any) {
    }
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnPreviousMonth(_ sender: Any) {
        print("left")
        myCalendar.setCurrentPage(getPreviousMonth(date: myCalendar.currentPage), animated: true)
    }
    
    
    
    @IBAction func btnNextMonth(_ sender: Any) {
        print("right")
        //        myCalendar.setCurrentPage(getNextMonth(date: myCalendar.currentPage), animated: true)
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: myCalendar.currentPage)
        myCalendar.setCurrentPage(nextMonth!, animated: true)
        print(myCalendar.currentPage)
    }
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    //------------------------------------------------------
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckAvailabilityTBCell.self)) as? CheckAvailabilityTBCell {
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
        
    }
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        myCalendar.clipsToBounds = true
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        NavigationManager.shared.isEnabledBottomMenu = false
    }
    
    //------------------------------------------------------
}

