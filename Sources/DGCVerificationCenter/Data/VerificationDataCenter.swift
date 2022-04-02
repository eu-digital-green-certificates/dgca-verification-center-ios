//
//  VerificationDataCenter.swift
//  
//
//  Created by Igor Khomiak on 01.04.2022.
//

import UIKit

public class VerificationDataCenter {

    struct Constants {
        static let lastFetchKey = "lastFetchKey"
        static let lastLaunchedAppVersionKey = "lastLaunchedAppVersionKey"
    }
    
    private static let expiredDataInterval: TimeInterval = 12.0 * 60 * 60
    
    static var appVersion: String {
        let versionValue = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "?.?.?"
        let buildNumValue = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "?.?.?"
        return "\(versionValue)(\(buildNumValue))"
    }

    public static var downloadedDataHasExpired: Bool {
        return lastFetch.timeIntervalSinceNow < -expiredDataInterval
    }
    
    public static var lastFetch: Date {
        get {
            return UserDefaults.standard.object(forKey: Constants.lastFetchKey) as? Date ?? Date.distantPast
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.lastFetchKey)
        }
    }

    public static var appWasRunWithOlderVersion: Bool {
        return lastLaunchedAppVersion != appVersion
    }
    
    public static var lastLaunchedAppVersion: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.lastLaunchedAppVersionKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.lastLaunchedAppVersionKey)
        }
    }

}
