//
//  MessageListingVC.swift
//  Fringe
//
//  Created by MyMac on 10/4/21.
//
import UIKit
import SocketIO
import Alamofire
import Kingfisher
import IQKeyboardManagerSwift

class MessageListingVC : BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var msgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendImg: UIImageView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtSendMsg: UITextView!
    @IBOutlet weak var tblMessage: UITableView!
    
    var roomID = String()
    @IBOutlet weak var sendView: UIView!
    var items =  [AddEditMessageModal]()
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func configureUI(){
        //        self.nameLbl.text = chatListData?.name ?? ""
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessageListingVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses = [MessageListingVC.self]
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tblMessage.addGestureRecognizer(tap)
//        self.profilePic.kf.setImage(with: URL(string: chatListData?.profileImage ?? ""), placeholder:UIImage(named: "logo"))
//        getInofData(withLoad: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let socketConnectionStatus = SocketManger.shared.socket.status
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
                SocketManger.shared.socket.emit("ConncetedChat", self.items.first?.roomID ?? "")
                self.newMessageSocketOn()
            case SocketIOStatus.connecting:
                print("socket connecting")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
                SocketManger.shared.socket.connect()
                self.connectSocketOn()
                self.newMessageSocketOn()
            case SocketIOStatus.notConnected:
                print("socket not connected")
                SocketManger.shared.socket.connect()
                self.connectSocketOn()
                self.newMessageSocketOn()
            }
            
        }
    }
    
    @objc func dismissKeyboard() {
        
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    
    func SendStopMessage(isSend:Bool){
        if isSend{
            sendImg.image = nil
            btnSend.setImage(nil, for: .normal)
        }else{
            sendImg.image = #imageLiteral(resourceName: "send")
        }
    }
    // MARK:- Socket Method(s)
    func connectSocketOn(){
        SocketManger.shared.onConnect {
            SocketManger.shared.socket.emit("ConncetedChat",  self.items.first?.roomID ?? String())
            print("connected")
            
        }
    }
    func newMessageSocketOn(){
        SocketManger.shared.handleNewMessage { (message) in
//            self.msgArr.append(ChatModel(id: message["id"] as? String ?? "", userID: message["userID"] as? String ?? "", roomID: message["roomID"] as? String ?? "", message: message["message"] as? String ?? "", readStatus: message["readStatus"] as? String ?? "", created: message["created"] as? String ?? "", name: message["name"] as? String ?? "", profileImage: message["profileImage"] as? String ?? ""))
            self.tblMessage.reloadData()
            self.scrollToEnd()
            //  self.chatSeenMsg()
        }
    }
    func scrollToEnd(){
        if items.count > 0 {
            tblMessage.scrollToRow(at: IndexPath(item:items.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    @objc func performGetMessage(lastId: String, completion: ((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.roomID: roomID,
            Request.Parameter.lastID: lastId,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.getAllMessgaes, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[AddEditMessageModal]>.self) { (response: ResponseModal<[AddEditMessageModal]>) in
            
            self.items.append(contentsOf: response.data ?? [])
            self.items = self.items.removingDuplicates()
            self.tblMessage.reloadData()
            completion?(true)
            
        } failureBlock: { (errorModal: ErrorModal) in
            
            completion?(false)
        }
    }
    
    func performSendMessage(completion: ((_ message: AddEditMessageModal?, _ errorModal: ErrorModal?) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
        var parameter: [String: Any] = [:]
        parameter = [
            Request.Parameter.roomID: roomID,
            Request.Parameter.message: txtSendMsg.text ?? String(),
        ]
        
        print("chatParam",parameter)
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.sendMsg, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[AddEditMessageModal]>.self) { (response: ResponseModal<[AddEditMessageModal]>) in
            
            completion?(response.data?.first, nil)
            
        } failureBlock: { (errorModal: ErrorModal) in
            
            completion?(nil, errorModal)
        }
    }

    //------------------------------------------------------
    
    //MARK: UITableview delegate datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userId = PreferenceManager.shared.userId
        if userId == items[indexPath.row].userID{
            var cell: RightCell! = tableView.dequeueReusableCell(withIdentifier: "RightCell") as? RightCell
            if cell == nil {
                tableView.register(UINib(nibName: "RightCell", bundle: nil), forCellReuseIdentifier: "RightCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "RightCell") as? RightCell
            }
            cell.txtMsgView.text = items[indexPath.row].message
            cell.lblTime.text = items[indexPath.row].creationAt?.convertDateToStringg()
            return cell
        }else{
            var cell: LeftCell! = tableView.dequeueReusableCell(withIdentifier: "LeftCell") as? LeftCell
            if cell == nil {
                tableView.register(UINib(nibName: "LeftCell", bundle: nil), forCellReuseIdentifier: "LeftCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "LeftCell") as? LeftCell
            }
            cell.txtMsgView.text = items[indexPath.row].message
            cell.lbltime.text = items[indexPath.row].creationAt?.convertDateToStringg()
            cell.imgProfile.kf.setImage(with: URL(string: items[indexPath.row].image ?? ""), placeholder:UIImage(named: "logo"))
            return cell
        }

    }
    
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSend(_ sender: Any) {
        let trimmedString = txtSendMsg.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString != ""{
            self.performSendMessage { message, errorModal in
                
            }
            txtSendMsg.text = ""
            self.msgViewHeight.constant = 40
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        NavigationManager.shared.isEnabledBottomMenu = false
        self.performGetMessage(lastId: "") { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
