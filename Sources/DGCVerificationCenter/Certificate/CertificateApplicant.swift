//
//  File.swift
//  
//
//  Created by Igor Khomiak on 13.01.2022.
//

import Foundation
import DGCCoreLibrary
import SwiftyJSON
import SwiftCBOR

enum ClaimKey: String {
  case hCert = "-260"
  case euDgcV1 = "1"
}

public class CertificateApplicant {
    private static let supportedDCCPrefixes = [ "HC1:" ]
    private static let supportedSHCPrefixes = [ "shc:/" ]

    // MARK: - DCC
    private static func doesCH1PreffixExist(_ payloadString: String?) -> Bool {
        guard let payloadString = payloadString  else { return false }
        
        for dccPrefix in supportedDCCPrefixes {
          if payloadString.starts(with: dccPrefix) {
              return true
          }
        }
        return false
    }
    
    private static func parseDCCPrefix(_ payloadString: String) -> String {
        for dccPrefix in supportedDCCPrefixes {
            if payloadString.starts(with: dccPrefix) {
                return String(payloadString.dropFirst(dccPrefix.count))
            }
        }
        return payloadString
    }
    
    // MARK: - SCH
    private static func doesSCHPreffixExist(_ payloadString: String?) -> Bool {
        guard let payloadString = payloadString  else { return false }
        
        for dccPrefix in supportedSHCPrefixes {
            if payloadString.starts(with: dccPrefix) {
                return true
            }
        }
        return false
    }
    
    public static func isApplicableDCCFormat(payload: String) -> Bool {
        let payloadString: String
        if doesCH1PreffixExist(payload) {
            payloadString = parseDCCPrefix(payload)
        } else {
            payloadString = payload
        }
        
        guard let compressed = try? payloadString.fromBase45() else { return false }
        
        let cborData = ZLib.decompress(compressed)
        guard !cborData.isEmpty else { return false }

        guard let headerStr = CBOR.header(from: cborData)?.toString(),
            let bodyStr = CBOR.payload(from: cborData)?.toString(),
            let kid = CBOR.kid(from: cborData)
        else { return false }
        
        let kidStr = KID.string(from: kid)
        let header = JSON(parseJSON: headerStr)
        var body = JSON(parseJSON: bodyStr)
        
        if !kidStr.isEmpty && !header.isEmpty && body[ClaimKey.hCert.rawValue].exists() {
            body = body[ClaimKey.hCert.rawValue]
        }
        
        return body[ClaimKey.euDgcV1.rawValue].exists()
    }
    
    public static func isApplicableICAOFormat(payload: String) -> Bool {
        return false
    }
    
    public static func isApplicableDIVOCFormat(payload: String) -> Bool {
        return false
    }
    
    public static func isApplicableVCFormat(payload: String) -> Bool {
        return false
    }
    
    public static func isApplicableSHCFormat(payload: String) -> Bool {
        if doesSCHPreffixExist(payload) {
            return true
        } else {
            return false
        }
    }
}
