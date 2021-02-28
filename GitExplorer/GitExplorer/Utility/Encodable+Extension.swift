//
//  Encodable+Extension.swift
//  GitExplorer
//
//  Created by Mandha Smitha S on 01/03/2021.
//

import Foundation

extension Encodable {
    /// Converts Encodable Model into a dictionary.
    /// - Parameter encoder: `JSONEncoder` Encodes instances to json type.
    /// - Throws: throws typemismatch if the data is not in the same structure as self.
    /// - Returns: Dictionary converted from an encodable object.
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [],
                                                debugDescription: "Deserialized object is not a dictionary.")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
