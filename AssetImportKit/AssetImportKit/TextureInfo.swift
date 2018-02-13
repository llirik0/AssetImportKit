//
//  SCNTextureInfo.swift
//  AssetImportKit
//
//  Created by Eugene Bokhan on 2/11/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Foundation
import ImageIO
import CoreImage
import scene
import postprocess

@objc public class TextureInfo: NSObject {
    
    // MARK: - Texture metadata
    
    /**
     The texture type: diffuse, specular etc.
     */
    public var textureType: aiTextureType?
    
    // MARK: - Texture material
    
    /**
     The material name which is the owner of this texture.
     */
    public var materialName: NSString?
    
    // MARK: - Texture color and resources
    
    /**
     A Boolean value that determines whether a color is applied to a material
     property.
     */
    public var applyColor: Bool = false {
        didSet {
            if applyColor {
                self.applyEmbeddedTexture = false
                self.applyExternalTexture = false
            }
        }
    }
    
    /**
     The actual color to be applied to a material property.
     */
    public var color: CGColor?
    
    /**
     A profile that specifies the interpretation of a color to be applied to
     a material property.
     */
    public var colorSpace: CGColorSpace?
    
    // MARK: - Embedded texture
    
    /**
     A Boolean value that determines if embedded texture is applied to a
     material property.
     */
    public var applyEmbeddedTexture: Bool = false {
        didSet {
            if applyEmbeddedTexture {
                self.applyColor = false
                self.applyExternalTexture = false
            }
        }
    }
    
    /**
     The index of the embedded texture in the array of assimp scene textures.
     */
    public var embeddedTextureIndex: Int?
    
    // MARK: - External texture
    
    /**
     A Boolean value that determines if an external texture is applied to a
     material property.
     */
    public var applyExternalTexture: Bool = false {
        didSet {
            if applyExternalTexture {
                self.applyColor = false
                self.applyEmbeddedTexture = false
            }
        }
    }
    
    /**
     The path to the external texture resource on the disk.
     */
    public var externalTexturePath: NSString?
    
    // MARK: - Texture image resources
    
    /**
     An opaque type that represents the external texture image source.
     */
    public var imageSource: CGImageSource?
    
    /**
     An abstraction for the raw image data of an embedded texture image source that
     eliminates the need to manage raw memory buffer.
     */
    public var imageDataProvider: CGDataProvider?
    
    /**
     A bitmap image representing either an external or embedded texture applied to
     a material property.
     */
    public var image: CGImage?
    
    
    // MARK: - Creating a texture info
    
    /**
     Create a texture metadata object for a material property.
     
     @param aiMeshIndex The index of the mesh to which this texture is applied.
     @param aiTextureType The texture type: diffuse, specular etc.
     @param aiScene The assimp scene.
     @param path The path to the scene file to load.
     @return A new texture info.
     */
    public init(meshIndex aiMeshIndex: Int, textureType aiTextureType: aiTextureType, in aiScene: inout aiScene, atPath path: NSString) {
        
        super.init()
        
        self.imageSource = nil
        self.imageDataProvider = nil
        self.image = nil
        self.colorSpace = nil
        self.color = nil
        
        if let aiMeshPointer = aiScene.mMeshes[aiMeshIndex] {
            
            let aiMesh = aiMeshPointer.pointee
            let aiMaterial = aiScene.mMaterials[Int(aiMesh.mMaterialIndex)]
            self.textureType = aiTextureType
            var name = aiString()
            aiGetMaterialString(aiMaterial, AI_MATKEY_NAME.pKey, AI_MATKEY_NAME.type, AI_MATKEY_NAME.index, &name)
            let nameString = name.stringValue()
            self.materialName = nameString as NSString
            if let materialName = self.materialName {
                print(" Material name is \(materialName)")
            }
            checkTextureType(for: aiMaterial!, with: aiTextureType, in: &aiScene, atPath: path)
            
        }
    }
    
    
    // MARK: - Inspect texture metadata
    
    /**
     Inspects the material texture properties to determine if color, embedded
     texture or external texture should be applied to the material property.
     
     @param aiMaterial The assimp material.
     @param aiTextureType The material property: diffuse, specular etc.
     @param aiScene The assimp scene.
     @param path The path to the scene file to load.
     */
    public func checkTextureType(for aiMaterial: UnsafeMutablePointer<aiMaterial>, with aiTextureType: aiTextureType, in aiScene: inout aiScene, atPath path: NSString) {
        
        let nTextures = aiGetMaterialTextureCount(aiMaterial, aiTextureType)
        
        print("has textures: \(nTextures)")
        print("has embedded textures: \(aiScene.mNumTextures)")
        
        if nTextures == 0 && aiScene.mNumTextures == 0 {
            
            self.applyColor = true
            self.extractColor(for: aiMaterial, with: aiTextureType)
            
        } else {
            
            if nTextures == 0 {
                
                self.applyColor = true
                self.extractColor(for: aiMaterial, with: aiTextureType)
                
            } else {
                
                var aiPath = aiString()
                aiGetMaterialTexture(aiMaterial, aiTextureType, UInt32(0), &aiPath, nil, nil, nil, nil, nil, nil)
                let texFilePath = aiPath.stringValue() as NSString
                
                print("tex file path is: \(texFilePath)")
                
                let texFileName = texFilePath.lastPathComponent
                if texFileName == "" {
                    
                    self.applyColor = true
                    self.extractColor(for: aiMaterial, with: aiTextureType)
                    
                } else if (texFileName.hasPrefix("*")) && aiScene.mNumTextures > 0 {
                    
                    if let embeddedTextureIndex = Int((texFilePath.substring(from: 1))) {
                        
                        self.applyEmbeddedTexture = true
                        self.embeddedTextureIndex = embeddedTextureIndex
                        
                        print("Embedded texture index: \(embeddedTextureIndex)")
                        
                        self.generateCGImageForEmbeddedTexture(at: embeddedTextureIndex, in: aiScene)
                        
                    }
                } else {
                    
                    self.applyExternalTexture = true
                    
                    print("tex file name is \(String(describing: texFileName))")
                    
                    let sceneDir = (path.deletingLastPathComponent).appending("/") as NSString
                    self.externalTexturePath = sceneDir.appending(texFileName) as NSString
                    if let externalTexturePath = self.externalTexturePath {
                        
                        print("tex path is \(externalTexturePath)")
                        
                        self.generateCGImageForExternalTexture(atPath: externalTexturePath)
                    }
                }
                
            }
        }
        
    }
    
    
    // MARK: - Generate textures
    
    /**
     Generates a bitmap image representing the embedded texture.
     
     @param index The index of the texture in assimp scene's textures.
     @param aiScene The assimp scene.
     */
    public func generateCGImageForEmbeddedTexture(at index: Int, in aiScene: aiScene) {
        
        print("Generating embedded texture")
        
        if let aiTexturePointer = aiScene.mTextures[index] {
            
            let aiTexture = aiTexturePointer.pointee
            let data = aiTexture.pcData
            let mWidth = aiTexture.mWidth
            let imageData = NSData(bytes: aiTexture.pcData, length: Int(mWidth))
            
            self.imageDataProvider = CGDataProvider(data: imageData)
            let format = tupleOfInt8sToString(aiTexture.achFormatHint)
            if format == "png" {
                
                print(" Created png embedded texture")
                
                self.image = CGImage.init(pngDataProviderSource: self.imageDataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            }
            if format == "jpg" {
                
                print(" Created jpg embedded texture")
                
                self.image = CGImage.init(jpegDataProviderSource: self.imageDataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            }
        } else {
            self.image = nil
        }
        
    }
    
    /**
     Generates a bitmap image representing the external texture.
     
     @param path The path to the scene file to load.
     */
    public func generateCGImageForExternalTexture(atPath path: NSString) {
        
        print(" Generating external texture ")
        
        let imageURL = NSURL.fileURL(withPath: path as String)
        self.imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil)
        if self.imageSource != nil {
            self.image = CGImageSourceCreateImageAtIndex(self.imageSource!, 0, nil)
        }
        
    }
    
    
    // MARK: - Extract color
    
    public func extractColor(for aiMaterial: UnsafeMutablePointer<aiMaterial>, with aiTextureType: aiTextureType) {
        
        print("Extracting color")
        
        var color = aiColor4D()
        color.r = 0.0
        color.g = 0.0
        color.b = 0.0
        var matColor: aiReturn = aiReturn(rawValue: -100)
        if aiTextureType == aiTextureType_DIFFUSE {
            matColor = aiGetMaterialColor(aiMaterial, AI_MATKEY_COLOR_DIFFUSE.pKey, AI_MATKEY_COLOR_DIFFUSE.type, AI_MATKEY_COLOR_DIFFUSE.index, &color)
        }
        if(aiTextureType == aiTextureType_SPECULAR) {
            matColor = aiGetMaterialColor(aiMaterial, AI_MATKEY_COLOR_SPECULAR.pKey, AI_MATKEY_COLOR_SPECULAR.type, AI_MATKEY_COLOR_SPECULAR.index, &color)
        }
        if(aiTextureType == aiTextureType_AMBIENT) {
            matColor = aiGetMaterialColor(aiMaterial, AI_MATKEY_COLOR_AMBIENT.pKey, AI_MATKEY_COLOR_AMBIENT.type, AI_MATKEY_COLOR_AMBIENT.index, &color)
        }
        if(aiTextureType == aiTextureType_REFLECTION) {
            matColor = aiGetMaterialColor(aiMaterial, AI_MATKEY_COLOR_REFLECTIVE.pKey, AI_MATKEY_COLOR_REFLECTIVE.type, AI_MATKEY_COLOR_REFLECTIVE.index, &color)
        }
        if(aiTextureType == aiTextureType_EMISSIVE) {
            matColor = aiGetMaterialColor(aiMaterial, AI_MATKEY_COLOR_EMISSIVE.pKey, AI_MATKEY_COLOR_EMISSIVE.type, AI_MATKEY_COLOR_EMISSIVE.index, &color)
        }
        if(aiTextureType == aiTextureType_OPACITY) {
            matColor = aiGetMaterialColor(aiMaterial, AI_MATKEY_COLOR_TRANSPARENT.pKey, AI_MATKEY_COLOR_TRANSPARENT.type, AI_MATKEY_COLOR_TRANSPARENT.index, &color)
        }
        if AI_SUCCESS == matColor {
            self.colorSpace = CGColorSpaceCreateDeviceRGB()
            let components: [CGFloat] = [CGFloat(color.r), CGFloat(color.g), CGFloat(color.b), CGFloat(color.a)]
            if self.colorSpace != nil {
                self.color = CGColor.init(colorSpace: self.colorSpace!, components: components)
            }
            
        }
        
    }
    
    
    // MARK: - Texture resources
    
    /**
     Returns the color or the bitmap image to be applied to the material property.
     
     @return Returns either a color or a bitmap image.
     */
    public func getMaterialPropertyContents() -> Any? {
        if self.applyEmbeddedTexture || self.applyExternalTexture {
            return self.image
        }
        else {
            return self.color
        }
    }
    
    /**
     Releases the graphics resources used to generate color or bitmap image to be
     applied to a material property.
     
     This method must be called by the client to avoid memory leaks!
     */
    public func releaseContents() {
        self.imageSource = nil
        self.imageDataProvider = nil
        self.image = nil
        self.colorSpace = nil
        self.color = nil
    }
    
}

