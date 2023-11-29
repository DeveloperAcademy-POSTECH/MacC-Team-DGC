//
//  Bundle+Extension.swift
//  Carmu
//
//  Created by 허준혁 on 2023/10/02.
//

import Foundation

extension Bundle {

    var naverMapClientID: String {
        guard let filePath = Bundle.main.path(forResource: "SecureKey-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'SecureKey-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "NAVER_MAP_CLIENT_ID") as? String else {
            fatalError("Couldn't find key 'NAVER_MAP_CLIENT_ID' in 'SecureKey-Info.plist'.")
        }
        return value
    }

    var naverMapClientSecret: String {
        guard let filePath = Bundle.main.path(forResource: "SecureKey-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'SecureKey-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "NAVER_MAP_CLIENT_SECRET") as? String else {
            fatalError("Couldn't find key 'NAVER_MAP_CLIENT_SECRET' in 'SecureKey-Info.plist'.")
        }
        return value
    }

    var appID: String {
        guard let filePath = Bundle.main.path(forResource: "SecureKey-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'SecureKey-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "AppID") as? String else {
            fatalError("Couldn't find key 'AppID' in 'SecureKey-Info.plist'.")
        }
        return value
    }
}
