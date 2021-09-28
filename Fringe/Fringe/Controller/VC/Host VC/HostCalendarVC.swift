//
//  HostCalendarVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit
import Alamofire
import Foundation
import FSCalendar
import IQKeyboardManagerSwift

protocol SendSelectedDate {
    func sendSelectedDate (date : Date)
}

class HostCalendarVC : BaseVC, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var lblHeader: FGMediumLabel!
    @IBOutlet weak var lblNow: FGBaseLabel!
    @IBOutlet weak var myCalendar: FSCalendar!
    @IBOutlet weak var tblCalendar: UITableView!
    
    var items: [CheckModal] = []
    var sendingDate = String()
    var selectedDate = String()
    var selectedDates = String()
    var selectedDateDelegate : SendSelectedDate?
    var todayDate = Date()
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
        tblCalendar.delegate = self
        tblCalendar.dataSource = self
        var identifier = String(describing: CheckAvailabilityHeaderView.self)
        var nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblCalendar.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HostCalendarTBCell.self)
        nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblCalendar.register(nibProfileCell, forCellReuseIdentifier: identifier)
        myCalendar.clipsToBounds = true
        myCalendar.appearance.headerMinimumDissolvedAlpha = 0
        myCalendar.delegate = self
        myCalendar.dataSource = self
        myCalendar.today = Date()
    }
    
    func updateUI() {
        noDataLbl.isHidden = items.count != .zero
        tblCalendar.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Calendar delegates
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let selectedDate = dateFormatter.string(from: date)
        self.selectedDate = selectedDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d ,yyyy"
        sendingDate = formatter.string(from: date)
        
        LoadingManager.shared.showLoading()
        
        self.performGetRequestListing { (flag : Bool) in
            
        }
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return todayDate
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

        let parameter: [String: Any] = [
            Request.Parameter.golfID: PreferenceManager.shared.golfId ?? String(),
            Request.Parameter.dates: sendingDate,
        ]

        RequestManager.shared.requestPOST(requestMethod: Request.Method.checkRequest, parameter: parameter,headers: headers, showLoader: false, decodingType: ResponseModal<[CheckModal]>.self, successBlock: { (response: ResponseModal<[CheckModal]>) in

            self.items.removeAll()
            
            LoadingManager.shared.hideLoading()

            if response.code == Status.Code.success {
                self.lblHeader.isHidden = false
                self.items.append(contentsOf: response.data ?? [])
                self.items = self.items.removingDuplicates()
                completion?(true)
                self.updateUI()

            } else {
                
                self.lblHeader.isHidden = true
                self.items.removeAll()
                self.updateUI()
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
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnAdd(_ sender: Any) {
        let controller = NavigationManager.shared.addCalendarPopUpVC
        controller.modalPresentationStyle = .formSheet
        controller.selectedDate = selectedDate
        controller.updateTblViewData = {
            
            DispatchQueue.main.async {
                self.performGetRequestListing { (flag: Bool) in
                    self.updateUI()
                }
            }
        }

        self.present(controller, animated: true)
    }
    
    @IBAction func btnNextMonth(_ sender: Any) {
        
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: myCalendar.currentPage)
        myCalendar.setCurrentPage(nextMonth!, animated: true)
        print(myCalendar.currentPage)
    }
    
    @IBAction func btnPreviousMonth(_ sender: Any) {
        myCalendar.setCurrentPage(getPreviousMonth(date: myCalendar.currentPage), animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostCalendarTBCell.self)) as? HostCalendarTBCell {
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
    
    //MARK: Attributed Text
    
    func decorateText(sub:String, des:String)->NSAttributedString{
        let textAttributesOne = [NSAttributedString.Key.foregroundColor: FGColor.appBlack, NSAttributedString.Key.font: FGFont.PoppinsSemiBold(size: 14)]
        let textAttributesTwo = [NSAttributedString.Key.foregroundColor: FGColor.appBlack, NSAttributedString.Key.font: FGFont.PoppinsRegular(size: 12)]
        
        let textPartOne = NSMutableAttributedString(string: sub, attributes: textAttributesOne)
        let textPartTwo = NSMutableAttributedString(string: des, attributes: textAttributesTwo)
        
        let textCombination = NSMutableAttributedString()
        textCombination.append(textPartOne)
        textCombination.append(textPartTwo)
        lblNow.attributedText = textCombination
        return textCombination
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNow.attributedText = decorateText(sub: "Please note ", des: "Fringe collects an 18% service fee on all transactions. Clubs funds are released after each golfclub session is completed.")
        
        setup()
        self.updateUI()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        LoadingManager.shared.showLoading()
        
        self.performGetRequestListing { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //------------------------------------------------------
}
