//
//  LINELink.swift
//  
//
//  Created by 牧内秀介 on 2020/12/20.
//

import Foundation
import LineSDK
import CryptoSwift

func authentication(vc:HomeViewController){
//    if UserDefaults.standard.object(forKey: "line_token") == nil {
        LoginManager.shared.login(permissions: [.profile], in: vc) {
            result in
            switch result {
            case .success(let loginResult):    //(1)
                if let profile = loginResult.userProfile {
                    print("User ID: \(profile.userID)")
                    print("User Display Name: \(profile.displayName)")
                    print("encrypt")
                    
                    print("Login Token value:\(loginResult.accessToken.value)")
                    print("Token expires at:\(loginResult.accessToken.expiresAt)")
                    let encryptedToken = hoge(String(loginResult.accessToken.value))
                    if encryptedToken != nil {
                        UserDefaults.standard.set(encryptedToken, forKey: "line_token")
                        UserDefaults.standard.set(loginResult.accessToken.expiresAt, forKey: "line_token_expiresAt")
                    }
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
//    }
    
}

func tokenUpdate(){
    let f = DateFormatter()
    f.dateStyle = .long
    f.timeStyle = .none
    let today = f.string(from: Date())
    var expiresAt = ""
    if UserDefaults.standard.object(forKey: "line_token_expiresAt") != nil {
        expiresAt = f.string(from: UserDefaults.standard.object(forKey: "line_token_expiresAt") as! Date)
    }
    if today >= expiresAt {
        print("トークン更新")
        API.Auth.refreshAccessToken { result in
            switch result {
            case .success(let token):
                print("Token Refreshed: \(token)")
                let encryptedToken = hoge(token.value)
                if encryptedToken != nil {
                    UserDefaults.standard.set(encryptedToken, forKey: "line_token")
                    UserDefaults.standard.set(token.expiresAt, forKey: "line_token_expiresAt")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
