//
//  CertificateType.swift
//  
//
//  Created by Igor Khomiak on 07.12.2021.
//


import Foundation

public enum CertificateType: String {
    case unknown
    case dcc
    case icao
    case shc
    
    public var certificateDescription: String {
        switch self {
        case .unknown:
            return "Unknown Certificate Type"
        case .dcc:
            return "EU Digital COVID Certificate"
        case .icao:
            return "ICAO VDS COVID Certificate"
        case .shc:
            return "SMART Health Cards"
        }
    }
    
    public var certificateTaskDescription: String {
        switch self {
        case .unknown:
            return "Unknown Certificate Type"
        case .dcc:
            return "Trusted Public keys and Revocation Data"
        case .icao:
            return "ICAO Certificate Data"
         case .shc:
            return "SMART Health Cards Data"
        }
    }
    
}
