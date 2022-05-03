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

#if canImport(DGCSHInspection)
import DGCSHInspection
#endif


public struct ApplicableInspector {
    public let type: CertificateType
    public let inspector: CertificateInspection
}

public class DGCVerificationCenter {

    public static let shared = DGCVerificationCenter()
    
    public struct SharedLinks {
        public static let linkToOpenGitHubSource = "https://github.com/eu-digital-green-certificates"
        public static let linkToOopenEuCertDoc = "https://ec.europa.eu/health/ehealth/covid-19_en"
    }
    
    public static var countryCodes: [CountryModel] {
        get {
            #if canImport(DCCInspection)
            return DCCDataCenter.countryCodes.sorted(by: { $0.name < $1.name })
            #else
            return []
            #endif
        }
    }

    public let applicableCertificateTypes: [CertificateType]
    
    public var dccInspector: CertificateInspection?
    public var icaoInspector: CertificateInspection?
    public var divocInspector: CertificateInspection?
    public var shcInspector: CertificateInspection?

    public var applicableInspectors: [ApplicableInspector] = []
    
    public init() {
        var arrayTypes = [CertificateType] ()
        
        // In reality all Verification Processors will be packed to separated modules
        // and imported to the developed project
        // To check availability of module we will simple use compilator directive
        // #if canImport(ModuleName), f.e for "Integer" processor
        // #if canImport(IntegerProcessor)
        // where IntegerProcessor - is an external module of SDK
        //
        // To imitate absense one of listed modules simple change name to supposed name
        // Also cgange the name in directives in TestResultController
        
        #if canImport(DCCInspection)
            arrayTypes.append(.dcc)
            let digInspector = DCCInspection()
            self.dccInspector = digInspector
            let applicableDCCInspector = ApplicableInspector(type: .dcc, inspector: digInspector)
            self.applicableInspectors.append(applicableDCCInspector)
        #endif
        
        #if canImport(ICAOInspection)
            arrayTypes.append(.icao)
            let icInspector = ICAOInspection()
            self.icaoInspector = icInspector
            let applicableICAOInspector = ApplicableInspector(type: .icao, inspector: icInspector)
            self.applicableInspectors.append(applicableICAOInspector)
        #endif
        
        #if canImport(DIVOCInspection)
            arrayTypes.append(.divoc)
            let dvcInspector = DIVOCInspection()
            self.divocInspector = dvcInspector
            let applicableDIVInspector = ApplicableInspector(type: .divoc, inspector: dvcInspector)
            self.applicableInspectors.append(applicableDIVInspector)
        #endif
                
        #if canImport(DGCSHInspection)
            arrayTypes.append(.shc)
            let shInspector = DGCSHInspection()
            self.shcInspector = shInspector
            let applicableSHInspector = ApplicableInspector(type: .shc, inspector: shInspector)
            self.applicableInspectors.append(applicableSHInspector)
            #endif
        
        self.applicableCertificateTypes = arrayTypes
    }
    
    public init?(types: [CertificateType]) {
        var arrayTypes = [CertificateType] ()
        
        #if canImport(DCCInspection)
            if types.contains(.dcc) {
                arrayTypes.append(.dcc)
                let inspector = DCCInspection()
                self.dccInspector = inspector
                let applicableInspector = ApplicableInspector(type: .dcc, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)
            }
        #endif
        
        #if canImport(ICAOInspection)
            if types.contains(.icao) {
                arrayTypes.append(.icao)
                let inspector = ICAOInspection()
                self.icaoInspector = inspector
                let applicableInspector = ApplicableInspector(type: .icao, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)
            }
        #endif
        
        #if canImport(DIVOCInspection)
            if types.contains(.divoc) {
                arrayTypes.append(.divoc)
                let inspector = DIVOCInspection()
                self.divocInspector = inspector
                let applicableInspector = ApplicableInspector(type: .divoc, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)
            }
        #endif
                
        #if canImport(DGCSHInspection)
            if types.contains(.shc) {
                arrayTypes.append(.shc)
                let inspector = DGCSHInspection()
                self.shcInspector = inspector
                let applicableInspector = ApplicableInspector(type: .shc, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)
            }
        #endif
        
        if !arrayTypes.isEmpty {
            self.applicableCertificateTypes = arrayTypes
        } else {
            return nil
        }
    }
    
    public init?(type: CertificateType) {
        var arrayTypes = [CertificateType] ()
        
        #if canImport(DCCInspection)
            if type == .dcc {
                arrayTypes.append(.dcc)
                let inspector = DCCInspection()
                self.dccInspector = inspector
                let applicableInspector = ApplicableInspector(type: .dcc, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)
            }
        #endif
        
        #if canImport(ICAOInspection)
            if type == .icao {
                arrayTypes.append(.icao)
                let inspector = ICAOInspection()
                self.icaoInspector = inspector
                let applicableInspector = ApplicableInspector(type: .icao, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)
            }
        #endif
        
        #if canImport(DIVOCInspection)
            if type == .divoc {
                arrayTypes.append(.divoc)
                let inspector = DIVOCInspection()
                self.divocInspector = inspector
                let applicableInspector = ApplicableInspector(type: .divoc, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)

            }
        #endif

        #if canImport(DGCSHInspection)
            if type == .shc {
                arrayTypes.append(.shc)
                let inspector = DGCSHInspection()
                self.shcInspector = inspector
                let applicableInspector = ApplicableInspector(type: .shc, inspector: inspector)
                self.applicableInspectors.append(applicableInspector)
            }
        #endif

        if !arrayTypes.isEmpty {
            self.applicableCertificateTypes = arrayTypes
        } else {
            return nil
        }
    }
    
    // MARK: - Availability
    public func isVerifiableCertificateType(_ type: CertificateType) -> Bool {
        return self.applicableCertificateTypes.contains(type)
    }
    
    // MARK: - Validation
//    public static func isApplicableToTicketingFormat(payload: String) -> Bool {
//        guard let payloadData = payload.data(using: .utf8),
//            let ticketing = try? JSONDecoder().decode(CheckInQR.self, from: payloadData) else { return false }
//        return !ticketing.token.isEmpty
//    }

    // MARK: - Data Loading
    public func prepareStoredData(appType: AppType, completion: @escaping DataCompletionHandler) {
        let group = DispatchGroup()
        
        for applicant in applicableInspectors {
            group.enter()
            applicant.inspector.prepareLocallyStoredData(appType: appType) { err in
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    public func updateStoredData(appType: AppType, completion: @escaping DataCompletionHandler) {
        let group = DispatchGroup()
        
        for applicant in applicableInspectors {
            group.enter()
            applicant.inspector.updateLocallyStoredData(appType: appType) { err in
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(.success)
        }
    }
    
    // MARK: - Verifying
    
    public func validateCertificate(_ multiTypeCertificate: MultiTypeCertificate) -> ValidityState? {
        guard let certificate = multiTypeCertificate.digitalCertificate else { return nil }
        
        switch multiTypeCertificate.certificateType {
        case .unknown:
            return nil
        case .dcc:
            return dccInspector?.validateCertificate(certificate)
        case .icao:
            return icaoInspector?.validateCertificate(certificate)
        case .divoc:
            return divocInspector?.validateCertificate(certificate)
        case .shc:
            return shcInspector?.validateCertificate(certificate)
        }
    }
}
