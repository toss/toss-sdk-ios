//
//  Log.swift
//  TossFoundation
//
//  Created by 권현정 on 2023/08/17.
//

import Foundation

public class TossLog {
    
    public static let shared: TossLog = .init()
    
    private let liveLogMaxCount: Int
    public var liveLogs: [String] = []
    
    public init(liveLogMaxCount: Int = 30) {
        self.liveLogMaxCount = liveLogMaxCount
    }
    
    public func print(
        message: String,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        let filename = filename(file: file, function: function)
        let message = "TossSDKLog - \(filename) \(line)L | \(message)"
        
        #if DEBUG
        Swift.print(message)
        #else
        guard TossSDK.shared.enablesLogging else { return }
        if liveLogs.count >= liveLogMaxCount {
            liveLogs.removeFirst()
        }
        
        liveLogs.append(message)
        #endif
    }
    
    public func error(
        _ error: Error,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        let filename = filename(file: file, function: function)
        let errorMessage: String = {
            if let sdkError = error as? TossSDKError {
                return sdkError.message
            } else {
                return error.localizedDescription
            }
        }()
        let message = "TossSDKError - \(filename) \(line)L | \(errorMessage)"
        
        #if DEBUG
        fatalError(message)
        #else
        guard TossSDK.shared.enablesLogging else { return }
        if liveLogs.count >= liveLogMaxCount {
            liveLogs.removeFirst()
        }
        
        liveLogs.append(message)
        #endif
    }
}

private extension TossLog {
    func filename(file: String, function: String) -> String {
        if let filename = URL(string: file)?.lastPathComponent.components(separatedBy: ".").first, !filename.isEmpty {
            return "\(filename).\(function)"
        } else {
            return function
        }
    }
}
