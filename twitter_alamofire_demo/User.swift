//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var id: Int64
    var name: String
    var screenName: String?
    var profileImgURL: String?
    var profileBackgroundImgURL: String?
    var description: String?
    var followers_cnt: Int?
    var following_cnt: Int?
    
    var dictionary: [String: Any]?
    
    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        id = dictionary["id"] as! Int64
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as? String
        if screenName != nil {
            screenName = "@" + screenName!
        }
        profileImgURL = dictionary["profile_image_url_https"] as? String
        profileBackgroundImgURL = (dictionary["profile_use_background_image"] as! Bool) ? (dictionary["profile_background_image_url_https"] as? String) : nil
        description = dictionary["description"] as? String
        if description == "" {
            description = nil
        }
        followers_cnt = dictionary["followers_count"] as? Int
        following_cnt = dictionary["friends_count"] as? Int
        
    }
}
