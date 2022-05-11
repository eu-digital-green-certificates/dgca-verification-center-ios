//
//  Certificate.swift
//  
//
//  Created by Igor Khomiak on 01.04.2022.
//

import Foundation
import DGCCoreLibrary
import SwiftyJSON

#if canImport(DCCInspection)
import DCCInspection
#endif
#if canImport(ICAOInspection)
import ICAOInspection
#endif
#if canImport(DIVOCInspection)
import DIVOCInspection
#endif
#if canImport(DGCSHInspection)
import DGCSHInspection
#endif

public class MultiTypeCertificate {
    public let certificateType: CertificateType
    public let ruleCountryCode: String?
    
    public let scannedDate: Date
    public var storedTan: String?
    
    public var digitalCertificate: CertificationProtocol?
    
    public var firstName: String {
        digitalCertificate?.firstName ?? ""
    }
    
    public var firstNameStandardized: String? {
        digitalCertificate?.firstNameStandardized ?? ""
    }
    
    public var lastName: String {
        digitalCertificate?.lastName ?? ""
    }
    
    public var lastNameStandardized: String {
        digitalCertificate?.lastNameStandardized ?? ""
    }

    public var fullName: String {
        digitalCertificate?.fullName ?? ""
    }
    
    public var certTypeString: String {
        digitalCertificate?.certTypeString ?? ""
    }

    public var isRevoked: Bool {
        digitalCertificate?.isRevoked ?? false
    }
    
    public var isUntrusted: Bool {
        digitalCertificate?.isUntrusted ?? false
    }

    public var certHash: String {
        digitalCertificate?.certHash ?? ""
    }
    
    public var uvciHash: Data? {
        digitalCertificate?.uvciHash
    }
    
    public var countryCodeUvciHash: Data? {
        digitalCertificate?.countryCodeUvciHash
    }
    
    public var signatureHash: Data? {
        digitalCertificate?.signatureHash
    }
    
    public var body: JSON? {
        digitalCertificate?.body
    }
    
    public init(from payload: String, ruleCountryCode: String? = nil) throws {
        self.ruleCountryCode = ruleCountryCode
        self.scannedDate = Date()
        
        if CertificateApplicant.isApplicableDCCFormat(payload: payload) {
            self.certificateType = .dcc
            #if canImport(DCCInspection)
                do {
                    self.digitalCertificate = try HCert(payload: payload, ruleCountryCode: ruleCountryCode)
                } catch let error {
                    throw error
                }
            #endif
        
        } else if CertificateApplicant.isApplicableICAOFormat(payload: payload) {
            self.certificateType = .icao
            #if canImport(ICAOInspection)
                self.digitalCertificate = try? HCert(from: payload, ruleCountryCode: ruleCountryCode)
            #endif
        
        } else if CertificateApplicant.isApplicableDIVOCFormat(payload: payload) {
            self.certificateType = .divoc
            #if canImport(DIVOCInspection)
                self.digitalCertificate = try? HCert(from: payload, ruleCountryCode: ruleCountryCode)
            #endif
        
        } else if CertificateApplicant.isApplicableSHCFormat(payload: payload) {
            self.certificateType = .shc
            #if canImport(DGCSHInspection)
                do {
                    self.digitalCertificate = try SHCert(payload: payload)
                } catch let error {
                    throw error
                }
            #endif
        
        } else {
            throw CertificateParsingError.unknownFormat
        }
    }
    
    public init(with certificate: CertificationProtocol, type: CertificateType, scannedDate: Date, storedTan: String?, ruleCountryCode: String? = nil) {
        self.ruleCountryCode = ruleCountryCode
        self.certificateType = type
        self.digitalCertificate = certificate
        self.scannedDate = scannedDate
    }
}
