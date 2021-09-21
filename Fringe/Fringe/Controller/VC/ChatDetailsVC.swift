//
//  ChatDetailsVC.swift
//  Fringe
//
//  Created by MyMac on 9/21/21.
//
import UIKit
import MapKit
import MessageKit
import Kingfisher
import InputBarAccessoryView
import IQKeyboardManagerSwift

class ChatDetailsVC : ChatViewController, MessagesDisplayDelegate, MessagesLayoutDelegate, InputBarAccessoryViewDelegate{
    
    
    var currentUser: UserModal? {
        return PreferenceManager.shared.currentUserModal
    }
    var currentStudioUser: HostModal? {
        return PreferenceManager.shared.currentUserModalForHost
    }
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
