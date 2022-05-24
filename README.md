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

This module encapsulates the available modules for the QR verification process (e.g. DCC, SHC). Available modules included DCC and SHC inspectors and Core module. The core module contains the services used in the SDK module and in the inspectors.

The verification process for new types of certificates can be extended by creating new modules of inspectors. Inspectors are independent and may be included or excluded at any time.

## Development
To start using the Verification SDK it is enough to connect this package to the app or to another module.

### Components

The SDK is 4 layers softvare.
This Verification Center module is on a top layer. The properties and methods in this layer are the API.
On the next layer are row of verification inspectors. Now SDK includes two DCC and SHC inspectors.
The third layer contains Core library where are incapsulated common servises such as encryption, sighning. zipping, etc.
The auxiliary layer contains auxiliary modules that is used by second and thitd layers. There are JSON and Cert Logic, Bloom and Hash filters and row of third part libraries.

#### DGCVerificationCenter is a Root object in API

The root object is DGCVerificationCenter

      public class DGCVerificationCenter

That object is responsible for verification of scanned and saved certificates. 
The certificate has its own specific type and can be verified depend on implemented inspectors

      public enum CertificateType: String { case unknown, dcc, icao, divoc, shc }

The CertificateType contains existed types of certificates (.dcc, .shc) and may contain non-existed types (.icao) that arenot added yet.

#### Initialization of DGCVerificationCenter

      public init()
 Initializes Verification Center with all available types

      public init?(types: [CertificateType])
 Initializes Verification Center with listed available types

      public init?(type: CertificateType)
 Initializes Verification Center with pointed available type
   
 If in initialization pointed non-available types they will not be included to the Center
 If there are listed no available types the Verification Center will not be created

#### Inspectors 

      public final class DCCInspection: CertificateInspection
   
      public final class DGCSHInspection: CertificateInspection
   
   Inspectors are classes that imported from Inspectors' modeles and can be included to or excluded from the Verification Center.
   
      public var dccInspector: CertificateInspection & DataLoadingProtocol?
      public var icaoInspector: CertificateInspection & DataLoadingProtocol?
      public var shcInspector: CertificateInspection & DataLoadingProtocol?
    
      public var applicableInspectors: [ApplicableInspector] = []

   The CertificateInspection and DataLoadingProtocol are the public protocol that implemens every inspector.
   
      public protocol CertificateInspection {
         func validateCertificate(_ certificate: CertificationProtocol) -> ValidityState
      }

      public protocol DataLoadingProtocol {
         var lastUpdate: Date { get }
         var downloadedDataHasExpired: Bool { get }
         
         func prepareLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler)
         func updateLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler)
      }

   ApplicableInspector is a struct:
   
      public struct ApplicableInspector {
         public let type: CertificateType
         public let inspector: CertificateInspection
      }

   
### Applicable types of certificates

 These methods allow you to quickly determine the type of certificate in QR without creating a certificate.
   
      public let applicableCertificateTypes: [CertificateType]

      public static func isApplicableFormatForVerification(payload: String) -> Bool
   
      public static func isApplicableDCCFormat(payload: String) -> Bool
   
      public static func isApplicableSHCFormat(payload: String) -> Bool

#### Veryfication of certificates

 These methods allow you to determine if the certificate is valid.
   
      public var verificationInspectior: CertificateInspection?
   
      public func isVerifiableCertificateType(_ type: CertificateType) -> Bool

      public func validateCertificate(_ multiTypeCertificate: MultiTypeCertificate) -> ValidityState?
   
#### Validity State

      public struct ValidityState {
    
         public let technicalValidity: VerificationResult
    
         public let issuerValidity: VerificationResult
    
         public let destinationValidity: VerificationResult
    
         public let travalerValidity: VerificationResult
    
         public let allRulesValidity: VerificationResult
    
         public let validityFailures: [String]
    
         public var infoSection: InfoSection?
    
         public let isRevoked: Bool
    
         public var isVerificationFailed: Bool
      }
    
#### MultiTypeCertificate

   Multi type certificate object is designed for holding certificate all applicable types in digitalCertificate field.
      
      public class MultiTypeCertificate {

         public let certificateType: CertificateType
    
         public let ruleCountryCode: String?
    
         public let scannedDate: Date
    
         public var storedTan: String?
    
         public var digitalCertificate: CertificationProtocol?
      
         public var firstName: String 
      
         public var firstNameStandardized: String? 
      
         public var lastName: String 
      
         public var lastNameStandardized: String 
      
         public var fullName: String 
      
         public var certTypeString: String
      
         public var isRevoked: Bool 
      
         public var isUntrusted: Bool 
      
         public var certHash: String 
      
         public var uvciHash: Data? 
      
         public var countryCodeUvciHash: Data?
      
         public var signatureHash: Data? 
      
         public var body: JSON? 
      
         public var certificateCreationDate: String 
      
      }

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
