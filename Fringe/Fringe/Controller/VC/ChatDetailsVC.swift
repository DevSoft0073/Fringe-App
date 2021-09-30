//
//  ChatDetailsVC.swift
//  Fringe
//
//  Created by MyMac on 9/21/21.
//
import UIKit
import MapKit
import SDWebImage
import MessageKit
import Kingfisher
import Alamofire
import InputBarAccessoryView
import IQKeyboardManagerSwift

class ChatDetailsVC : ChatViewController, MessagesDisplayDelegate, MessagesLayoutDelegate, InputBarAccessoryViewDelegate{
    
    @IBOutlet weak var topView: UIView!
    
    var roomId: String = String()
    var studioId: String = String()
    var role: String = String()
    var senderId: String = String()
    var receiverId: String = String()
    var lastId: String = String()
    var debouncer: FGDebouncer?
    var userID: String = String()
    
    var messageGroup: MessageGroupModal? = nil {
        didSet {
            roomId = messageGroup?.roomID ?? String()
        }
    }
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
    
    //MARK: Custom
    
    func updateUI() {
        
        self.messagesCollectionView.reloadData()
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = FGColor.appGreen
        messageInputBar.sendButton.setTitleColor(FGColor.appGreen, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            FGColor.appGreen.withAlphaComponent(0.3), for: .highlighted)
    }
    
    @objc func performGetMessage(isShowLoader: Bool, lastId: String, completion: ((_ flag: Bool) -> Void)?) {
        
        let headers:HTTPHeaders = [
           "content-type": "application/json",
            "Token": PreferenceManager.shared.authToken ?? String(),
          ]
        
        let parameter: [String: Any] = [
            Request.Parameter.roomID: roomId,
            Request.Parameter.lastID: lastId,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.getAllMessgaes, parameter: parameter, headers: headers, showLoader: false, decodingType: ResponseModal<[AddEditMessageModal]>.self) { (response: ResponseModal<[AddEditMessageModal]>) in
            
            var mockMessages: [MockMessage] = []
            response.data?.forEach({ (arg0: AddEditMessageModal) in
                var message = arg0
                let currentSender = self.currentUser?.toMockUser() ?? annonymousUser
                if message.id == currentSender.senderId {
                    message.name = currentSender.displayName
                    //                    self.navigationItem.title = self.messageGroup?.name
                } else {
                    message.name = self.messageGroup?.firstName
                }
                if self.messageList.contains(where: { (exist: MockMessage) in
                    return exist.messageId == message.id
                }) == false {
                    mockMessages.append(message.toMockMessage())
                }
            })
            
            self.lastId = response.data?.last?.id ?? String()
            self.messageList.append(contentsOf: mockMessages)
//            self.imgString = response.data?.first?.image ?? String()
            
            self.messageList.sort { (arg0: MockMessage, arg1: MockMessage) in
                return arg0.sentDate.compare(arg1.sentDate) == .orderedAscending
            }
            
            self.updateUI()
            
            completion?(true)
            
        } failureBlock: { (errorModal: ErrorModal) in
            
            completion?(false)
        }
    }
    
    func performSendMessage(_ data: [Any], completion: ((_ message: AddEditMessageModal?, _ errorModal: ErrorModal?) -> Void)?) {
        
        for component in data {
            
            if let inputMessage = component as? String {
                
                let headers:HTTPHeaders = [
                   "content-type": "application/json",
                    "Token": PreferenceManager.shared.authToken ?? String(),
                  ]
                
                var parameter: [String: Any] = [:]
                
                print("chatParam",parameter)
                
                RequestManager.shared.requestPOST(requestMethod: Request.Method.sendMsg, parameter: parameter, headers: headers, showLoader: false, decodingType: BaseResponseModal.self) { (response: BaseResponseModal) in
                    
                    completion?(response.data?.first, nil)
                    
                    delay {
                        self.performClearBadgeCount { (flag : Bool) in
                        }
                    }
                    self.lblNoRecordsFound.isHidden = true
                    
                } failureBlock: { (errorModal: ErrorModal) in
                    
                    completion?(errorModal)
                }
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: MessagesDisplayDelegate
    
    // MARK: Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .white
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
    
//    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
//        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
//    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? FGColor.appGreen : FGColor.appBackground
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .pointedEdge)
        
        /*let custom = MessageStyle.custom { (messageView: MessageContainerView) in
         if self.isFromCurrentSender(message: message) {
         messageView.image = SCImageName.messageSentText
         } else {
         messageView.image = SCImageName.messageReceivedText
         }
         messageView.backgroundColor = UIColor.clear
         }
         return custom*/
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        /*let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
         avatarView.set(avatar: avatar)*/
        
//        if isFromCurrentSender(message: message) {
//            if PreferenceManager.shared.curretMode == "1"{
//                if let imgStringUrl = self.currentUser?.image, let imgUrl = URL(string: imgStringUrl) {
//                    avatarView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
//                    avatarView.sd_addActivityIndicator()
//                    avatarView.sd_setImage(with: imgUrl, completed: nil)
//
//                } else {
//
//                        avatarView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
//                        avatarView.sd_addActivityIndicator()
//                        avatarView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: ""),completed: nil)
//
//                }
//            }else{
//                if let imgStringUrl = self.currentStudioUser?.profileImage, let imgUrl = URL(string: imgStringUrl) {
//                    avatarView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
//                    avatarView.sd_addActivityIndicator()
//                    avatarView.sd_setImage(with: imgUrl, completed: nil)
//                } else {
//
//                    avatarView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
//                    avatarView.sd_addActivityIndicator()
//                    avatarView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: ""),completed: nil)
//
//                }
//            }
//
//        } else {
//
//            if let imgStringUrl = self.messageGroup?.image, let imgUrl = URL(string: imgStringUrl) {
//                avatarView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
//                avatarView.sd_addActivityIndicator()
//                avatarView.sd_setImage(with: imgUrl, completed: nil)
//
//            } else {
//                let imgUrl = URL(string: imgStringgggg)
//                avatarView.sd_setIndicatorStyle(UIActivityIndicatorView.Style.medium)
//                avatarView.sd_addActivityIndicator()
//                avatarView.sd_setImage(with: imgUrl, completed: nil)
//
//            }
//        }
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if case MessageKind.photo(let media) = message.kind, let imageURL = media.url {
            //            imageView.sd_setImage(with: imageURL), placeholderImage: UIImage(named: FGImageName.imgPlaceHolder))
            //            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: ""), options: SDWebImageOptions.continueInBackground, completed: nil)
            imageView.kf.setImage(with: imageURL)
        } else {
            imageView.kf.cancelDownloadTask()
        }
    }
    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "ic_map_marker")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
    
    // MARK: - Audio Messages
    
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .white
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if messageList.count > 0 && indexPath.section > 0 {
            let previousDate = messageList[indexPath.section - 1].sentDate
            let order = Calendar.current.compare(message.sentDate, to: previousDate, toGranularity: .day)
            switch order {
            case .orderedDescending, .orderedAscending:
                return 18
            case .orderedSame:
                return 0
            }
        } else {
            return 0
        }
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    
    //------------------------------------------------------
    
    //MARK: InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
//        let roomId: String = self.roomId
//        let isTypeing: Int = 1
//        SocketManger.shared.socket.emit(SocketMessageType.startTyping.rawValue, roomId, isTypeing)
//        debouncer?.call()
    }
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        
        // Resign first responder for iPad split view
        //inputBar.inputTextView.resignFirstResponder()
        
        /*DispatchQueue.global(qos: .default).async {
         // fake send request task
         sleep(1)
         DispatchQueue.main.async { [weak self] in
         inputBar.sendButton.stopAnimating()
         inputBar.inputTextView.placeholder = "Aa"
         self?.insertMessages(components)
         self?.messagesCollectionView.scrollToLastItem(animated: true)
         }
         }*/
        
//        let roomId: String = self.roomId
//        let isTypeing: Int = 0
//        SocketManger.shared.socket.emit(SocketMessageType.startTyping.rawValue, roomId, isTypeing)
//
//        performSendMessage(components) { message, error in
//
//            DispatchQueue.main.async { [weak self] in
//
//                inputBar.sendButton.stopAnimating()
////                inputBar.inputTextView.placeholder = "Aa"
//                if let message = message?.toMockMessage() {
//                    self?.insertMessage(message)
//                }
//                self?.messagesCollectionView.scrollToLastItem(animated: true)
//                print("roomIDChat",roomId)
//                //send message to socket as well.
//                let socketData: [String: Any] = (try? message?.jsonString()?.toDictionary() as? [String: Any]) ?? [:]
//                SocketManger.shared.socket.emit(SocketMessageType.newMessage.rawValue, roomId, socketData)
//            }
//        }
    }
    
    /*private func insertMessages(_ data: [Any]) {
     for component in data {
     let user = SampleData.shared.currentSender
     if let str = component as? String {
     let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
     insertMessage(message)
     } else if let img = component as? UIImage {
     let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
     insertMessage(message)
     }
     }
     }*/
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = FGColor.appWhite
        messagesCollectionView.backgroundColor = UIColor.clear
        
//        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        
        configureMessageInputBar()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topView.addSubview(messagesCollectionView)
    }
    
    //------------------------------------------------------
}
