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

The SDK is 4 layers softvare.
This Verification module is on a top layer. The properties and methods in this layer are the API.
On the next layer are row of verification inspectors. Now SDK includes two DCC and SHC inspectors.
The third layer contains Core library where are incapsulated common servises such as encryption, sighning. zipping, etc.
The auxiliary layer contains auxiliary modules that is used by second and thitd layers. There are JSON and Cert Logic, Bloom and Hash filters and row of third part libraries.

## API 
   public enum CertificateType: String {case unknown, dcc, icao, divoc, shc }

### Initialization

   public init()

   public init?(types: [CertificateType])

   public init?(type: CertificateType)

### Applicable types

   public let applicableCertificateTypes: [CertificateType]

   public static func isApplicableFormat(payload: String) -> Bool
   
   ### Veryfication
   
   public var verificationInspectior: CertificateInspection?
   
   public func isVerifiableCertificateType(_ type: CertificateType) -> Bool


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
