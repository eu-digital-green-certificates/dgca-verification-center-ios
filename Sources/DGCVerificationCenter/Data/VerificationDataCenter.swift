//
//  VerificationDataCenter.swift
//  
//
//  Created by Igor Khomiak on 01.04.2022.
//

import Foundation

public class VerificationDataCenter {

    struct Constants {
        static let lastFetchKey = "lastFetchKey"
        static let lastLaunchedAppVersionKey = "lastLaunchedAppVersionKey"
    }
    
    private static let expiredDataInterval: TimeInterval = 12.0 * 60 * 60
    
    static var appVersion: String {
        let versionValue = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
        let buildNumValue = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1.0"
        return "\(versionValue)(\(buildNumValue))"
    }
}
