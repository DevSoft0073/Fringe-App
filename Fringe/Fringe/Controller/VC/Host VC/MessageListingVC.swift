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
    
    @IBOutlet weak var tblBottam: NSLayoutConstraint!
    @IBOutlet weak var bottamConstraint: NSLayoutConstraint!
    @IBOutlet weak var msgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendImg: UIImageView!
    @IBOutlet weak var btnSend: LoadingButton!
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
        self.txtSendMsg.delegate = self
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessageListingVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses = [MessageListingVC.self]
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tblMessage.addGestureRecognizer(tap)
        //        self.profilePic.kf.setImage(with: URL(string: items.first?.image), placeholder:UIImage(named: "logo"))
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
    
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            if UIDevice.current.iPhoneX{
                bottamConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height-view.safeAreaInsets.bottom : 0
                
            }else{
                bottamConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height : 0
            }
             //   bottomConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height : 0
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.scrollToEnd()
            })
        }
    }
    
    func SendStopMessage(isSend:Bool){
        if isSend{
            btnSend.loadIndicator(true)
            sendImg.image = nil
            btnSend.setImage(nil, for: .normal)
        }else{
            sendImg.image = #imageLiteral(resourceName: "right_icon")
        //    sendBtn.setImage(#imageLiteral(resourceName: "send"), for: .normal)
            btnSend.loadIndicator(false)
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
            print(message)
            //            self.items.append(AddEditMessageModal(id: message[""], userID: <#T##String?#>, message: <#T##String?#>, roomID: <#T##String?#>, seen: <#T##String?#>, creationAt: <#T##String?#>, name: <#T##String?#>, image: <#T##String?#>))
            self.tblMessage.reloadData()
            self.scrollToEnd()
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
            self.scrollToEnd()
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
        self.SendStopMessage(isSend: true)
        var parameter: [String: Any] = [:]
        parameter = [
            Request.Parameter.roomID: roomID,
            Request.Parameter.message: txtSendMsg.text ?? String(),
        ]
        
        print("chatParam",parameter)
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.sendMsg, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<AddEditMessageModal>.self) { (response: ResponseModal<AddEditMessageModal>) in
            print(response)
            
            self.SendStopMessage(isSend: false)
            
            completion?(response.data, nil)
//            SocketManger.shared.socket.emit("newMessage",self.roomID,response.data as! SocketData)
            self.items.append(AddEditMessageModal(id: response.data?.id, userID: response.data?.userID, message: response.data?.message, roomID: response.data?.roomID, seen: response.data?.seen, creationAt: response.data?.creationAt, name: response.data?.name, image: response.data?.image))
            self.tblMessage.reloadData()
            self.scrollToEnd()
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
    
    @IBAction func btnSend(_ sender: UIButton) {
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

extension MessageListingVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 40 {
            msgViewHeight.constant = 40
        }else if textView.contentSize.height <= 100 && textView.contentSize.height > 40 {
            msgViewHeight.constant = textView.contentSize.height
        }else{
            msgViewHeight.constant = 100
        }
    }
}
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height >= 2436
    }
}
