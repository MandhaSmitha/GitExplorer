//
//  HttpMethod.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 27/02/2021.
//

import Foundation
import Alamofire

/// Wrapper for Alamofire HTTPMethod.
/// Use HttpMethod instead of HTTPMethod to avoid changes throughout the app in case of updates to Alamofire.
enum HttpMethod {
    case get
    case post
    case head
    case put
    case delete
    case patch
    
    var value: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .head:
            return .head
        case .put:
            return .put
        case .delete:
            return .delete
        case .patch:
            return .patch
        }
    }
}
