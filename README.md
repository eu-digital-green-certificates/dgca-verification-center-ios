<h1 align="center">
   EU Digital COVID Certificate - DGCA Verification Center for IOS
</h1>

<p align="center">
  <a href="/../../commits/" title="Last Commit">
    <img src="https://img.shields.io/github/last-commit/eu-digital-green-certificates/dgca-verification-center-ios?style=flat">
  </a>
  <a href="/../../issues" title="Open Issues">
    <img src="https://img.shields.io/github/issues/eu-digital-green-certificates/dgca-verification-center-ios?style=flat">
  </a>
  <a href="./LICENSE" title="License">
    <img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=flat">
  </a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#development">Development</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#support-and-feedback">Support</a> •
  <a href="#how-to-contribute">Contribute</a> •
  <a href="#contributors">Contributors</a> •
  <a href="#licensing">Licensing</a>
</p>

## About

This repository contains the source code of the EU Digital COVID Certificate Verification Center Module for IOS. 

The Verification Center is designed to simplify working with existing certificate types and provide a platform for quickly creating new types.

This module encapsulates the available modules for the QR verification process (e.g. DCC, SHC). Available modules included DCC and SHC inspectors and Core module. The core module contains the services used in the SDK module and in the inspectors.

The verification process for new types of certificates can be extended by creating new modules of inspectors. Inspectors are independent and may be included or excluded at any time.


## Development

To start using the Verification Center SDK, simply connect this package to an application or other module.

### Components

The SDK is a four layers software. 

This Verification Center module is on a top layer. It contains all the basic methods needed to work with certificates.

On the next layer are row of verification inspectors. Now SDK includes two DCC and SHC inspectors. Inspectors may not be used directly. They will be needed for special tasks related to a specific type of certificate. The inspectors encapsulated all the work with certificates of the appropriate type. Inspectors also download and securely store the data.

The third layer contains Core library where are incapsulated common secure servises such as encryption, sighning. zipping, etc.

The auxiliary layer contains auxiliary modules that are used in second and thitd layers. There are JSON and Cert Logic, Bloom and Hash filters and row of third part libraries. It is available in the Center and can be imported to apps for some specific tasks.

#### DGCVerificationCenter is a Root object in API

The Verification Center is responsible for such main tasks:

   - check if certificate standard is applicable to the SDK
   
   - verification of scanned QR certificates and prepare report.
   
   - loading necessary data.


The root Verification Center object is a shared object of DGCVerificationCenter class

      public class DGCVerificationCenter
      
      public static let shared = DGCVerificationCenter()
      
That object is responsible for verification of scanned and saved certificates.

The certificate has its own specific type and can be verified depend on implemented inspectors

      public enum CertificateType: String { case unknown, dcc, icao, shc }

The CertificateType contains existed types of certificates (.dcc, .shc) and may contain non-existed types (.icao) that aren't added yet.

#### Initialization of DGCVerificationCenter

      public init()
 Initializes Verification Center with all available types

      public init?(types: [CertificateType])
 Initializes Verification Center with listed available types. If listed types are unavailable - the DGCVerificationCenter won't be created.

      public init?(type: CertificateType)
 Initializes Verification Center with pointed available type. If that type is unavailable - the DGCVerificationCenter won't be created.
 
#### Inspectors 

      public final class DCCInspection: CertificateInspection
      
      public final class DGCSHInspection: CertificateInspection
   
   Every Inspector is a root class of Inspector module. That module can be included to or excluded from the Verification Center.
   
      public var dccInspector: CertificateInspecting & DataLoadingProtocol?
      public var icaoInspector: CertificateInspecting & DataLoadingProtocol?
      public var shcInspector: CertificateInspecting & DataLoadingProtocol?
      
      public var applicableInspectors: [ApplicableInspector] = []

   The CertificateInspection and DataLoadingProtocol are the public protocols that should be implemented in every inspector.
   
      public protocol CertificateInspection {
         func validateCertificate(_ certificate: CertificationProtocol) -> ValidityState
      }

      public protocol DataLoadingProtocol {
         var lastUpdate: Date { get }
         var downloadedDataHasExpired: Bool { get }
         
         func prepareLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler)
         func updateLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler)
      }
      
      Verification center conforms to DataLoadingProtocol
      

   ApplicableInspector is a struct:
   
      public struct ApplicableInspector {
         public let type: CertificateType
         public let inspector: CertificateInspecting & DataLoadingProtocol
      }

   
#### Applicable Certificate types

 These methods allow us to quickly determine the type of certificate in QR without creating a certificate.
   
      public let applicableCertificateTypes: [CertificateType]
      
      public static func isApplicableFormatForVerification(payload: String) -> Bool
      
      public static func isApplicableDCCFormat(payload: String) -> Bool
      
      public static func isApplicableSHCFormat(payload: String) -> Bool

#### Methods whether verification can be applied

 These methods allow you to determine if the certificate is valid.
   
      public func isVerifiableCertificateType(_ type: CertificateType) -> Bool

      public func validateCertificate(_ multiTypeCertificate: MultiTypeCertificate) -> ValidityState?
   
#### Validation result

   Validity State is a struct that incapsulates big range of validation results, limitations and errors.
   
      public struct ValidityState {
         
         public let technicalValidity: VerificationResult
         
         public let issuerValidity: VerificationResult
         
         public let destinationValidity: VerificationResult
         
         public let travalerValidity: VerificationResult
         
         public let allRulesValidity: VerificationResult
         
         ----
      }
    
#### What are MultiType Certificates

   Multi type certificate object is designed for holding certificate of all applicable types in a digitalCertificate field.
   The certificate must comply with the protocol CertificationProtocol.
      
      public class MultiTypeCertificate {
         
         public let certificateType: CertificateType
         
         public var digitalCertificate: CertificationProtocol?
         
         public var firstName: String 
         
         ----
         
      }


## Examples

  Use of Verification Center:
      
      let verificationCenter = DGCVerificationCenter.shared
  
      
      if verificationCenter.downloadedDataHasExpired {
           // process loading new data
      }

  Load stored data or download data from server side:
  
      verificationCenter.prepareStoredData(appType: .verifier) { result in
            if case let .failure(error) = result {
                // process error
            } else if case .noData = result {
                // process nodata
            } else {
                // process success
            }
      }
      
 Download data from server side:
 
      verificationCenter.updateStoredData(appType: .verifier) { result in
            if case let .failure(error) = result {
                // process error
            } else {
               // process success
            }
      }
      
 Check if the payload is applicable to DCC or to SHC Format: 
 
      if DGCVerificationCenter.shared.isApplicableDCCFormat(payload: barcodeString) {
         // sth
      } else if DGCVerificationCenter.shared.isApplicableSHCFormat(payload: barcodeString) {
         // sth
      }
      
Validating of the certificate:
 
      if let validityState = verificationCenter.validateCertificate(certificate) {
            if validityState.isVerificationFailed {
               //process verification error
               
            } else {
               //process verification success
            }
        }
  
## How to expand the verification of new certificate standards

A new inspector needs to be added to expand the verification. The package of that inspector should be connected to the Verification Center. 
So, to create new inspector needs steps:
   1. Create new inspector package from template and connect to the Verification Center.
   2. In Verification Center add new type of certificate and fill in template places in a root class DGCAVerificationCenter and MultiTypeCertificate
   3. Add some general methods to the core library if needs. (They will need for applicable methods in the Verification Center)

### Prerequisites

Create an new inspection module and add it to the imports by importing it [here](https://github.com/eu-digital-green-certificates/dgca-verification-center-ios/blob/main/Sources/DGCVerificationCenter/DGCVerificationCenter.swift#L66)

## Support and feedback

The following channels are available for discussions, feedback, and support requests:

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **Issues**    | <a href="/../../issues" title="Open Issues"><img src="https://img.shields.io/github/issues/eu-digital-green-certificates/dgc-certlogic-android?style=flat"></a>  |
| **Other requests**    | <a href="mailto:opensource@telekom.de" title="Email DGC Team"><img src="https://img.shields.io/badge/email-DGC%20team-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |

## How to contribute  

Contribution and feedback is encouraged and always welcome. For more information about how to contribute, the project structure, 
as well as additional contribution information, see our [Contribution Guidelines](./CONTRIBUTING.md). By participating in this 
project, you agree to abide by its [Code of Conduct](./CODE_OF_CONDUCT.md) at all times.

## Contributors  

Our commitment to open source means that we are enabling - in fact encouraging - all interested parties to contribute and become part of its developer community.

## Licensing

Copyright (C) 2021 T-Systems International GmbH and all other contributors

Licensed under the **Apache License, Version 2.0** (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at https://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" 
BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the [LICENSE](./LICENSE) for the specific 
language governing permissions and limitations under the License.
