//
//  AlternativeViewController.swift
//  IOSChatBot
//
//  Created by Raghuram on 16/06/22.
//

import UIKit


protocol ChatViewControllerDelegate:class {
    func receive(_ controller: ChatViewController)
    func insertNewMessage(_ message: Message)
    func webSocketCall(_ url: String)
    func webSocketCallAgain()
}

class ChatViewController: UIViewController {
    //MARK: - objects && variable declaration

    private let webSocketDelegate = SocketManager()
    private var  webSocketTask:URLSessionWebSocketTask?
    private lazy var session: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration,
                              delegate: webSocketDelegate, delegateQueue: OperationQueue())
        }()
    
    var senderNameValue: String?
    var uuid: String?
    
    let screenWidth = UIScreen.main.bounds
    
    let network = Netwotking()
    let apiManager = ApiManager()
    
    let alert = UIAlertController(title: "No internet detected", message: "Please connect to internet", preferredStyle: .alert)
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    //MARK: - senderPressed
    @IBAction func sentButtonPressed(_ sender: UIButton) {
        if(messageTextField.text != ""){
            apiManager.post(endpoint:  "/conversations/\(ApiManager.cid)/activities", token: ApiManager.tokenVal!, body: ["type": "message", "from": [
                "id": uuid!,
                "name": senderNameValue!
            ], "text": messageTextField.text!]);
        }
        messageTextField.text = ""
        tableView.reloadData()
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Rose, Resident Mischief-Maker?"
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        let podBundle = Bundle(for:ChatViewController.self)
            if let bundleURL = podBundle.url(forResource: "CosDirectLink", withExtension: "bundle") {
                if let bundle = Bundle(url: bundleURL) {
                    let cellNib = UINib(nibName: MessageCell.identifier, bundle: bundle)
                    tableView.register(cellNib, forCellReuseIdentifier: MessageCell.identifier)
                } else {
                    assertionFailure("Could not load the bundle")
                }
                if let bundle = Bundle(url: bundleURL) {
                    let cellNib = UINib(nibName: CarouselCellTableViewCell.identifier, bundle: bundle)
                    tableView.register(cellNib, forCellReuseIdentifier: CarouselCellTableViewCell.identifier)
                } else {
                    assertionFailure("Could not load the bundle")
                }
                if let bundle = Bundle(url: bundleURL) {
                    let cellNib = UINib(nibName: QuickReplyTableViewCell.identifier, bundle: bundle)
                    tableView.register(cellNib, forCellReuseIdentifier: QuickReplyTableViewCell.identifier)
                } else {
                    assertionFailure("Could not load the bundle")
                }
            } else {
                assertionFailure("Could not create a path to the bundle")
            }
        
//        tableView.register(UINib(nibName: K.tableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: K.tableViewCellIdentifier)
//        tableView.register(CarouselCellTableViewCell.nib(), forCellReuseIdentifier: CarouselCellTableViewCell.identifier)
//        tableView.register(QuickReplyTableViewCell.nib(), forCellReuseIdentifier: QuickReplyTableViewCell.identifier)
        view.addSubview(tableView)
        
        //MARK: - IsNetworkAvailable
        if UserDefaults.standard.string(forKey: "token") == nil{
            if network.isNetworkAvailable(){
                apiManager.post(endpoint: "/tokens/generate") { (token) in
                    self.apiManager.post(endpoint: "/conversations", token: token){ (streamURL) in
                        self.webSocketCall(streamURL)
                    }
                }
            } else{
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            if network.isNetworkAvailable(){
                self.webSocketCall(ApiManager.streamUrl!)
                self.receive(self)
            } else{
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - CurrentSender
    func currentSender() -> SenderType {
        return Sender(senderId: uuid!, displayName: senderNameValue!)
    }
    
    //MARK: - IsFromCurrentSender
    func isFromCurrentSender(message: Message) -> Bool {
        return message.sender.senderId == currentSender().senderId
    }
}

//MARK: - UITableViewDataSource
extension  ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeViewController.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = HomeViewController.messages[indexPath.row]
        switch message.kind {
        case .text:
            let cellA = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
            cellA.configure(with: message)
            cellA.senderMessageBuble.frame.size = CGSize(width: screenWidth.width/2, height: 40)
            if(!isFromCurrentSender(message: message )){
                cellA.senderMessageBuble.backgroundColor = .brown
                cellA.senderMessageLabel.backgroundColor = .brown
                cellA.receiverLabel?.text = ""
                cellA.senderLabel?.text = message.sender.displayName
                cellA.receiverMessageLabel.text = ""
                cellA.receiverMessageBuble.backgroundColor = .none
            }else{
                cellA.receiverMessageBuble.backgroundColor = .gray
                cellA.senderMessageLabel.text = ""
                cellA.senderMessageBuble.backgroundColor = .none
                cellA.senderMessageLabel.backgroundColor = .none
                cellA.senderLabel?.text = ""
                cellA.receiverLabel?.text = message.sender.displayName
            }
            return cellA
        case .custom( _): break
        case .attachments( _):
            guard let cellB = tableView.dequeueReusableCell(withIdentifier: CarouselCellTableViewCell.identifier, for: indexPath) as? CarouselCellTableViewCell else{
                fatalError()
            }
            cellB.configure(with: message)
            return cellB
        case .actions( _):
            guard let cellB = tableView.dequeueReusableCell(withIdentifier: QuickReplyTableViewCell.identifier, for: indexPath) as? QuickReplyTableViewCell else{
                fatalError()
            }
            cellB.delegate = self
            cellB.configure(with: message)
            return cellB
            
        }
        return UITableViewCell()
    }
}

extension ChatViewController: ChatViewControllerDelegate{
    func webSocketCallAgain() {
        webSocketTask?.resume()
        receive(self)
    }
    func webSocketCall(_ url: String){
        webSocketTask = session.webSocketTask(with: URL(string: url)!)
        webSocketTask?.resume()
        receive(self)
    }
    
    //MARK: - InsertMessage
    func insertNewMessage(_ message: Message){
        HomeViewController.messages.append(message)
        tableView.reloadData()
    }
    
    //MARK: Receive
    func receive(_ controller: ChatViewController) {
        let arrayOfIds = HomeViewController.messages.map{$0.messageId}
        let workItem = DispatchWorkItem{ [weak self] in
            self?.webSocketTask?.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let message):
                    switch message {
                    case .string(let strMessgae):
                        let jsonData = strMessgae.data(using: .utf8)!
                        do {
                            let messagesReceived:ReceiveMessage = try JSONDecoder().decode(ReceiveMessage.self, from: jsonData)
                            if let destructuredMessages = messagesReceived.activities{
                                DispatchQueue.main.async {
                                    if(destructuredMessages[0].text != nil){
                                        if ((arrayOfIds.contains(destructuredMessages[0].id!)) == false) {
                                            self?.insertNewMessage(Message(sender: Sender(senderId: (destructuredMessages[0].from?.id)!, displayName: (destructuredMessages[0].from?.name)!), messageId: destructuredMessages[0].id!, kind:MessageKind.text(destructuredMessages[0].text!), sentDate: Date(), sectionCount: 1))
                                        }
                                    }
                                    if((destructuredMessages[0].suggestedActions) != nil){
                                        if ((arrayOfIds.contains(destructuredMessages[0].id!)) == false) {
                                            if let actions = destructuredMessages[0].suggestedActions?.actions{
                                                HomeViewController.actions.append(contentsOf: [actions])
                                                self?.insertNewMessage(Message(sender: Sender(senderId: (destructuredMessages[0].from?.id)!, displayName: (destructuredMessages[0].from?.name)!), messageId: destructuredMessages[0].id!, kind: MessageKind.actions(actions), sentDate:Date(), sectionCount: destructuredMessages[0].attachments?.count))
                                            }
                                        }
                                    }
                                    if (destructuredMessages[0].attachments != nil) && destructuredMessages[0].attachments!.count > 0 {
                                        if ((arrayOfIds.contains(destructuredMessages[0].id!)) == false) {
                                            if let data = destructuredMessages[0].attachments{
                                                HomeViewController.attachments.append(contentsOf: [data])
                                                self?.insertNewMessage(Message(sender: Sender(senderId: (destructuredMessages[0].from?.id)!, displayName: (destructuredMessages[0].from?.name)!), messageId: destructuredMessages[0].id!, kind: MessageKind.attachments(data), sentDate:Date(), sectionCount: destructuredMessages[0].attachments?.count))
                                            }
                                        }
                                    }
                                    let indexPath = IndexPath(row: ((HomeViewController.messages.count)) - 1, section: 0)
                                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        } catch {
                            print("Error In catch",error)
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    print("Error Receiving \(error)")
                    UserDefaults.standard.set(nil, forKey: "token")
                    UserDefaults.standard.messagesData = []
                    UserDefaults.standard.actionsData = []
                    UserDefaults.standard.attachmentsData = []
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                // Creates the Recurrsion
                self?.receive(self!)
            })
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: workItem)
    }
}
