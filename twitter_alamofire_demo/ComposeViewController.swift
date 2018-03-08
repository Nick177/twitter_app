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

class ComposeViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var tweetBtn: UIButton!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.current!
        tweetBtn.layer.cornerRadius = 10
        let url = URL(string: user.profileImgURL!)
        profileImageView.af_setImage(withURL: url!)
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName!
        
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

}
