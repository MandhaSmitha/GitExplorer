//
//  FileUtility.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation

class FileUtility {
    /// Read data from a local file and return Data.
    /// - Parameters:
    ///   - bundle: File bundle. Defaults to main bundle.
    ///   - name: Name of the file holding data.
    ///   - type: filetype.
    /// - Returns: Return contents of the file converted to `Data`.
    func getData(bundle: Bundle = Bundle.main, fromFile name: String, type: String) -> Data? {
        do {
            if let bundlePath = bundle.path(forResource: name, ofType: type),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            debugPrint(error)
        }
        return nil
    }
    
    /// Reads the contents of a file and returns the specified Codable model.
    /// - Parameters:
    ///   - bundle: File bundle. Defaults to main bundle.
    ///   - name: Name of the file holding data.
    ///   - type: filetype.
    ///   - mapToModel: Codable model to be mapped to.
    /// - Returns: Contents of the file converted to the `Codable` model of type `T`.
    func getCodable<T: Codable>(bundle: Bundle = Bundle.main, fromFile name: String, type: String, mapToModel: T.Type) -> T? {
        guard let jsonData = getData(bundle: bundle, fromFile: name, type: type) else {
            return nil
        }
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            print("decode error")
        }
        return nil
    }
}
