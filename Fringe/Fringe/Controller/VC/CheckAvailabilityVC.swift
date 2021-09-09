//
//  CheckAvailabilityVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 21/08/21.
//

import UIKit
import Alamofire
import FSCalendar
import Foundation
import IQKeyboardManagerSwift

class CheckAvailabilityVC : BaseVC, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var myCalendar: FSCalendar!
    @IBOutlet weak var tblAvailability: UITableView!
    
    var checkData: CheckModal?
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
        myCalendar.delegate = self
        myCalendar.dataSource = self
        myCalendar.appearance.headerMinimumDissolvedAlpha = 0
    }
    
    func updateUI() {
        
        tblAvailability.reloadData()
    }
    
    func performGetRequestListing(completion:((_ flag: Bool) -> Void)?) {

        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.lastID: "lastRequestId",
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.favoriteListing, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<CheckModal>.self, successBlock: { (response: ResponseModal<CheckModal>) in

            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {
                self.checkData = response.data
                completion?(true)
                self.setup()
                self.updateUI()

            } else {
                completion?(true)
            }

        }, failureBlock: { (error: ErrorModal) in

            LoadingManager.shared.hideLoading()

            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBooking(_ sender: Any) {
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnPreviousMonth(_ sender: Any) {
        myCalendar.setCurrentPage(getPreviousMonth(date: myCalendar.currentPage), animated: true)
    }
    
    @IBAction func btnNextMonth(_ sender: Any) {
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        print(result)
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
        
        LoadingManager.shared.showLoading()
        
        self.performGetRequestListing { (flag : Bool) in
            
        }
        
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

