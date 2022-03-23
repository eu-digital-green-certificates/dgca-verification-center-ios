//
//  File.swift
//  
//
//  Created by Igor Khomiak on 13.01.2022.
//

import Foundation
import CoreLibrary
import SwiftyJSON
import SwiftCBOR

public enum ClaimKey: String {
  case hCert = "-260"
  case euDgcV1 = "1"
}

class CertificateApplicant {
    static let supportedDCCPrefixes = [ "HC1:" ]
    
    static func checkIfCH1PreffixExist(_ payloadString: String?) -> Bool {
        guard let payloadString = payloadString  else { return false }
        
        for dccPrefix in supportedDCCPrefixes {
          if payloadString.starts(with: dccPrefix) {
              return true
          }
        }
        return false
    }

    static func parseSCCPrefix(_ payloadString: String) -> String {
        for dccPrefix in supportedDCCPrefixes {
            if payloadString.starts(with: dccPrefix) {
                return String(payloadString.dropFirst(dccPrefix.count))
            }
        }
        return payloadString
    }

    public static func isApplicableDCCFormat(payload: String) -> Bool {
        let payloadString: String
        if checkIfCH1PreffixExist(payload) {
            payloadString = parseSCCPrefix(payload)
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
}
