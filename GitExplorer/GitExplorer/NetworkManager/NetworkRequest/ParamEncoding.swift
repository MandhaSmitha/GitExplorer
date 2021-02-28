//
//  ParamEncoding.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 27/02/2021.
//

import Foundation
import Alamofire

/// Wrapper for Alamofire encoding.
/// Use ParamEncoding instead of ParameterEncoding to avoid changes throughout the app in case of updates to Alamofire.
enum ParamEncoding {
    case urlEncoding
    case jsonEncoding
    
    var value: ParameterEncoding {
        switch self {
        case .urlEncoding:
            return URLEncoding.default
        case .jsonEncoding:
            return JSONEncoding.default
        }
    }
}
