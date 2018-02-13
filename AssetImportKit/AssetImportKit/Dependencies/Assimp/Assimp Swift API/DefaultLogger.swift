//
//  DefaultLogger.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import scene
import postprocess

/** default name of logfile */
public let ASSIMP_DEFAULT_LOG_NAME = "AssimpLog.txt"

public func AI_PRIMITIVE_TYPE_FOR_N_INDICES(n: UInt32) -> aiPrimitiveType { return (n) > 3 ? aiPrimitiveType_POLYGON : (aiPrimitiveType)(UInt32(1) << ((n)-1)) }
