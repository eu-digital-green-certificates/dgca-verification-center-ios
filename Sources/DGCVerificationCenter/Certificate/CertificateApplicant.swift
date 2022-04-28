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
    private static let supportedSHCPrefix = "shc:/"
    
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
    
    public static func isApplocableVerifiebleFormat(payload: String) -> Bool {
        if isApplicableDCCFormat(payload: payload) ||
            isApplicableICAOFormat(payload: payload) ||
            isApplicableDIVOCFormat(payload: payload) ||
            isApplicableSHCFormat(payload: payload) {
            return true
        } else {
            return false
        }
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
        var barcode: String = payload
        if !payload.starts(with: "ey") {
            // is not JWT, do numeric decoding
            guard let barcodeValue = schBuilder(payload: payload) else { return false }
            barcode = barcodeValue
        }
        
        let barcodeParts = barcode.split(separator: ".")
        guard let header = String(barcodeParts[0]).base64UrlDecoded() else { return false }
        
        let payload = String(barcodeParts[1]).base64UrlToBase64()
        guard let headerJson = try? JSONSerialization.jsonObject(with: header.data(using: .utf8)!,
            options: []) as? [String: Any] else { return false }
        
        if let algo = headerJson["zip"] as? String, algo == "DEF", let _ = Data(base64Encoded: payload) {
            // use deflate
        } else if let typ = headerJson["typ"] as? String, typ == "JWT", let _ = Data(base64Encoded: payload) {
            // use jwt
        } else {
            return false
        }
        
        guard let _ = headerJson["kid"] as? String else { return false }
        return true
    }
    
    private static func schBuilder(payload: String) -> String? {
        let rawBarcode = payload.replacingOccurrences(of: supportedSHCPrefix, with: "")
        var numericCode: String = ""
        var index = rawBarcode.startIndex
        while numericCode.count <= (rawBarcode.count / 2) - 1 {
            guard let numVal = Int(rawBarcode[index..<rawBarcode.index(index, offsetBy: 2)]) else { return nil }
            
            numericCode.append("\(UnicodeScalar(UInt8(numVal + 45)))")
            index = rawBarcode.index(index, offsetBy: 2)
        }
        return numericCode
    }
}
