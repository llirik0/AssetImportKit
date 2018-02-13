//
//  Postprocess.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import scene
import postprocess

// ---------------------------------------------------------------------------------------
/** aiProcess_ConvertToLeftHanded
 *  Shortcut flag for Direct3D-based applications.
 *
 *  Supersedes the #aiProcess_MakeLeftHanded and #aiProcess_FlipUVs and
 *  #aiProcess_FlipWindingOrder flags.
 *  The output data matches Direct3D's conventions: left-handed geometry, upper-left
 *  origin for UV coordinates and finally clockwise face order, suitable for CCW culling.
 */
public let aiProcess_ConvertToLeftHanded = UInt32( aiProcess_MakeLeftHanded.rawValue |
    aiProcess_FlipUVs.rawValue |
    aiProcess_FlipWindingOrder.rawValue |
    0 )

// ---------------------------------------------------------------------------------------
/** aiProcessPreset_TargetRealtimeUse_Fast
 *  Default postprocess configuration optimizing the data for real-time rendering.
 *
 *  Applications would want to use this preset to load models on end-user PCs,
 *  maybe for direct use in game.
 *
 * If you're using DirectX, don't forget to combine this value with
 * the #aiProcess_ConvertToLeftHanded step. If you don't support UV transformations
 * in your application apply the #aiProcess_TransformUVCoords step, too.
 *  @note Please take the time to read the docs for the steps enabled by this preset.
 *  Some of them offer further configurable properties, while some of them might not be of
 *  use for you so it might be better to not specify them.
 */
public let aiProcessPreset_TargetRealtime_Fast = UInt32( aiProcess_CalcTangentSpace.rawValue |
    aiProcess_GenNormals.rawValue |
    aiProcess_JoinIdenticalVertices.rawValue |
    aiProcess_Triangulate.rawValue |
    aiProcess_GenUVCoords.rawValue |
    aiProcess_SortByPType.rawValue |
    0 )

// ---------------------------------------------------------------------------------------
/** aiProcessPreset_TargetRealtime_Quality
 *  Default postprocess configuration optimizing the data for real-time rendering.
 *
 *  Unlike #aiProcessPreset_TargetRealtime_Fast, this configuration
 *  performs some extra optimizations to improve rendering speed and
 *  to minimize memory usage. It could be a good choice for a level editor
 *  environment where import speed is not so important.
 *
 *  If you're using DirectX, don't forget to combine this value with
 *  the #aiProcess_ConvertToLeftHanded step. If you don't support UV transformations
 *  in your application apply the #aiProcess_TransformUVCoords step, too.
 *  @note Please take the time to read the docs for the steps enabled by this preset.
 *  Some of them offer further configurable properties, while some of them might not be
 *  of use for you so it might be better to not specify them.
 */
public let aiProcessPreset_TargetRealtime_Quality = UInt32( aiProcess_CalcTangentSpace.rawValue |
    aiProcess_GenSmoothNormals.rawValue |
    aiProcess_JoinIdenticalVertices.rawValue |
    aiProcess_ImproveCacheLocality.rawValue |
    aiProcess_LimitBoneWeights.rawValue |
    aiProcess_RemoveRedundantMaterials.rawValue |
    aiProcess_SplitLargeMeshes.rawValue |
    aiProcess_Triangulate.rawValue |
    aiProcess_GenUVCoords.rawValue |
    aiProcess_SortByPType.rawValue |
    aiProcess_FindDegenerates.rawValue |
    aiProcess_FindInvalidData.rawValue |
    0 )

// ---------------------------------------------------------------------------------------
/** aiProcessPreset_TargetRealtime_MaxQuality
 *  Default postprocess configuration optimizing the data for real-time rendering.
 *
 *  This preset enables almost every optimization step to achieve perfectly
 *  optimized data. It's your choice for level editor environments where import speed
 *  is not important.
 *
 *  If you're using DirectX, don't forget to combine this value with
 *  the #aiProcess_ConvertToLeftHanded step. If you don't support UV transformations
 *  in your application, apply the #aiProcess_TransformUVCoords step, too.
 *  @note Please take the time to read the docs for the steps enabled by this preset.
 *  Some of them offer further configurable properties, while some of them might not be
 *  of use for you so it might be better to not specify them.
 */
public let aiProcessPreset_TargetRealtime_MaxQuality = UInt32( aiProcessPreset_TargetRealtime_Quality |
    aiProcess_FindInstances.rawValue |
    aiProcess_ValidateDataStructure.rawValue |
    aiProcess_OptimizeMeshes.rawValue |
    0 )
