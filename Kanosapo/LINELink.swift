//
//  LINELink.swift
//  
//
//  Created by 牧内秀介 on 2020/12/20.
//

import Foundation
import LineSDK
import CryptoSwift

func authentication(vc:HomeViewController){ //LINE認証
    var parameters = LoginManager.Parameters()
    parameters.botPromptStyle = .aggressive
    LoginManager.shared.login(permissions: [.profile], in: vc, parameters: parameters) {
        result in
        switch result {
        case .success(let loginResult):    //(1)
            if let profile = loginResult.userProfile {
                print("User ID: \(profile.userID)")
                print("User Display Name: \(profile.displayName)")
                print("Login Token value:\(loginResult.accessToken.value)")
                print("Token expires at:\(loginResult.accessToken.expiresAt)")
                let encryptedToken = hoge(String(loginResult.accessToken.value))
                if encryptedToken != nil {
                    UserDefaults.standard.set(encryptedToken, forKey: "line_token")
                }
            }
            break
        case .failure(let error):
            print(error)
            break
        }
    }
}

func tokenUpdate(){ //LINEトークンの更新
    API.Auth.verifyAccessToken { result in
        switch result {
        case .success: break //連携済み
        case .failure(let error): //未連携or無効トークン
            print(error)
            if UserDefaults.standard.object(forKey: "line_token") != nil {
                print("トークン更新")
                API.Auth.refreshAccessToken { result in
                    switch result {
                    case .success(let token):
                        print("Token Refreshed: \(token)")
                        let encryptedToken = hoge(token.value)
                        if encryptedToken != nil {
                            UserDefaults.standard.set(encryptedToken, forKey: "line_token")
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
