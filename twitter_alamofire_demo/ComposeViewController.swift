//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Nicholas Rosas on 3/6/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
//import RSKPlaceholderTextField

protocol ComposeViewControllerDelegate: class {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ComposeViewControllerDelegate?
    
    let characterLimit = 140
    
    var characterCountBarLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.current!
        let url = URL(string: user.profileImgURL!)
        profileImageView.af_setImage(withURL: url!)
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName!
        tweetTextField.delegate = self
        tweetTextField.isEditable = true
        tweetTextField.layer.borderColor = UIColor.black.cgColor
        tweetTextField.layer.borderWidth = 1.0
        tweetTextField.layer.cornerRadius = 5.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(barButtonItem, animated: true)
        
        let b = UIButton(type: UIButtonType.system)
        let color = b.titleColor(for: .normal)
        
        let btnProfile = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 30))
        btnProfile.setTitle("Tweet", for: .normal)
        btnProfile.backgroundColor = color
        btnProfile.setTitleColor(UIColor.white, for: .normal)
        btnProfile.layer.cornerRadius = 4.0
        btnProfile.layer.masksToBounds = true
        
        let tweetBarButtonItem = UIBarButtonItem(customView: btnProfile)
        tweetBarButtonItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(post)))
        
        characterCountBarLabel = UIBarButtonItem(title: "\(characterLimit)", style: .plain, target: nil, action: nil)
        
        self.navigationItem.setRightBarButtonItems([tweetBarButtonItem, characterCountBarLabel], animated: true)
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func post() {
        if tweetTextField.text != nil {
            APIManager.shared.composeTweet(with: tweetTextField.text!) { (tweet, error) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
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
        
        characterCountBarLabel.title = "\(characterLimit - newText.characters.count)"
        
        return newText.characters.count < characterLimit
    }

}
