//
//  DwollaAPIManager.swift
//  checkMates
//
//  Created by Gregory Berns-Leone on 9/3/16.
//  Copyright © 2016 checkMates. All rights reserved.

//  Adapted from https://grokswift.com/alamofire-OAuth2/
//

import Foundation
import Alamofire

class DwollaAPIManager {
    static let sharedInstance = DwollaAPIManager()
    
    var OAuthToken: String? {
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "DwollaOAuthToken")
        }
        get {
            // print(NSUserDefaults.standardUserDefaults().stringForKey("DwollaOAuthToken"))
            return UserDefaults.standard.string(forKey: "DwollaOAuthToken")
        }
    }
    var tokenExpiry: Date? {
        set (newValue) {
            UserDefaults.standard.set((newValue?.timeIntervalSince1970)!, forKey: "DwollaOAuthExpiry")
        }
        get {
            return Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "DwollaOAuthExpiry"))
        }
    }
    var refreshToken: String? {
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "DwollaOAuthRefreshToken")
        }
        get {
            return UserDefaults.standard.string(forKey: "DwollaOAuthRefreshToken")
        }
    }
    var refreshExpiry: Date? {
        set (newValue) {
            UserDefaults.standard.set((newValue?.timeIntervalSince1970)!, forKey: "DwollaOAuthRefreshExpiry")
        }
        get {
            return Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "DwollaOAuthRefreshExpiry"))
        }
    }
    
    let clientID = valueForAPIKey(named: "DWOLLA_APP_ID")
    let clientSecret = valueForAPIKey(named: "DWOLLA_SECRET_KEY")
    let scope = "Contacts%7CSend%7CRequest"
    let redirectURI = "com.checkMates.checkMates%3A%2F%2F"
    
    // handlers for the OAuth process
    // stored as vars since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var OAuthTokenCompletionHandler : ((NSError?) -> Void)?
    
    func hasOAuthToken() -> Bool {
        // TODO: implement
        if let token = OAuthToken {
            if let exp = tokenExpiry {
                if exp.timeIntervalSinceNow > 0 {
                    return !token.isEmpty
                }
            }
        }
        return false
    }
    
    func hasRefreshToken() -> Bool {
        if let token = refreshToken {
            if let exp = refreshExpiry {
                if exp.timeIntervalSinceNow > 0 {
                    return !token.isEmpty
                }
            }
        }
        return false

    }
    
    // MARK: - OAuth flow
    
    func startOAuth2Login() {
        let authPath = "https://uat.dwolla.com/oauth/v2/authenticate?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)&scope=\(scope)&dwolla_landing=login"
//        print(authPath)
        if let authURL = URL(string: authPath) {
//            print("sending")
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "loadingOAuthToken")
            
            UIApplication.shared.openURL(authURL)
        }
        
        if self.hasOAuthToken() {
            if let completionHandler = self.OAuthTokenCompletionHandler {
                completionHandler(nil)
            }
        } else {
            if let completionHandler = self.OAuthTokenCompletionHandler {
                let noOAuthError = NSError(domain: "com.alamofire.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                completionHandler(noOAuthError)
            }
        }
    }
    
    func processOAuthStep1Response(_ url: URL) {
//        print(url)
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code : String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if queryItem.name.lowercased() == "code" {
                    code = queryItem.value
                    break
                }
            }
        }
        let getTokenPath = "https://uat.dwolla.com/oauth/v2/token"
        let tokenParams : [String: String]? = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": code!,
            "grant_type": "authorization_code",
            "redirect_uri": redirectURI
        ]
        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams!, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                if let anError = response.error {
                    print(anError)
                    if let completionHandler = self.OAuthTokenCompletionHandler {
                        let noOAuthError = NSError(domain: "com.alamofire.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                        completionHandler(noOAuthError)
                    }
                    return
                }
            }
            .responseData { response in
                self.handleOAuthTokenResponse(response)
        }
    }
    
    func refreshOAuthToken() {
        let getTokenPath = "https://uat.dwolla.com/oauth/v2/token"
        let tokenParams : [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "refresh_token": self.refreshToken!,
            "grant_type": "refresh_token",
        ]
        print("refreshing token")
        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                print("received refresh response")
                if let anError = response.error {
                    print(anError)
                    if let completionHandler = self.OAuthTokenCompletionHandler {
                        let noOAuthError = NSError(domain: "com.alamofire.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                        completionHandler(noOAuthError)
                    }
                    return
                }
            }
            .responseData { response in
                print("handling response")
                self.handleOAuthTokenResponse(response)
        }

    }
    
    func refreshTokenAndCallBack(_ callback: @escaping ((String) -> Void)) {
        let getTokenPath = "https://uat.dwolla.com/oauth/v2/token"
        let tokenParams : [String: String]? = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "refresh_token": self.refreshToken!,
            "grant_type": "refresh_token",
            ]
        print("refreshing token")
        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams!, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                print("received refresh response")
                if let anError = response.error {
                    print(anError)
                    if let completionHandler = self.OAuthTokenCompletionHandler {
                        let noOAuthError = NSError(domain: "com.alamofire.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                        completionHandler(noOAuthError)
                    }
                    return
                }
            }
            .responseData { response in
                print("handling response")
                self.handleOAuthTokenResponse(response)
                callback(self.OAuthToken!)
        }
    }
    
    func handleOAuthTokenResponse(_ response: DataResponse<Data>) {
        let json = try? JSONSerialization.jsonObject(with: response.result.value!, options: [])
        if let returnValue = json as? [String: Any] {
            if let a_token = returnValue["access_token"] as? String {
                self.OAuthToken = a_token
            } else {
                print(returnValue["access_token"])
            }
            if let a_expiry = returnValue["expires_in"] as? Double {
                self.tokenExpiry = Date(timeIntervalSinceNow: a_expiry)
            } else {
                print(returnValue["expires_in"])
            }
            if let r_token = returnValue["refresh_token"] as? String {
                self.refreshToken = r_token
            } else {
                print(returnValue["refresh_token"])
            }
            if let r_expiry = returnValue["refresh_expires_in"] as? Double {
                self.refreshExpiry = Date(timeIntervalSinceNow: r_expiry)
            } else {
                print(returnValue["refresh_expires_in"])
            }
//            print(self.OAuthToken)
//            print(self.refreshToken)
//            print(self.refreshExpiry)
//            print(self.tokenExpiry)
        }
    }
}
