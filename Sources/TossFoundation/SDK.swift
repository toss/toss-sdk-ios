//
//  SDK.swift
//  TossFoundation
//
//  Created by 권현정 on 2023/08/17.
//

import Foundation

public final class TossSDK {
    
    public static let shared: TossSDK = TossSDK()
    
    var enablesLogging: Bool = false
    
    public let version: String = "1.0.0"
    public var appKey: String?
    
    private init() {}
    
    public func initSDK(
        appKey: String,
        enablesLogging: Bool = false
    ) {
        self.appKey = appKey
        self.enablesLogging = enablesLogging
    }
    
    public var tossScheme: String = "\(TossURL.scheme)://"
    
    public var redirectScheme: String {
        get throws {
            guard let appKey else {
                throw InternalError.notExistsAppKey
            }
            
            return "\(TossURL.redirectScheme)\(appKey)://"
        }
    }
}
