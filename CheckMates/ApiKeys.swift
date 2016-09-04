//
//  ApiKeys.swift
//  checkMates
//
//  Created by Gregory Berns-Leone on 9/3/16.
//  Copyright © 2016 checkMates. All rights reserved.
//

import Foundation

func valueForAPIKey(named keyname:String) -> String {
    // Credit to the original source for this technique at
    // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
    let filePath = NSBundle.mainBundle().pathForResource("APIKeys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    let value = plist?.objectForKey(keyname) as! String
    return value
}