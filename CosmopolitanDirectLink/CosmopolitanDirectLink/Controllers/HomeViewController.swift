//
//  ViewController.swift
//  IOSChatBot
//
//  Created by Raghuram on 24/05/22.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - objects && variable declaration
    static var messages:[Message] = []
    static var attachments: [[Attachments]] = []
    static var actions: [[Actions]] = []
    static var uuid = UUID().uuidString
    static var userName = ""
    
    let network = Netwotking()
    
    let alert = UIAlertController(title: "Name is required", message: "Please enter a valid name", preferredStyle: .alert)
    let networkAlert = UIAlertController(title: "No internet detected", message: "Please connect to internet", preferredStyle: .alert)
    
    //MARK: - Outlets && Actions
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let name = nameTextField?.text{
            if isValidInput(Input: name){
                HomeViewController.userName = nameTextField.text!
                self.performSegue(withIdentifier: K.homeToChatViewSegue, sender: self)
            }else{
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    //MARK: - ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    //MARK: - Name validation
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\w{3,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }

    //MARK: - Preparing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.homeToChatViewSegue{
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.senderNameValue = nameTextField.text
            destinationVC.uuid = HomeViewController.uuid
        }
    }
}
