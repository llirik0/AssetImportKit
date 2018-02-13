//
//  Scene.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import scene
import postprocess

// -------------------------------------------------------------------------------
/** AI_SCENE_FLAGS_INCOMPLETE
 * Specifies that the scene data structure that was imported is not complete.
 * This flag bypasses some internal validations and allows the import
 * of animation skeletons, material libraries or camera animation paths
 * using Assimp. Most applications won't support such data.
 */
public let AI_SCENE_FLAGS_INCOMPLETE = UInt32(0x1)

/** AI_SCENE_FLAGS_VALIDATED
 * This flag is set by the validation postprocess-step (aiPostProcess_ValidateDS)
 * if the validation is successful. In a validated scene you can be sure that
 * any cross references in the data structure (e.g. vertex indices) are valid.
 */
public let AI_SCENE_FLAGS_VALIDATED = UInt32(0x2)

/** AI_SCENE_FLAGS_VALIDATION_WARNING
 * This flag is set by the validation postprocess-step (aiPostProcess_ValidateDS)
 * if the validation is successful but some issues have been found.
 * This can for example mean that a texture that does not exist is referenced
 * by a material or that the bone weights for a vertex don't sum to 1.0 ... .
 * In most cases you should still be able to use the import. This flag could
 * be useful for applications which don't capture Assimp's log output.
 */
public let AI_SCENE_FLAGS_VALIDATION_WARNING = UInt32(0x4)

/** AI_SCENE_FLAGS_NON_VERBOSE_FORMAT
 * This flag is currently only set by the aiProcess_JoinIdenticalVertices step.
 * It indicates that the vertices of the output meshes aren't in the internal
 * verbose format anymore. In the verbose format all vertices are unique,
 * no vertex is ever referenced by more than one face.
 */
public let AI_SCENE_FLAGS_NON_VERBOSE_FORMAT = UInt32(0x8)

/** AI_SCENE_FLAGS_TERRAIN
 * Denotes pure height-map terrain data. Pure terrains usually consist of quads,
 * sometimes triangles, in a regular grid. The x,y coordinates of all vertex
 * positions refer to the x,y coordinates on the terrain height map, the z-axis
 * stores the elevation at a specific point.
 *
 * TER (Terragen) and HMP (3D Game Studio) are height map formats.
 * @note Assimp is probably not the best choice for loading *huge* terrains -
 * fully triangulated data takes extremely much free store and should be avoided
 * as long as possible (typically you'll do the triangulation when you actually
 * need to render it).
 */
public let AI_SCENE_FLAGS_TERRAIN = UInt32(0x10)
