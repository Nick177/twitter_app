//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTimeStampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var tweet: Tweet! {
        didSet {
            refreshData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func didTapRetweet(_ sender: Any) {
        if tweet.retweeted {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweet tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweet the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            tweet.retweeted = true
            tweet.retweetCount += 1
            let button = sender as! UIButton
            button.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
                APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweet tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweet the following Tweet: \n\(tweet.text)")
                }
            }
        }
        
        refreshData()
    }
    @IBAction func didTapFavorite(_ sender: Any) {
        if tweet.favorited != nil {
            if tweet.favorited! {
                tweet.favorited! = false
                tweet.favoriteCount! -= 1
                APIManager.shared.unFavorite(tweet) { (tweet: Tweet?, error: Error?) in
                    if let  error = error {
                        print("Error unfavoriting tweet: \(error.localizedDescription)")
                    } else if let tweet = tweet {
                        print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    }
                }
            } else {
                tweet.favorited = true
                tweet.favoriteCount! += 1
                let button = sender as! UIButton
                button.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
                APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                    if let  error = error {
                        print("Error favoriting tweet: \(error.localizedDescription)")
                    } else if let tweet = tweet {
                        print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    }
                }
            }
        }
        
        refreshData()
    }
    
    func refreshData() {
        tweetTextLabel.text = tweet.text
        authorLabel.text = tweet.user.name
        screennameLabel.text = tweet.user.screenName
        tweetTimeStampLabel.text = tweet.createdAtString
        retweetCountLabel.text = String(describing: tweet.retweetCount)
        if tweet.favoriteCount != nil {
            favoriteCountLabel.text = String(describing: tweet.favoriteCount!)
        }
        
        if tweet.favorited! {
            favoriteBtn.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        } else {
            favoriteBtn.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        
        if tweet.retweeted {
            retweetBtn.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        } else {
            retweetBtn.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }

    }
    
}
