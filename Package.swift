// swift-tools-version:5.0
//
//  Package.swift
//

import PackageDescription

let package = Package(name: "DPTagTextView",
                      platforms: [.iOS(.v10)],
                      products: [.library(name: "DPTagTextView",
                                          targets: ["DPTagTextView"])],
                      targets: [.target(name: "DPTagTextView",
                                        path: "DPTagTextView/DPTagTextView/DPTagTextView",
                                        publicHeadersPath: "")],
                      swiftLanguageVersions: [.v5])
