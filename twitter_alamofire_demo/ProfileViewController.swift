//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Nicholas Rosas on 3/2/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

enum TweetConstants {
    static let following_label = "FOLLOWING"
    static let followers_label = "FOLLOWERS"
    static let space = " "
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var backgroundImgView: UIImageView!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.current
        
        nameLabel.text = user?.name
        screenNameLabel.text = user?.screenName
        descriptionLabel.text = user?.description
        
        let profileURL = URL(string: user.profileImgURL!)
        profileImgView.af_setImage(withURL: profileURL!)
        if user.profileBackgroundImgURL != nil { let backgroundURL = URL(string: user.profileBackgroundImgURL!)
        backgroundImgView.af_setImage(withURL: backgroundURL!)
        }
        print(user.followers_cnt!)
        print(user.following_cnt!)
        if user.following_cnt != nil {
        let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: followingLabel.font.pointSize)]
        let attributedString = NSMutableAttributedString(string: String(describing: user.following_cnt!) + TweetConstants.space, attributes:attrs)
        attributedString.append(NSMutableAttributedString(string: TweetConstants.following_label))
        
        followingLabel.text = String(describing: user.following_cnt!) + TweetConstants.space
        followingLabel.text = followingLabel.text! + TweetConstants.following_label
        followingLabel.attributedText = attributedString
        }
        
        if user.followers_cnt != nil {
            let followersAttrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: followersLabel.font.pointSize)]
            let followersAttributedString = NSMutableAttributedString(string: String(describing: user.followers_cnt!) + TweetConstants.space, attributes:followersAttrs)
            followersAttributedString.append(NSMutableAttributedString(string: TweetConstants.followers_label))
            
            followersLabel.text = String(describing: user.followers_cnt!) + TweetConstants.space
            followersLabel.text = followersLabel.text! + TweetConstants.followers_label
            followersLabel.attributedText = followersAttributedString
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
