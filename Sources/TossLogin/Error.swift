//
//  Error.swift
//  TossLogin
//
//  Created by 권현정 on 2023/08/21.
//

import Foundation
import TossFoundation

struct LoginError: TossSDKError {
    let code: String
    let message: String
    let url: URL?
    
    init(code: String = "unknown", message: String, url: URL?) {
        self.code = code
        self.message = message
        self.url = url
    }
}
