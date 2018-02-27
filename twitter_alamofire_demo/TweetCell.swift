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
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            authorLabel.text = tweet.user.name
            screennameLabel.text = tweet.user.screenName
            tweetTimeStampLabel.text = tweet.createdAtString
            retweetCountLabel.text = String(describing: tweet.retweetCount)
            if tweet.favoriteCount != nil {
                favoriteCountLabel.text = String(describing: tweet.favoriteCount!)
            }

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
        tweet.retweeted = true
        tweet.retweetCount += 1
    }
    @IBAction func didTapFavorite(_ sender: Any) {
        tweet.favorited = true
        tweet.favoriteCount! += 1
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
    }
    
}
