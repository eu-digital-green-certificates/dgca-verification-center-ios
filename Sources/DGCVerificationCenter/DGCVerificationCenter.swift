import Foundation
import DGCCoreLibrary

#if canImport(DCCInspection)
import DCCInspection
#endif

#if canImport(DGCSHInspection)
import DGCSHInspection
#endif

// TODO: Uncomment this when add new template inspector
//#if canImport(TemplateInspection)
//import TemplateInspection
//#endif


public struct ApplicableInspector {
    public let type: CertificateType
    public let inspector: CertificateValidating & DataLoadingProtocol
}

public struct SharedLinks {
    public static let linkToOpenGitHubSource = "https://github.com/eu-digital-green-certificates"
    public static let linkToOopenEuCertDoc = "https://ec.europa.eu/health/ehealth/covid-19_en"
}

public class DGCVerificationCenter {
    
    public static let shared = DGCVerificationCenter()
    
    public static var appVersion: String {
        let versionValue = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
        let buildNumValue = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1.0"
        return "\(versionValue)(\(buildNumValue))"
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
    
    public var dccInspector: (CertificateValidating & DataLoadingProtocol)?
    public var shcInspector: (CertificateValidating & DataLoadingProtocol)?
    
    public var applicableInspectors: [ApplicableInspector] = []
    
    public var downloadedDataHasExpired: Bool {
        return (dccInspector?.downloadedDataHasExpired ?? false) || (shcInspector?.downloadedDataHasExpired ?? false)
    }

    public init() {
        var arrayTypes = [CertificateType] ()
        
        // In reality all Verification Inspectors will be packed to separated modules
        // and imported to the developed project
        // To check availability of module we will simple use compilator directive
        // #if canImport(ModuleNameInspector), f.e for "ModuleName" inspector
        // #if canImport(ModuleName)
        //
        // To imitate absense one of listed modules simple change name to supposed name
        // Also change the name in directives in TestResultController
        
        #if canImport(DCCInspection)
            arrayTypes.append(.dcc)
            let digInspector = DCCInspection()
            self.dccInspector = digInspector
            let applicableDCCInspector = ApplicableInspector(type: .dcc, inspector: digInspector)
            self.applicableInspectors.append(applicableDCCInspector)
        #endif
                
        #if canImport(DGCSHInspection)
            arrayTypes.append(.shc)
            let shInspector = DGCSHInspection()
            self.shcInspector = shInspector
            let applicableSHInspector = ApplicableInspector(type: .shc, inspector: shInspector)
            self.applicableInspectors.append(applicableSHInspector)
        #endif
        
        // TODO: Add TemplateInspection initialization
        #if canImport(TemplateInspection)
         // Add TemplateInspector
        #endif

        self.applicableCertificateTypes = arrayTypes
    }
    
    // TODO: Add other TemplateInspection initialization
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
    
    // TODO: - Add Validation for ticketing
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
    
    // MARK: - Is Applicable Formats
    // General format
    public func isApplicableFormat(payload: String) -> Bool {
        return CertificateApplicant.isApplicableFormatForVerification(payload: payload)
    }
    
    //DCC
    public func isApplicableDCCFormat(payload: String) -> Bool {
        return CertificateApplicant.isApplicableDCCFormat(payload: payload)
    }
    
    public func isApplicableSHCFormat(payload: String) -> Bool {
        return CertificateApplicant.isApplicableSHCFormat(payload: payload)
    }

    // MARK: - Verifying
    public func validateCertificate(_ multiTypeCertificate: MultiTypeCertificate) -> ValidityState? {
        guard let certificate = multiTypeCertificate.digitalCertificate else { return nil }
        
        switch multiTypeCertificate.certificateType {
        case .unknown:
            return nil
            
        case .dcc:
            return dccInspector?.validateCertificate(certificate)
            
        case .shc:
            return shcInspector?.validateCertificate(certificate)
        }
    }
}
