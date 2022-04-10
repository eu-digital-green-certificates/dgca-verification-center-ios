//
//  CertificateType.swift
//  
//
//  Created by Igor Khomiak on 07.12.2021.
//


import Foundation

public enum CertificateType: String {
    case dcc
    case icao
    case divoc
    case vc
    case shc
    
    public var certificateDescription: String {
        switch self {
        case .dcc:
            return "EU Digital COVID Certificate"
        case .icao:
            return "ICAO VDS COVID Certificate"
        case .divoc:
            return "DIVOC COVID Certificate"
        case .vc:
            return "Verifiable Credentials"
        case .shc:
            return "SMART Health Cards"
        }
    }
    
    public var certificateTaskDescription: String {
        switch self {
        case .dcc:
            return "Trusted Public keys and Revocation Data"
        case .icao:
            return "ICAO Certificate Data"
        case .divoc:
            return "DIVOC Certificate Data"
        case .vc:
            return "Verifiable Credentials data"
        case .shc:
            return "SMART Health Cards Data"
        }
    }
    
}
