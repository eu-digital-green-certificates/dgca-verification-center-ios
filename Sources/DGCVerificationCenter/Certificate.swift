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
    
    private var certificate: CertificateApplication?
    
    public init?(from payload: String, ruleCountryCode: String? = nil) {
        if CertificateApplicant.isApplicableDCCFormat(payload: payload) {
            self.certificateType = .dcc
        #if canImport(DCCInspection)
            
            self.certificate =  try? HCert(payload: payload, ruleCountryCode: ruleCountryCode)
            
        #endif

        } else if CertificateApplicant.isApplicableICAOFormat(payload: payload) {
            self.certificateType = .icao
            #if canImport(ICAOInspection)
            self.cert = HCert(from: payload, ruleCountryCode: ruleCountryCode)
            #endif

        } else if CertificateApplicant.isApplicableDIVOCFormat(payload: payload) {
            self.certificateType = .divoc
            
        }
        return nil
    }

}
