//
//  extensions.swift
//  IOSChatBot
//
//  Created by Raghuram on 25/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait..", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame:  CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        alert.view.addSubview(indicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func dismissLoader(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}
extension UserDefaults {
    var messagesData: [Message] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "messages") else { return [] }
            return (try? PropertyListDecoder().decode([Message].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "messages")
        }
    }
    var attachmentsData: [[Attachments]] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "attachments") else { return [] }
            return (try? PropertyListDecoder().decode([[Attachments]].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "attachments")
        }
    }
    
    var actionsData: [[Actions]] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "actions") else { return [] }
            return (try? PropertyListDecoder().decode([[Actions]].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "actions")
        }
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T: Equatable {
        return !self.filter({$0 as? T == obj}).isEmpty
    }
}

public extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UITextView {
    func checkForUrls(text: String) -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
            return matches.compactMap({$0.url})
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return []
    }
    func addHyperLinksToText(originalText: String, hyperLink: String, urlString: URL) {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.setAttributes([.link:urlString], range: linkRange)
        attributedOriginalText.addAttribute(.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: fullRange)
        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        self.attributedText = attributedOriginalText
    }
}

extension NSAttributedString {
    static func makeHyperlink(for path: String, in string: String, as subString: String) -> NSAttributedString{
        let nsString = NSString(string: string)
        let substringRange = nsString.range(of: subString)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([.link:path], range: substringRange)
        return attributedString
    }
}
