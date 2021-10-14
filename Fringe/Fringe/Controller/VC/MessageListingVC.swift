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

class MessageListingVC : BaseVC, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblBottam: NSLayoutConstraint!
    @IBOutlet weak var bottamConstraint: NSLayoutConstraint!
    @IBOutlet weak var msgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendImg: UIImageView!
    @IBOutlet weak var btnSend: LoadingButton!
    @IBOutlet weak var txtSendMsg: UITextView!
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var sendView: UIView!
    
    var ownImage = String()
    var otherUserImg = String()
    var senderFirstName = String()
    var senderLastName = String()
    var otherUserName = String()
    var roomID = String()
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
        txtSendMsg.leftSpace()
        
        if senderFirstName == "" {
            lblName.text = otherUserName
        } else {
            lblName.text = "\(senderFirstName) " + "\(senderLastName)"

        }
        self.txtSendMsg.delegate = self
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessageListingVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses = [MessageListingVC.self]
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tblMessage.addGestureRecognizer(tap)
    }
    
    //------------------------------------------------------
    
    //MARK: Configure Socket
    
    func configureSocket() {
        
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
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.scrollToEnd()
            })
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Socket Method(s)
    
    func SendStopMessage(isSend:Bool){
        if isSend{
            btnSend.loadIndicator(true)
            sendImg.image = nil
            btnSend.setImage(nil, for: .normal)
        }else{
            sendImg.image = UIImage(named: FGImageName.send)
            btnSend.loadIndicator(false)
        }
    }
    
    func connectSocketOn(){
        SocketManger.shared.onConnect {
            SocketManger.shared.socket.emit("ConncetedChat",  self.items.first?.roomID ?? String())
            print("connected")
            
        }
    }
    
    func newMessageSocketOn(){
        SocketManger.shared.handleNewMessage { (message) in
            print(message)
            self.items.append(AddEditMessageModal(id: message["id"] as? String, userID:  message["user_id"] as? String, message:  message["message"] as? String, roomID:  message["room_id"] as? String, seen:  message["seen"] as? String, creationAt:  message["creation_at"] as? String, name:  message["name"] as? String, image:  message["image"] as? String))
            self.tblMessage.reloadData()
            self.scrollToEnd()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Scroll table view to last item
    
    func scrollToEnd(){
        if items.count > 0 {
            tblMessage.scrollToRow(at: IndexPath(item:items.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Service call
    
    @objc func performGetMessage(lastId: String, completion: ((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
        ]
        
       
        let parameter: [String: Any] = [
            Request.Parameter.roomID: roomID,
            Request.Parameter.lastID: "",
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
            
            self.SendStopMessage(isSend: false)
            
            SocketManger.shared.socket.emit("newMessage",self.roomID,["id":response.data?.id,"user_id":response.data?.userID,"message":response.data?.message,"room_id":response.data?.roomID,"seen":response.data?.seen,"creation_at":response.data?.creationAt,"name":response.data?.name,"image":response.data?.image])
            
            self.items.append(AddEditMessageModal(id: response.data?.id, userID: response.data?.userID, message: response.data?.message, roomID: response.data?.roomID, seen: response.data?.seen, creationAt: response.data?.creationAt, name: response.data?.name, image: response.data?.image))
            
            self.tblMessage.reloadData()
            self.scrollToEnd()
            
            completion?(response.data, nil)
                        
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
            let data = items[indexPath.row]
            cell.setup(chatData: data)
            cell.imgProfile.setRounded()
            cell.imgProfile.kf.setImage(with: URL(string: ownImage), placeholder:UIImage(named: FGImageName.iconPlaceHolder))
            return cell
            
        }else{
            
            var cell: LeftCell! = tableView.dequeueReusableCell(withIdentifier: "LeftCell") as? LeftCell
            if cell == nil {
                tableView.register(UINib(nibName: "LeftCell", bundle: nil), forCellReuseIdentifier: "LeftCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "LeftCell") as? LeftCell
            }
            let data = items[indexPath.row]
            cell.setup(chatData: data)
            cell.imgProfile.setRounded()
            cell.imgProfile.kf.setImage(with: URL(string: otherUserImg), placeholder:UIImage(named: FGImageName.iconPlaceHolder))
            return cell
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UITextview delegate
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height <= 40 {
            msgViewHeight.constant = 40
        }else if textView.contentSize.height <= 100 && textView.contentSize.height > 40 {
            msgViewHeight.constant = textView.contentSize.height
        }else{
            msgViewHeight.constant = 100
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        
        if PreferenceManager.shared.comesFromMessagePush == true {
            
            if PreferenceManager.shared.curretMode == "1" {
                
                NavigationManager.shared.setupLandingOnHome()
                
            }else{
                
                NavigationManager.shared.setupLandingOnHomeForHost()
            }
            
        } else {
            
            self.pop()

        }
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
        NavigationManager.shared.isEnabledBottomMenu = false
        NavigationManager.shared.isEnabledBottomMenuForHost = false
       
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // or true
        configureUI()
        configureSocket()
        self.performGetMessage(lastId: "") { (flag : Bool) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //------------------------------------------------------
}
