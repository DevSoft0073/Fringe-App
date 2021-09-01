//
//  HostCalendarVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit
import Foundation
import FSCalendar
import IQKeyboardManagerSwift


class HostCalendarVC : BaseVC, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var lblNow: FGBaseLabel!
    @IBOutlet weak var myCalendar: FSCalendar!
    @IBOutlet weak var tblCalendar: UITableView!
    
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
    }
    func updateUI() {
        
        tblCalendar.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnAdd(_ sender: Any) {
        
    }
    @IBAction func btnNextMonth(_ sender: Any) {
        
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: myCalendar.currentPage)
        myCalendar.setCurrentPage(nextMonth!, animated: true)
          print(myCalendar.currentPage)
    }
    
    @IBAction func btnPreviousMonth(_ sender: Any) {
        myCalendar.setCurrentPage(getPreviousMonth(date: myCalendar.currentPage), animated: true)
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    //------------------------------------------------------
    
    //MARK: Calendar delegates

    func minimumDate(for calendar: FSCalendar) -> Date {
        return todayDate
     }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource , UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostCalendarTBCell.self)) as? HostCalendarTBCell {
           
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
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
