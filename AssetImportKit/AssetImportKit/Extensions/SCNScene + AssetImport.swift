//
//  SCNScene+AssetImport.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import SceneKit
import PostProcessingFlags

/**
 A scenekit SCNScene category to import scenes using the assimp library.
 */
public extension SCNScene {
    
    // MARK: - Loading scenes using assimp
    
    /**
     @name Loading scenes using assimp
     */
    /**
     Returns the array of file extensions for all the supported formats.
     
     @return The array of supported file extensions
     */
    public class func allowedFileExtensions() -> [String]? {
        
        if let extsFile = Bundle(for: AssetImporterScene.self).path(forResource: "valid-extensions", ofType: "txt") {
            do {
                let extsFileContents = try String(contentsOfFile: extsFile, encoding: .utf8)
                
                if let validExts = (extsFileContents.components(separatedBy: CharacterSet.whitespacesAndNewlines) as NSArray?)?.filtered(using: NSPredicate(format: "self != \"\"")) as? [String] {
                    return validExts
                } else {
                    return nil
                }
            } catch {
                print("The file could not be loaded")
            }
        }
        
        return nil
    }
    
    /**
     Returns a Boolean value that indicates whether the SCNAssimpScene class can
     read asset data from files with the specified extension.
     
     @param extension The filename extension identifying an asset file format.
     @return YES if the SCNAssimpScene class can read asset data from files with
     the specified extension; otherwise, NO.
     */
    public class func canImportFileExtension(_ extension: String) -> Bool {
        if let validExts = AssetImporterScene.allowedFileExtensions() {
            return validExts.contains(`extension`.lowercased())
        } else {
            return false
        }
    }
    
    /**
     Loads a scene from a file with the specified name in the app’s main bundle.
     
     @param name The name of a scene file in the app bundle’s resources directory.
     @param postProcessFlags The flags for all possible post processing steps.
     @return A new scene object, or nil if no scene could be loaded.
     */
    public class func assimpSceneNamed(_ name: String, postProcessFlags: AssetImporterPostProcessSteps) -> AssetImporterScene {
        return assimpSceneNamed(name, postProcessFlags: postProcessFlags, error: nil)
    }
    
    /**
     Loads a scene from a file with the specified name in the app’s main bundle.
     
     @param name The name of a scene file in the app bundle’s resources directory.
     @param postProcessFlags The flags for all possible post processing steps.
     @param error Scene loading error.
     @return A new scene object, or nil if no scene could be loaded.
     */
    public class func assimpSceneNamed(_ name: String, postProcessFlags: AssetImporterPostProcessSteps, error: Error?) -> AssetImporterScene {
        
        let assimpImporter = AssetImporter()
        if let file = Bundle.main.path(forResource: name, ofType: nil),
            let scene = assimpImporter.importScene(file, postProcessFlags: postProcessFlags) {
            return scene
        } else {
            return AssetImporterScene()
        }
        
    }
    
    /**
     Loads a scene from the specified NSString URL.
     
     @param url The NSString URL to the scene file to load.
     @param postProcessFlags The flags for all possible post processing steps.
     @return A new scene object, or nil if no scene could be loaded.
     */
    public class func assimpScene(with url: URL, postProcessFlags: AssetImporterPostProcessSteps) -> AssetImporterScene {
        return assimpScene(with: url, postProcessFlags: postProcessFlags, error: nil)
    }
    
    /**
     Loads a scene from the specified NSString URL.
     
     @param url The NSString URL to the scene file to load.
     @param postProcessFlags The flags for all possible post processing steps.
     @param error Scene loading error.
     @return A new scene object, or nil if no scene could be loaded.
     */
    public class func assimpScene(with url: URL, postProcessFlags: AssetImporterPostProcessSteps, error: Error?) -> AssetImporterScene {
        
        let assimpImporter = AssetImporter()
        if let scene = assimpImporter.importScene(url.path, postProcessFlags: postProcessFlags) {
            return scene
        } else {
            return AssetImporterScene()
        }
        
    }
    
}

