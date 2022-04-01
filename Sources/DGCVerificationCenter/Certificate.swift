//
//  Certificate.swift
//  
//
//  Created by Igor Khomiak on 01.04.2022.
//

import UIKit

public class Certificate {
    public let certificateType: CertificateType?
    
    public init?(from payload: String, ruleCountryCode: String? = nil) {
        if CertificateApplicant.isApplicableDCCFormat(payload: payload) {
            self.certificateType = .dcc
            
        } else if CertificateApplicant.isApplicableICAOFormat(payload: payload) {
            self.certificateType = .icao
            
        } else if CertificateApplicant.isApplicableDIVOCFormat(payload: payload) {
            self.certificateType = .divoc
            
        }
        return nil
    }

}
