//
//  DetailsViewController.swift
//  twitter_alamofire_demo
//
//  Created by Nicholas Rosas on 3/5/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, ReplyViewControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imgURL = tweet.user.profileImgURL {
            let url = URL(string: imgURL)
            profileImageView.af_setImage(withURL: url!)
        }
        descriptionLabel.text = tweet.text
        usernameLabel.text = tweet.user.name
        screenNameLabel.text = tweet.user.screenName
        timeStampLabel.text = getTimeStamp(createdAt: tweet.createdAtString)
        
        refreshData()
        
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped(gesture:)))
        
        profileImageView.addGestureRecognizer(profileImageTapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        let retweetImgTapGesture = UITapGestureRecognizer(target: self, action: #selector(retweetImgViewTapped(gesture:)))
        
        retweetImageView.addGestureRecognizer(retweetImgTapGesture)
        retweetImageView.isUserInteractionEnabled = true
        
        let favoriteImgTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteImgViewTapped(gesture:)))
        
        favoriteImageView.addGestureRecognizer(favoriteImgTapGesture)
        favoriteImageView.isUserInteractionEnabled = true
        
        let replyImgViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(replyImgViewTapped(gesture:)))
        
        replyImageView.addGestureRecognizer(replyImgViewTapGesture)
        replyImageView.isUserInteractionEnabled = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func profileImageViewTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil
        {
            //perform segue manually
            performSegue(withIdentifier: "detailToProfileSegue", sender: self)
        }
    }
    
    func retweetImgViewTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil
        {
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
    }
    
    func favoriteImgViewTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil
        {
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
                    APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                        if let  error = error {
                            print("Error favoriting tweet: \(error.localizedDescription)")
                        } else if let tweet = tweet {
                            print("Successfully favorited the following Tweet: \n\(tweet.text)")
                        }
                    }
                }
                
                refreshData()
            }
        }
    }
    
    func replyImgViewTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil
        {
            //perform segue manually
            performSegue(withIdentifier: "detailToReplySegue", sender: self)
        }
    }
    

    func refreshData() {
        retweetCountLabel.text = String(describing: tweet.retweetCount) + " " + TweetConstants.retweets_label
        if tweet.favoriteCount != nil {
            favoriteCountLabel.text = String(describing: tweet.favoriteCount!) + " " + TweetConstants.favorite_label
        }
        
        if tweet.favorited! {
            favoriteImageView.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            favoriteImageView.image = #imageLiteral(resourceName: "favor-icon")
        }
        
        if tweet.retweeted {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon")
        }
        
    }
    
    func getTimeStamp(createdAt: String) -> String {
        //return createdAt
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let createdDate = formatter.date(from: createdAt)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter.string(from: createdDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailToProfileSegue" {
            let vc = sender as! DetailsViewController
            let tweet = vc.tweet
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = tweet?.user
        } else if segue.identifier == "detailToReplySegue" {
            let vc = sender as! DetailsViewController
            let replyVC = segue.destination as! ReplyViewController
            replyVC.recipientScreenName = tweet.user.screenName
            replyVC.delegate = self
        }
    }
    
    func did(post: Tweet) {
        print("posted")
        self.navigationController?.popToViewController(self, animated: true)
    }

}
