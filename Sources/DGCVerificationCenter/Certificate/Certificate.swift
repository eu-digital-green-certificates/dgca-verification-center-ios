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

public class Certificate {
    public let certificateType: CertificateType?
    public let ruleCountryCode: String?
    
    public var firstName: String {
        certificate?.firstName ?? ""
    }
    
    public var firstNameStandardized: String? {
        certificate?.firstNameStandardized ?? ""
    }
    
    public var lastName: String {
        certificate?.lastName ?? ""
    }
    
    public var lastNameStandardized: String {
        certificate?.lastNameStandardized ?? ""
    }

    public var fullName: String {
        certificate?.fullName ?? ""
    }
    
    private var certificate: CertificateApplication?
    
    public init?(from payload: String, ruleCountryCode: String? = nil) {
        self.ruleCountryCode = ruleCountryCode
        
        if CertificateApplicant.isApplicableDCCFormat(payload: payload) {
            self.certificateType = .dcc
        #if canImport(DCCInspection)
            self.certificate =  try? HCert(payload: payload, ruleCountryCode: ruleCountryCode)
        #endif

        } else if CertificateApplicant.isApplicableICAOFormat(payload: payload) {
            self.certificateType = .icao
            #if canImport(ICAOInspection)
            self.certificate = HCert(from: payload, ruleCountryCode: ruleCountryCode)
            #endif

        } else if CertificateApplicant.isApplicableDIVOCFormat(payload: payload) {
            self.certificateType = .divoc
            #if canImport(DIVOCInspection)
            self.certificate = HCert(from: payload, ruleCountryCode: ruleCountryCode)
            #endif
        }
        return nil
    }

}
