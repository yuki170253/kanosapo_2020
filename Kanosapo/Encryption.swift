//
//  Encryption.swift
//  Kanosapo
//
//  Created by 牧内秀介 on 2020/12/10.
//


import Foundation
import CryptoSwift  // ここを書いた時点で「⌘+B」しておくべきかも

func hoge(_ text: String) -> String? {
    let bytes = [UInt8](text.utf8)
    // AESの鍵方式に合わせて各自変更
    let key = "aq90k3hdcv23jifg1m4g1b5cxa0rjcv3"
    let iv = getInitializationVector()
    
    do {
        let aes = try AES(key: key, iv: iv)
        let encrypted = try aes.encrypt(bytes)
        let encryptedData = Data(bytes: encrypted, count: encrypted.count)
        let sendData = NSMutableData(bytes: iv, length: iv.count)
        sendData.append(encryptedData)
        let sendDataBase64 = sendData.base64EncodedString(options: .lineLength64Characters)
        print("Encrypt: \(sendDataBase64)")
        // Encrypt: rLKCA1hNmqu2dq+08E9mK2lBlspQN0+CYBkWkCQz7IvHhh+qbfysc26Oh1SS4Adq
        return sendDataBase64
    } catch let error {
        print("Error: \(error)")
        return nil
    }
}


func getInitializationVector() -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let l = UInt32(letters.length)
    
    var randomString = ""
    let length = 16
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(l)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}
