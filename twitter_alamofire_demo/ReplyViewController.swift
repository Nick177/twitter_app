//
//  ReplyViewController.swift
//  twitter_alamofire_demo
//
//  Created by Nicholas Rosas on 3/7/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

protocol ReplyViewControllerDelegate: class {
    func did(post: Tweet)
}

class ReplyViewController: UIViewController, UITextViewDelegate {
    weak var delegate: ReplyViewControllerDelegate?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    
    var recipientScreenName: String?
    let characterLimit = 140
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.current!
        //tweetBtn.layer.cornerRadius = 10
        let url = URL(string: user.profileImgURL!)
        profileImageView.af_setImage(withURL: url!)
        screenNameLabel.text = recipientScreenName
        tweetTextField.delegate = self
        tweetTextField.isEditable = true
        tweetTextField.layer.borderColor = UIColor.black.cgColor
        tweetTextField.layer.borderWidth = 1.0
        tweetTextField.layer.cornerRadius = 5.0
        
        let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: screenNameLabel.font.pointSize)]
        let attributedString = NSMutableAttributedString(string: "Replying to ")
        attributedString.append(NSMutableAttributedString(string: screenNameLabel.text!, attributes:attrs))
        
        screenNameLabel.text = "Replying to " + screenNameLabel.text!
        screenNameLabel.attributedText = attributedString
        //characterCountLabel.text = "\(characterLimit)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        //let barButtonItem2 = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(reply))
        //let replyButtonItem = UIBarButtonItem(title: "Reply", style: .plain, target: self, action: #selector(reply))
        //replyButtonItem
        self.navigationItem.setLeftBarButton(barButtonItem, animated: true)
        //self.navigationItem.setRightBarButton(barButtonItem2, animated: true)
        
        let b = UIButton(type: UIButtonType.system)
        let color = b.titleColor(for: .normal)
        
        let btnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        btnProfile.setTitle("Reply", for: .normal)
        btnProfile.backgroundColor = color
        btnProfile.setTitleColor(UIColor.white, for: .normal)
        btnProfile.layer.cornerRadius = 4.0
        btnProfile.layer.masksToBounds = true
        
        let replyBarButtonItem = UIBarButtonItem(customView: btnProfile)
        
        self.navigationItem.setRightBarButton(replyBarButtonItem, animated: false)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func reply() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = NSString(string: tweetTextField.text!).replacingCharacters(in: range, with: text)
        
        //characterCountLabel.text = "\(characterLimit - newText.characters.count)"
        
        return newText.characters.count < characterLimit
    }
    
    

}
