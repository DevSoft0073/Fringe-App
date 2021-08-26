//
//  GolfclubsVC.swift
//  Fringe
//
//  Created by Dharmani Apps on 13/08/21.
//

import UIKit
import Foundation
import KRPullLoader

class GolfclubsVC : BaseVC, UITableViewDataSource, UITableViewDelegate, SegmentViewDelegate {
    
    @IBOutlet weak var noDataLbl: FGRegularLabel!
    @IBOutlet weak var segment2: SegmentView!
    @IBOutlet weak var segment1: SegmentView!
    @IBOutlet weak var tblGolf: UITableView!
    
    var needToshowInfoView: Bool = false
    var btnTapped = true
    
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
        tblGolf.dataSource = self
        tblGolf.delegate = self
        navigationItem.title = LocalizableConstants.Controller.Notifications.title.localized()
        //
        //        noDataLbl.text = LocalizableConstants.Controller.FringeDataForGolfclub.pending.localized()
        //
        //        navigationItem.title = LocalizableConstants.Controller.Fringe.title.localized()
        //        segment1.btn.setTitle(LocalizableConstants.Controller.Fringe.pending.localized(), for: .normal)
        //        segment2.btn.setTitle(LocalizableConstants.Controller.Fringe.confirmed.localized(), for: .normal)
        //        segment1.delegate = self
        //        segment2.delegate = self
        //
        //        segment1.isSelected = true
        //        segment2.isSelected = !segment1.isSelected
        //
        var identifier = String(describing: FringePendingCell.self)
        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: FringeConfirmedCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblGolf.register(nibCell, forCellReuseIdentifier: identifier)
        
    }
    
    
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FringePendingCell.self)) as? FringePendingCell {
    
            cell.btnMoreInfo.tag = indexPath.row
            cell.btnMoreInfo.addTarget(self, action: #selector(showHideView), for: .touchUpInside)
            cell.btnClose.tag = indexPath.row
            if needToshowInfoView {
                cell.cancelView.isHidden = true
                cell.btnClose.isHidden = true
                cell.btnMoreInfo.isHidden = false
            }
            cell.btnClose.addTarget(self, action: #selector(showViews), for: .touchUpInside)
         
            //            if segment1.isSelected {
            //                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FringePendingCell.self)) as? FringePendingCell{
            ////                    let data = items[indexPath.row]
            ////                    cell.setup(name: data.studioDetail?.username ?? "", stName: data.studioDetail?.name ?? "", date: data.studioDetail?.address, time: data.time, specialIns: data.specialInstruction ?? "")
            //                    cell.btnMoreInfo.tag = indexPath.row
            //                    cell.btnMoreInfo.addTarget(self, action: #selector(showHideView), for: .touchUpInside)
            //                    cell.btnClose.tag = indexPath.row
            //                    if needToshowInfoView {
            ////                        cell.requestView.isHidden = true
            ////                        cell.instructionView.isHidden = true
            //                        cell.btnClose.isHidden = true
            //                        cell.btnMoreInfo.isHidden = false
            //                    }
            //                    cell.btnClose.addTarget(self, action: #selector(showViews), for: .touchUpInside)
            ////                    cell.btnCancelation.addTarget(self, action: #selector(showpopUpView), for: .touchUpInside)
            //                    return cell
            //                }
            //            }
            return cell
        }
        else if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FringeConfirmedCell.self)) as? FringeConfirmedCell{
            return cell
        }
        return UITableViewCell()
    }
    //    MARK:- Actions
    
    @objc func showHideView(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? FringePendingCell{
            self.needToshowInfoView = false
                        cell.cancelView.isHidden = false
            //            cell.instructionView.isHidden = false
            cell.btnClose.isHidden = false
            cell.btnMoreInfo.isHidden = true
            tblGolf.reloadData()
            btnTapped = false
        }
    }
    @objc func showViews(sender : UIButton) {
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? FringePendingCell{
            btnTapped = true
                        cell.cancelView.isHidden = true
            //            cell.instructionView.isHidden = true
            cell.btnClose.isHidden = true
            cell.btnMoreInfo.isHidden = false
            tblGolf.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NavigationManager.shared.confirmedPayVC
        push(controller: controller)
    }
    
    func segment(view: SegmentView, didChange flag: Bool) {
        //        if segment1.isSelected == true {
        //            
        //        } else {
        //            
        //        }
    }
    
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationManager.shared.isEnabledBottomMenu = true
    }
    
    //------------------------------------------------------
}
