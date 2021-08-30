//
//  BookingsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 30/08/21.
//

import UIKit
import Foundation

class BookingsVC : BaseVC, UITableViewDataSource, UITableViewDelegate, SegmentViewDelegate {
    
    
    
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    
    @IBOutlet weak var segment3: SegmentView!
    @IBOutlet weak var segment2: SegmentView!
    @IBOutlet weak var segment1: SegmentView!
    @IBOutlet weak var tblBooking: UITableView!
    
    var needToshowInfoView: Bool = false
    var btnTapped = true
    var items = [""]
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custom
    func setup() {
        tblBooking.dataSource = self
        tblBooking.delegate = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        segment1.btn.setTitle(LocalizableConstants.Controller.Fringe.pending.localized(), for: .normal)
        segment2.btn.setTitle(LocalizableConstants.Controller.Fringe.awaiting.localized(), for: .normal)
        segment3.btn.setTitle(LocalizableConstants.Controller.Fringe.confirmed.localized(), for: .normal)
        
        segment1.delegate = self
        segment2.delegate = self
        segment3.delegate = self
        
        segment1.isSelected = true
        segment2.isSelected = !segment1.isSelected
        segment3.isSelected = !segment1.isSelected
        
        var identifier = String(describing:HostPendingCell.self)
        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblBooking.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HostAwaitingCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblBooking.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HostConfirmedCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblBooking.register(nibCell, forCellReuseIdentifier: identifier)
    }
    
    func updateUI() {
        
        if items.count == 0{
            self.noDataLbl.isHidden = false
        }else{
            self.noDataLbl.isHidden = true
        }
        
        if segment1.isSelected == true {
            
            noDataLbl.text = LocalizableConstants.Controller.FringeDataForGolfclub.pending.localized()
            noDataLbl.isHidden = items.count != .zero
            
        } else if segment2.isSelected == true {
            
            noDataLbl.text = LocalizableConstants.Controller.FringeDataForGolfclub.confirmed.localized()
            noDataLbl.isHidden = items.count != .zero
            
        } else if segment3.isSelected == true {
            
            noDataLbl.text = LocalizableConstants.Controller.FringeDataForGolfclub.awating.localized()
            noDataLbl.isHidden = items.count != .zero
            
        }
        tblBooking.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segment1.isSelected {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostPendingCell.self)) as? HostPendingCell{
                if items.count > 0 {
//                    let data = items[indexPath.row]
                    
                    cell.btnMoreInfo.addTarget(self, action: #selector(showHideView), for: .touchUpInside)
                    cell.btnReject.tag = indexPath.row
                    cell.btnAccept.tag = indexPath.row
                    if needToshowInfoView {
                        cell.cancelView.isHidden = true
                        
                        cell.btnClose.isHidden = true
                        cell.btnMoreInfo.isHidden = false
                    }
                    cell.btnClose.addTarget(self, action: #selector(showViews), for: .touchUpInside)
                    //                    cell.btnReject.addTarget(self, action: #selector(showpopUpView), for: .touchUpInside)
                    //                    cell.btnAccept.addTarget(self, action: #selector(requestAccept), for: .touchUpInside)
                    return cell
                }else{
                    
                }
                
            }
        } else if segment2.isSelected {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostAwaitingCell.self)) as? HostAwaitingCell {
                
                
                
                return cell
            }else{
                
            }
            
        }
        
        else if segment3.isSelected {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HostConfirmedCell.self)) as? HostConfirmedCell {
                
                
            }
        }
        return UITableViewCell()
    }
    
    //------------------------------------------------------
    
    //MARK:  TableView cell button Actions
    
    @objc func showHideView(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? HostPendingCell{
            self.needToshowInfoView = false
            cell.cancelView.isHidden = false
            
            cell.btnClose.isHidden = false
            cell.btnMoreInfo.isHidden = true
            tblBooking.reloadData()
            btnTapped = false
        }
    }
    @objc func showViews(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? HostPendingCell{
            btnTapped = true
            cell.cancelView.isHidden = true
            
            cell.btnClose.isHidden = true
            cell.btnMoreInfo.isHidden = false
            tblBooking.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    //------------------------------------------------------
    
    //MARK: SegmentViewDelegate
    
    func segment(view: SegmentView, didChange flag: Bool) {
        
        self.needToshowInfoView = true
        
        if view == segment1 {
            
            
            segment2.isSelected = false
            segment3.isSelected = false
            
        } else if view == segment2 {
        
            segment1.isSelected = false
            segment3.isSelected = false
        }
        else if view == segment3 {
        
            segment1.isSelected = false
            segment2.isSelected = false
        }
    }
    
    
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateUI()
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
