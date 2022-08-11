//
//  QuickReplyCollectionViewCell.swift
//  IOSChatBot
//
//  Created by Raghuram on 21/06/22.
//

import UIKit

class QuickReplyCollectionViewCell: UICollectionViewCell {
    //MARK: - variables && objects
    static let identifier = "QuickReplyCollectionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "QuickReplyCollectionViewCell", bundle: nil)
    }
    
    weak var delegate: ChatViewControllerDelegate?
    
    let apiManager = ApiManager()
    let viewController = ChatViewController()
    //MARK: - IBOutlet && IBAction
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        apiManager.post(endpoint:  "/conversations/\(ApiManager.cid)/activities", token: ApiManager.tokenVal!, body: ["type": "message", "from": [
            "id": HomeViewController.uuid,
            "name": HomeViewController.userName
        ], "text": sender.currentTitle! as String])
       
    }
    @IBOutlet weak var actionButton: UIButton!
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.layer.borderWidth=2
        actionButton.layer.cornerRadius=6
        actionButton.layer.borderColor = CGColor(red: 121.0/255.0, green: 40.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        delegate?.receive(viewController)
    }
    
    func configure(with actionData: Actions) {
        actionButton.setTitle(actionData.title, for: .normal)
    }

}
