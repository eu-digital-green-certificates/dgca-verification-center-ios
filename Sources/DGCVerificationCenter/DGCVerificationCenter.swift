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


public class DGCVerificationCenter {

    public let applicableCertificateTypes: [CertificateType]
    
    public var dccInspector: CertificateInspection?
    public var icaoInspectior: CertificateInspection?
    public var divocInspectior: CertificateInspection?

    public init() {
        var arrayTypes = [CertificateType] ()
        
        // In reality all Verification Processors will be packed to separated modules
        // and imported to the developed project
        // To check availability of module we will simple use compilator directive
        // #if canImport(ModleName), f.e for "Integer" processor
        // #if canImport(IntegerProcessor)
        // where IntegerProcessor - is an external module of SDK
        // I added UIKit, because of there are no modules and UIKit alwas exists
        //
        // To imitate absense one of listed modules simple change name to supposed name
        // Also cgange the name in directives in TestResultController
        #if canImport(DCCInspection)
            arrayTypes.append(.dcc)
        dccInspector = DCCInspection()
        #endif
        
        #if canImport(ICAOInspection)
            arrayTypes.append(.icao)
            icaoInspectior = ICAOInspection()
        #endif
        
        #if canImport(DIVOCInspection)
            arrayTypes.append(.divoc)
            divocInspectior = DIVOCInspection()
        #endif
        
        self.applicableCertificateTypes = arrayTypes
    }
    
    public init?(types: [CertificateType]) {
        var arrayTypes = [CertificateType] ()
        
        #if canImport(DCCInspection)
            if types.contains(.dcc) {
                arrayTypes.append(.dcc)
                dccInspector = DCCInspection()
            }
        #endif
        
        #if canImport(ICAOInspection)
            if types.contains(.icao) {
                arrayTypes.append(.icao)
                icaoInspectior = ICAOInspection()
            }
        #endif
        
        #if canImport(DIVOCInspection)
            if types.contains(.divoc) {
                arrayTypes.append(.divoc)
                divocInspectior = DIVOCInspection()
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
                dccInspector = DCCInspection()
            }
        #endif
        
        #if canImport(ICAOInspection)
            if type == .icao {
                arrayTypes.append(.icao)
                icaoInspectior = ICAOInspection()
            }
        #endif
        
        #if canImport(DIVOCInspection)
            if type == .divoc {
                arrayTypes.append(.divoc)
                divocInspectior = DIVOCInspection()
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

}
