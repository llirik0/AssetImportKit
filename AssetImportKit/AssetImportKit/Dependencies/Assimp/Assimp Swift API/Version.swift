//
//  Version.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import scene
import postprocess

// Assimp was compiled as a shared object (Windows: DLL)
public let ASSIMP_CFLAGS_SHARED = UInt32(0x1)
// Assimp was compiled against STLport
public let ASSIMP_CFLAGS_STLPORT = UInt32(0x2)
// Assimp was compiled as a debug build
public let ASSIMP_CFLAGS_DEBUG = UInt32(0x4)

// Assimp was compiled with ASSIMP_BUILD_BOOST_WORKAROUND defined
public let ASSIMP_CFLAGS_NOBOOST = UInt32(0x8)
// Assimp was compiled with ASSIMP_BUILD_SINGLETHREADED defined
public let ASSIMP_CFLAGS_SINGLETHREADED = UInt32(0x10)
