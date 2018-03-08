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

    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var tweetBtn: UIButton!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ComposeViewControllerDelegate?
    
    let characterLimit = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.current!
        tweetBtn.layer.cornerRadius = 10
        let url = URL(string: user.profileImgURL!)
        profileImageView.af_setImage(withURL: url!)
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName!
        tweetTextField.delegate = self
        tweetTextField.isEditable = true
        tweetTextField.layer.borderColor = UIColor.black.cgColor
        tweetTextField.layer.borderWidth = 1.0
        tweetTextField.layer.cornerRadius = 5.0
        
        characterCountLabel.text = "\(characterLimit)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(barButtonItem, animated: true)
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPost(_ sender: Any) {
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = NSString(string: tweetTextField.text!).replacingCharacters(in: range, with: text)
        
        characterCountLabel.text = "\(characterLimit - newText.characters.count)"
        
        return newText.characters.count < characterLimit
    }

}
