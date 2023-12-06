//
//  Controller.swift
//  TossLogin
//
//  Created by 권현정 on 2023/08/17.
//

import Foundation
import UIKit
import TossFoundation

public final class TossLoginController {
    
    public static let shared: TossLoginController = .init()

    private let loginURLPrefix = "\(TossURL.serviceScheme)://oauth2"
    private var loginCompletion: ((URL) -> Void)?

    public func isCallbackURL(_ url: URL) -> Bool {
        guard let callbackURLPrefix else { return false }
        return url.absoluteString.hasPrefix(callbackURLPrefix)
    }
    
    public func handleOpenUrl(_ url: URL) -> Bool {
        guard isCallbackURL(url), let loginCompletion else { return false }
        loginCompletion(url)
        return false
    }
    
    public var isLoginAvailable: Bool {
        guard let url = URL(string: TossSDK.shared.tossScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    public func login(
        policy: String? = nil,
        completion: @escaping ((TossLoginResult) -> Void)
    ) {
        loginCompletion = { callbackURL in
            let result = callbackURL.toResult
            TossLog.shared.print(message: result.toLogMessage)
            completion(result)
        }
        
        guard let loginURL = generateLoginURL(with: policy) else {
            TossLog.shared.print(message: "Login url is nil.")
            completion(.error(InternalError.failToGenerateURL))
            return
        }
        UIApplication.shared.open(loginURL)
    }
    
    public func moveToAppstore() {
        guard let url = URL(string: TossURL.appStoreURLString) else {
            TossLog.shared.print(message: "App store url is nil.")
            return
        }
        
        UIApplication.shared.open(url)
    }
}

private extension TossLoginController {
    var callbackURLPrefix: String? {
        do {
            let scheme = try TossSDK.shared.redirectScheme
            return scheme + "oauth"
        } catch {
            TossLog.shared.error(error)
            return nil
        }
    }
    
    func generateLoginURL(with policy: String?) -> URL? {
        guard var components = URLComponents(string: loginURLPrefix) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "clientId", value: TossSDK.shared.appKey),
            URLQueryItem(name: "redirect_uri", value: callbackURLPrefix),
            URLQueryItem(name: "sdk_version", value: TossSDK.shared.version),
            URLQueryItem(name: "device", value: "ios-\(Constants.osVersion)"),
            URLQueryItem(name: "version", value: Constants.appVersion),
            URLQueryItem(name: "origin", value: Constants.bundleID)
        ]

        if let policy {
            components.queryItems?.append(URLQueryItem(name: "oauth_policy", value: policy))
        }

        return components.url
    }
}

// MARK: - extensions
private extension URL {
    var toResult: TossLoginResult {
        let queryItems = URLComponents(string: self.absoluteString)?.queryItems?.reduce(into: [String: Any](), {
            $0[$1.name] = $1.value
        })
                
        if let authCode = queryItems?["code"] as? String, !authCode.isEmpty {
            return .success(authCode: authCode)
        } else {
            let errorCode = queryItems?["error"] as? String ?? "unknown"
            let errorMessage = queryItems?["error_description"] as? String ?? "unknown"
            let errorURLString = queryItems?["error_uri"] as? String

            if errorCode == "cancelled" {
                return .cancelled
            } else {
                let url: URL? = {
                    if let errorURLString {
                        return URL(string: errorURLString)
                    } else {
                        return nil
                    }
                }()
                return .error(LoginError(code: errorCode, message: errorMessage, url: url))
            }
        }
    }
}

private extension TossLoginResult {
    var toLogMessage: String {
        switch self {
        case let .success(authCode):
            return "success with code: \(authCode)"
        case let .error(error):
            return "error message: \(error.message)"
        case .cancelled:
            return "cancelled"
        }
    }
}
