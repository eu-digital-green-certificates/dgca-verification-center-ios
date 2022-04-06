//
//  Certificate.swift
//  
//
//  Created by Igor Khomiak on 01.04.2022.
//

import Foundation
import DGCCoreLibrary

#if canImport(DCCInspection)
import DCCInspection
#endif
#if canImport(ICAOInspection)
import ICAOInspection
#endif
#if canImport(DIVOCInspection)
import DIVOCInspection
#endif

public class MultiTypeCertificate {
    public let certificateType: CertificateType
    public let ruleCountryCode: String?
    
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
    
    public init?(from payload: String, ruleCountryCode: String? = nil) {
        self.ruleCountryCode = ruleCountryCode
        
        if CertificateApplicant.isApplicableDCCFormat(payload: payload) {
            self.certificateType = .dcc
        #if canImport(DCCInspection)
            self.digitalCertificate = try? HCert(payload: payload, ruleCountryCode: ruleCountryCode)
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
        } else {
            return nil
        }
    }

}
