//
//  SessionHelper.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 28/02/2021.
//

import Foundation
import Alamofire

/// Helper class to for session configuration.
/// Use for common config(security policies for example) for session of API calls.
class SessionHelper {
    let sessionManager: Alamofire.Session = {
        Alamofire.Session()
    }()
    static let shared = SessionHelper()
}
