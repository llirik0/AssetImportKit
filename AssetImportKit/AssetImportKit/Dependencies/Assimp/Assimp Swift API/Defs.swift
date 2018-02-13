//
//  Defs.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import scene
import postprocess

/* This is PI. Hi PI. */
public let AI_MATH_PI = 3.141592653589793238462643383279
public let AI_MATH_TWO_PI = AI_MATH_PI * 2.0
public let AI_MATH_HALF_PI = AI_MATH_PI * 0.5

/* And this is to avoid endless casts to float */
public let AI_MATH_PI_F = 3.1415926538
public let AI_MATH_TWO_PI_F = AI_MATH_PI_F * 2.0
public let AI_MATH_HALF_PI_F = AI_MATH_PI_F * 0.5

/* Tiny macro to convert from radians to degrees and back */
public func AI_DEG_TO_RAD(_ x: UInt32) -> UInt32 { return x * UInt32(0.0174532925) }
public func AI_RAD_TO_DEG(_ x: UInt32) -> UInt32 { return x * UInt32(57.2957795) }
