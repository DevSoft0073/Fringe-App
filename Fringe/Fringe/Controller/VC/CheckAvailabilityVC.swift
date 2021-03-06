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
    
    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var myCalendar: FSCalendar!
    @IBOutlet weak var tblAvailability: UITableView!
    @IBOutlet weak var noDataLbl: FGSemiboldLabel!
    
    var golfId = String()
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
        noDataLbl.isHidden = items.count != .zero
        tblAvailability.reloadData()
    }
    
    func performGetRequestListing(completion:((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        if sendingDate.isEmpty == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            sendingDate = formatter.string(from: todayDate)
        }
        //        sendingDate = sendingDate.convertDatetring_TopreferredFormat(currentFormat: "MMM d ,yyyy", toFormat: "dd-MM-yyyy")
        let parameter: [String: Any] = [
            Request.Parameter.golfID: golfDetails?.golfID ?? golfId,
            Request.Parameter.dates: sendingDate,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.checkRequest, parameter: parameter,headers: headers, showLoader: false, decodingType: ResponseModal<[CheckModal]>.self, successBlock: { (response: ResponseModal<[CheckModal]>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                self.btnRequest.isHidden = false
                self.items.append(contentsOf: response.data ?? [])
                self.items = self.items.removingDuplicates()
                completion?(true)
                self.updateUI()
                
            } else {
                
                self.items.removeAll()
                self.updateUI()
                self.btnRequest.isHidden = true
                completion?(true)
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                
                DisplayAlertManager.shared.displayAlert(target: self, animated: false, message: error.localizedDescription) {
                    PreferenceManager.shared.userId = nil
                    PreferenceManager.shared.currentUser = nil
                    PreferenceManager.shared.authToken = nil
                    NavigationManager.shared.setupSingIn()
                }
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
        }
        
        let parameter: [String: Any] = [
            Request.Parameter.golfID: golfDetails?.golfID ?? golfId,
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
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String())
                    
                }
                
                completion?(true)
                
            } else if response.code == Status.Code.bookedSlot{
                
                delay {
                    
                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String())
                    
                }
                
                completion?(true)
                
            } else {
                
                completion?(true)
                
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: LocalizableConstants.Error.anotherLogin, handlerOK: nil)
                PreferenceManager.shared.userId = nil
                PreferenceManager.shared.currentUser = nil
                PreferenceManager.shared.authToken = nil
                NavigationManager.shared.setupSingIn()
            }
        })
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "MMM d ,yyyy"
        formatter.dateFormat = "dd-MM-yyyy"
        sendingDate = formatter.string(from: todayDate)
        return todayDate
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "MMM d ,yyyy"
        formatter.dateFormat = "dd-MM-yyyy"
        sendingDate = formatter.string(from: date)
        
        LoadingManager.shared.showLoading()
        
        self.performGetRequestListing { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBooking(_ sender: Any) {
        
        LoadingManager.shared.showLoading()
        
        delay {
            self.performAddRequest { (flag : Bool) in
                DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: LocalizableConstants.SuccessMessage.addRequestSent.localized()) {
                    NavigationManager.shared.setupLandingOnGOlfVC()
                }
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
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckAvailabilityTBCell.self)) as? CheckAvailabilityTBCell {
            if items.count > 0{
                let data = items[indexPath.row]
                cell.setup(bookingData: data)
                return cell
            } else {
                
            }
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
        tblAvailability.isScrollEnabled = false
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

