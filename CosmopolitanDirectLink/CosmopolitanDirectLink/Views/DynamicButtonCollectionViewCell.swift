//
//  DynamicButtonCollectionViewCell.swift
//  IOSChatBot
//
//  Created by Raghuram on 03/08/22.
//

import UIKit

class DynamicButtonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DynamicButtonCollectionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "DynamicButtonCollectionViewCell", bundle: nil)
    }
    
    let apiManager = ApiManager()
    var url = ""
    let screenSize: CGRect = UIScreen.main.bounds

    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var buttonStackView: UIStackView!
    //MARK: - Actions and Selectors
    @IBAction func linkPressed(sender:UIButton){
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    @IBAction func buttonPressed(sender:UIButton){
        apiManager.post(endpoint:  "/conversations/\(ApiManager.cid)/activities", token: ApiManager.tokenVal!, body: ["type": "message", "from": [
            "id": HomeViewController.uuid,
            "name": HomeViewController.userName
        ], "text": sender.currentTitle! as String])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.frame.size.width = screenSize.width - 32
        mainView.layer.borderWidth = 1
    }
    
    //MARK: View Making methods
    func makeButtonWithText(text:String, type:String) -> UIButton {
        let myButton = UIButton(type: UIButton.ButtonType.system)
        myButton.layer.borderWidth = 0.5
        myButton.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 30)
        myButton.setTitle(text, for: .normal)
        myButton.setTitleColor(UIColor(red: 121.0/255.0, green: 40.0/255.0, blue: 140.0/255.0, alpha: 1.0), for: .normal)
        myButton.addTarget(self,action: type == "openUrl" ? #selector(linkPressed) : #selector(buttonPressed),for: .touchUpInside
        )
        return myButton
    }
    
    func configure(with data: Attachments) {
        buttonStackView.removeAllArrangedSubviews()
        textField.text = data.content?.text
        data.content?.buttons.map({item in
            for (index, itemVal)  in item.enumerated() {
                addButton(item: itemVal, index: index,  count: (data.content?.buttons!.count)!)
            }
        })
    }
    
    func addButton(item:Buttons, index: Int, count: Int){
        if buttonStackView.subviews.capacity < count {
            buttonStackView.addArrangedSubview(makeButtonWithText(text: item.title!, type: item.type!))
        }
        if item.type == "openUrl" {
            if let urlVal = item.value{
                url = urlVal
            }
        }
    }

}
