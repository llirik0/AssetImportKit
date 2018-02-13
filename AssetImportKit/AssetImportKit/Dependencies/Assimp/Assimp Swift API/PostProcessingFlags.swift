//
//  PostProcessingFlags.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import scene
import postprocess

// -----------------------------------------------------------------------------
/** AssetImporter_ProcessPreset_TargetRealtimeUse_Fast
 *  @brief Default postprocess configuration optimizing the data for real-time
 *  rendering.
 *
 *  Applications would want to use this preset to load models on end-user PCs,
 *  maybe for direct use in game.
 *
 *  If you don't support UV transformations in your application apply the
 *  AssetImporter_Process_TransformUVCoords step, too.
 *  @note Please take the time to read the docs for the steps enabled by this
 *  preset.
 *  Some of them offer further configurable properties, while some of them might
 *   not be of use for you so it might be better to not specify them.
 */
public let AssetImporter_ProcessPreset_TargetRealtime_Fast = UInt32( AssetImporterPostProcessSteps.process_CalcTangentSpace.rawValue |
    AssetImporterPostProcessSteps.process_GenNormals.rawValue |
    AssetImporterPostProcessSteps.joinIdenticalVertices.rawValue |
    AssetImporterPostProcessSteps.process_Triangulate.rawValue |
    AssetImporterPostProcessSteps.process_GenUVCoords.rawValue |
    AssetImporterPostProcessSteps.process_SortByPType.rawValue |
    0 )

// -----------------------------------------------------------------------------
/** AssetImporter_ProcessPreset_TargetRealtime_Quality
 *  Default postprocess configuration optimizing the data for real-time
 *  rendering.
 *
 *  Unlike AssetImporter_ProcessPreset_TargetRealtime_Fast, this configuration
 *  performs some extra optimizations to improve rendering speed and
 *  to minimize memory usage. It could be a good choice for a level editor
 *  environment where import speed is not so important.
 *
 *  If you don't support UV transformations
 *  in your application apply the AssetImporter_Process_TransformUVCoords step, too.
 *  @note Please take the time to read the docs for the steps enabled by this
 *  preset.
 *  Some of them offer further configurable properties, while some of them might
 *  not be of use for you so it might be better to not specify them.
 */
public let AssetImporter_ProcessPreset_TargetRealtime_Quality = UInt32( AssetImporterPostProcessSteps.process_CalcTangentSpace.rawValue |
    AssetImporterPostProcessSteps.process_GenSmoothNormals.rawValue |
    AssetImporterPostProcessSteps.joinIdenticalVertices.rawValue |
    AssetImporterPostProcessSteps.process_ImproveCacheLocality.rawValue |
    AssetImporterPostProcessSteps.process_LimitBoneWeights.rawValue |
    AssetImporterPostProcessSteps.process_RemoveRedundantMaterials.rawValue | AssetImporterPostProcessSteps.process_SplitLargeMeshes.rawValue |
    AssetImporterPostProcessSteps.process_Triangulate.rawValue |
    AssetImporterPostProcessSteps.process_GenUVCoords.rawValue |
    AssetImporterPostProcessSteps.process_SortByPType.rawValue |
    AssetImporterPostProcessSteps.process_FindDegenerates.rawValue |
    AssetImporterPostProcessSteps.process_FindInvalidData.rawValue |
    0 )


// ------------------------------------------------------------------------------
/** AssetImporter_ProcessPreset_TargetRealtime_MaxQuality
 *  Default postprocess configuration optimizing the data for real-time
 *  rendering.
 *
 *  This preset enables almost every optimization step to achieve perfectly
 *  optimized data. It's your choice for level editor environments where import
 *  speed is not important.
 *
 *  If you're using DirectX, don't forget to combine this value with the
 *  AssetImporter_Process_ConvertToLeftHanded step. If you don't support UV
 *  transformations in your application, apply the
 *  AssetImporter_Process_TransformUVCoords step, too. @note Please take the time to
 *  read the docs for the steps enabled by this preset. Some of them offer
 *  further configurable properties, while some of them might not be of use for
 *  you so it might be better to not specify them.
 */
public let AssetImporter_ProcessPreset_TargetRealtime_MaxQuality = UInt32( AssetImporter_ProcessPreset_TargetRealtime_Quality |
    AssetImporterPostProcessSteps.process_FindInstances.rawValue |
    AssetImporterPostProcessSteps.process_ValidateDataStructure.rawValue |
    AssetImporterPostProcessSteps.process_OptimizeMeshes.rawValue |
    0 )
