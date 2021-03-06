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

#if canImport(DGCSHInspection)
import DGCSHInspection
#endif

// TODO: Add import of TemplateInspection
#if canImport(TemplateInspection)
import TemplateInspection
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
    
    public var certificateCreationDate: String {
      digitalCertificate?.certificateCreationDate ?? ""
    }
    
    public init(from payload: String, ruleCountryCode: String? = nil) throws {
        self.ruleCountryCode = ruleCountryCode
        self.scannedDate = Date()
        
        if CertificateApplicant.isApplicableDCCFormat(payload: payload) {
            self.certificateType = .dcc
            #if canImport(DCCInspection)
                do {
                    self.digitalCertificate = try HCert(payload: payload, ruleCountryCode: ruleCountryCode)
                } catch {
                    throw error
                }
            #endif
        
        
        } else if CertificateApplicant.isApplicableSHCFormat(payload: payload) {
            self.certificateType = .shc
            #if canImport(DGCSHInspection)
                do {
                    self.digitalCertificate = try SHCert(payload: payload)
                } catch {
                    throw error
                }
            #endif
        
        // TODO: Add creating of certificate for Template format
//        } else if CertificateApplicant.isApplicableTemplateFormat(payload: payload) {
//            self.certificateType = .template
//            #if canImport(TemplateInspection)
//                // create Template certificate here
//            #endif

        } else {
            throw CertificateParsingError.unknownFormat
        }
            
    }
    
    public init(with certificate: CertificationProtocol, type: CertificateType, scannedDate: Date, storedTan: String?,
        ruleCountryCode: String? = nil) {
        self.ruleCountryCode = ruleCountryCode
        self.certificateType = type
        self.digitalCertificate = certificate
        self.scannedDate = scannedDate
        self.storedTan = storedTan
    }
}
