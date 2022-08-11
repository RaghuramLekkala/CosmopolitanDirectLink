//
//  LandingScreen.swift
//  IOSChatBot
//
//  Created by Raghuram on 28/07/22.
//

import UIKit

class LandingScreen: UIViewController{
    
    //MARK: - variables && objects
    let apiManager = ApiManager()
    var tokenValue:String? = nil
    var userName = ""
    var uuid = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = UserDefaults.standard.string(forKey: "token"){
            tokenValue = token
        }
        if let streamUrlVal = UserDefaults.standard.string(forKey: "streamUrl"){
            ApiManager.streamUrl = streamUrlVal
        }
        if let cidVal = UserDefaults.standard.string(forKey: "cid"){
            ApiManager.cid = cidVal
        }
        HomeViewController.messages = UserDefaults.standard.messagesData
        HomeViewController.attachments = UserDefaults.standard.attachmentsData
        HomeViewController.actions = UserDefaults.standard.actionsData
        
        if tokenValue != nil {
            apiManager.post(endpoint: "/tokens/refresh", token: tokenValue!) {
                DispatchQueue.main.async {
                    if let
                        uuidValue = UserDefaults.standard.string(forKey: "UUID"){
                        self.uuid = uuidValue
                        HomeViewController.uuid = uuidValue
                    }
                    if let senderNameValue = UserDefaults.standard.string(forKey: "SENDERNAME"){
                        self.userName = senderNameValue
                        HomeViewController.userName = senderNameValue
                    }
                    self.performSegue(withIdentifier: K.chatViewSegue, sender: self)
                }
            }
        }else{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: K.homeSegue, sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Preparing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.chatViewSegue{
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.senderNameValue = userName
            destinationVC.uuid = uuid
        }
    }
}
