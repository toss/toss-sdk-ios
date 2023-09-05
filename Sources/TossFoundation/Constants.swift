//
//  Constants.swift
//  
//
//  Created by 권현정 on 2023/08/29.
//

import Foundation
import UIKit

public enum Constants {
    static public var appVersion: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }
    
    static public var osVersion: String {
        UIDevice.current.systemVersion
    }
    
    static public var bundleID: String {
        Bundle.main.bundleIdentifier ?? ""
    }
}
