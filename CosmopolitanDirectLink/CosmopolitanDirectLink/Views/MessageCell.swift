//
//  MessageCell.swift
//  IOSChatBot
//
//  Created by Raghuram on 16/06/22.
//

import UIKit

class MessageCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    //MARK: - objects && variables
    static let identifier = "MessageCell"
    static func nib() -> UINib{
        return UINib(nibName: "MessageCell", bundle: nil)
    }
    
    //MARK: - IBoutlets && actions
    @IBOutlet weak var senderMessageBuble: UIView!
    @IBOutlet weak var receiverMessageBuble: UIView!
    @IBOutlet weak var senderMessageLabel: UITextView!
    @IBOutlet weak var receiverMessageLabel: UITextView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        senderMessageLabel.isUserInteractionEnabled = true
        senderMessageLabel.isEditable = false
        senderMessageLabel.isSelectable = true
        receiverMessageBuble.layer.cornerRadius = contentView.frame.width * 0.06
        senderMessageBuble.layer.cornerRadius = contentView.frame.width * 0.06
        senderMessageLabel.delegate = self
    }
    
    
    func configure(with viewModel: Message) {
        switch viewModel.kind {
        case .text(let value):
            if viewModel.sender.senderId != HomeViewController.uuid {
                let url = senderMessageLabel.checkForUrls(text: value)
                if (url.count != 0) {
                    let url = url[0]
                    let replaced = value.replacingOccurrences(of: "http", with: "http")
                    senderMessageLabel.addHyperLinksToText(originalText:replaced, hyperLink: url.absoluteString, urlString: url)
                }else{
                    senderMessageLabel.text = value
                }
                break
            }
            else{
                receiverMessageLabel?.text = value
                break
            }
        case .attachments(_):
            break
        case .actions(_):
            break
        default:
            break
        }
        
    }
}



extension MessageCell: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("URL is: ", URL)
        return false
    }
}
