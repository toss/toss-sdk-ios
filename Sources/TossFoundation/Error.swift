//
//  Error.swift
//  TossFoundation
//
//  Created by 권현정 on 2023/08/17.
//

import Foundation

public protocol TossSDKError: Error {
    var code: String { get }
    var message: String { get }
}

public enum InternalError: Int, TossSDKError {
    case notExistsAppKey = -1
    case failToGenerateURL = -2
    
    public var code: String { "\(rawValue)" }
    
    public var message: String {
        switch self {
        case .notExistsAppKey:
            return "App key is not set. Use `TossSDK.initSDK(appKey:)` to set up."
        case .failToGenerateURL:
            return "URL generation failed."
        }
    }
}
