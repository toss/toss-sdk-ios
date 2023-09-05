//
//  Result.swift
//  TossLogin
//
//  Created by 권현정 on 2023/08/21.
//

import TossFoundation

public enum TossLoginResult {
    case success(authCode: String)
    case error(TossSDKError)
    case cancelled
}
