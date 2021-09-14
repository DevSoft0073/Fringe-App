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
    
    var golfDetails: HomeModal?
    var items: [CheckModal] = []
    var addRequaet: BookingRequestModal?
    var todayDate = Date()
    var sendingDate = String()
    var requestDate = String()
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
        
        if sendingDate.isEmpty == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d ,yyyy"
            sendingDate = formatter.string(from: todayDate)
        }
        
        let parameter: [String: Any] = [
            Request.Parameter.golfID: golfDetails?.golfID ?? String(),
            Request.Parameter.dates: sendingDate,
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.checkRequest, parameter: parameter,headers: headers, showLoader: false, decodingType: ResponseModal<[CheckModal]>.self, successBlock: { (response: ResponseModal<[CheckModal]>) in
            
            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {
                self.items.append(contentsOf: response.data ?? [])
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
    
    func performAddRequest(completion:((_ flag: Bool) -> Void)?) {

        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        let deviceTimeZone = TimeZone.current.abbreviation()
        if requestDate.isEmpty == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            requestDate = formatter.string(from: todayDate)
            
            requestDate = sendingDate.convertDatetring_TopreferredFormat(currentFormat: "MMM d ,yyyy", toFormat: "dd-MM-yyyy")
        }
        
        let parameter: [String: Any] = [
            Request.Parameter.golfID: golfDetails?.golfID ?? String(),
            Request.Parameter.dates: sendingDate,
            Request.Parameter.userID: PreferenceManager.shared.userId ?? String(),
            Request.Parameter.timeZone: deviceTimeZone ?? String(),
            
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.bookingRequest, parameter: parameter,headers: headers, showLoader: false, decodingType: ResponseModal<BookingRequestModal>.self, successBlock: { (response: ResponseModal<BookingRequestModal>) in
            
            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {
                delay {
                    completion?(true)
                }

            } else if response.code == Status.Code.alreadyAdded{
                DispatchQueue.main.async {
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? String()) {
                    }
                }
                
                completion?(false)
                
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
        
        LoadingManager.shared.showLoading()
        
        performAddRequest { (flag : Bool) in
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.addRequestSent.localized()) {
                LoadingManager.shared.hideLoading()
                NavigationManager.shared.setupLandingOnGOlfVC()
            }
        }
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
        formatter.dateFormat = "MMM d ,yyyy"
        sendingDate = formatter.string(from: date)
        
        LoadingManager.shared.showLoading()
        
        self.performGetRequestListing { (flag : Bool) in
            
        }
    }

    //------------------------------------------------------
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckAvailabilityTBCell.self)) as? CheckAvailabilityTBCell {
            let data = items[indexPath.row]
            cell.setup(bookingData: data)
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

