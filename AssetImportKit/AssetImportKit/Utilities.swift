//
//  Utils.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import cimport

public func tupleOfInt8sToString( _ tupleOfInt8s:Any ) -> NSString {
    var result:String? = nil
    let mirror = Mirror(reflecting: tupleOfInt8s)
    
    for child in mirror.children {
        guard let characterValue = child.value as? Int8, characterValue != 0 else {
            break
        }
        
        if result == nil {
            result = String()
        }
        result?.append(Character(UnicodeScalar(UInt8(abs(characterValue)))))
    }
    
    return (result ?? "") as NSString
}

public extension aiString {
    
    public func stringValue() -> String {
        
        var arrayOfInt8: [Int8] {
            var tmp = self
            return [Int8](UnsafeBufferPointer(start: &tmp.data.0, count: MemoryLayout.size(ofValue: tmp.data)))
        }
        
        
        return String(utf8String: arrayOfInt8) ?? ""
    }
    
}

