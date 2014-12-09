//
//  KVCVerification.swift
//  Avalon
//
//  Created by Colin Eberhardt on 12/11/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

public class KVCVerification {
  
  // determines the type of the destination property
  class func destinationPropertyType(currentType: AnyClass, propertyPath: String) -> String? {
    
    var propertiesCount : CUnsignedInt = 0
    let propertiesInAClass = class_copyPropertyList(currentType, &propertiesCount)
    for var i = 0; i < Int(propertiesCount); i++ {
      let property = propertiesInAClass[i]
      let propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)
      if propName! == propertyPath {
        let propAttributes = property_getAttributes(property)
        let typeString = String(UTF8String: propAttributes) // e.g. T@"NSString",C,N
        let typeComponents = typeString!.componentsSeparatedByString(",")
        return typeComponents[0]
      }
    }
    
    if let superclass: AnyClass = currentType.superclass() {
      return destinationPropertyType(superclass, propertyPath: propertyPath)
    } else {
      return nil
    }
  }
  
  public class func verifyCanSetVale(optionalValue: AnyObject?, propertyPath: String, destination: NSObject) -> String? {
    
    // a map of destination property types to valid value types
    let permittedTypeMap = [
      "T@\"NSString\"" : ["Swift._NSContiguousString", "__NSCFString"],
      "Tf" : ["__NSCFNumber"],
      "Tq" : ["__NSCFNumber"],
      "T@\"UIColor\"" : ["UICachedDeviceRGBColor"]
    ]
    
    if let value: AnyObject = optionalValue {
      // determine the type of the value being used to set the destination property
      let valueType = NSStringFromClass(value.dynamicType)
      
      // determine the destination property type
      if let destinationPropertyType = self.destinationPropertyType(destination.dynamicType, propertyPath: propertyPath) {
        let warningMessage = "WARNING: The value \(value) of type \(valueType) appears to be incompatible with the destination property \(propertyPath) which is of type \(destinationPropertyType)"
        
        if let permittedValueTypes = permittedTypeMap[destinationPropertyType] {
          
          if !contains(permittedValueTypes, valueType) {
            return warningMessage
          }
          
        } else {
          return warningMessage
        }
      } else {
        return "WARNING: Cannot determine the type of the property with the given path \(propertyPath)"
      }
    }
    return nil
  }

}