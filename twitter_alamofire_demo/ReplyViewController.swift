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
    
    var tweet: Tweet!
    let characterLimit = 140
    var characterCountLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.current!
        let url = URL(string: user.profileImgURL!)
        profileImageView.af_setImage(withURL: url!)
        tweetTextField.delegate = self
        tweetTextField.isEditable = true
        tweetTextField.layer.borderColor = UIColor.black.cgColor
        tweetTextField.layer.borderWidth = 1.0
        tweetTextField.layer.cornerRadius = 5.0
        
        screenNameLabel.text = tweet.user.screenName
        
        let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: screenNameLabel.font.pointSize)]
        let attributedString = NSMutableAttributedString(string: "Replying to ")
        attributedString.append(NSMutableAttributedString(string: screenNameLabel.text!, attributes:attrs))
        
        screenNameLabel.text = "Replying to " + screenNameLabel.text!
        screenNameLabel.attributedText = attributedString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(barButtonItem, animated: true)
        
        let b = UIButton(type: UIButtonType.system)
        let color = b.titleColor(for: .normal)
        
        let btnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 30))
        btnProfile.setTitle("Reply", for: .normal)
        btnProfile.backgroundColor = color
        btnProfile.setTitleColor(UIColor.white, for: .normal)
        btnProfile.layer.cornerRadius = 4.0
        btnProfile.layer.masksToBounds = true
        
        let replyBarButtonItem = UIBarButtonItem(customView: btnProfile)
        replyBarButtonItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reply)))
        
        characterCountLabel = UIBarButtonItem(title: "\(characterLimit)", style: .plain, target: nil, action: nil)
        
        self.navigationItem.setRightBarButtonItems([replyBarButtonItem, characterCountLabel], animated: true)
        //self.navigationItem.setRightBarButton(replyBarButtonItem, animated: false)
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func reply() {
        if tweetTextField.text != nil {
            let text = tweetTextField.text + " " + tweet.user.screenName!
            APIManager.shared.composeReply(with: text, status_id: tweet.id) { (tweet, error) in
                if let error = error {
                    print("Error replying to Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Reply Tweet Success!")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = NSString(string: tweetTextField.text!).replacingCharacters(in: range, with: text)
        
        characterCountLabel.title = "\(characterLimit - newText.characters.count)"
        
        return newText.characters.count < characterLimit
    }
    
    

}
