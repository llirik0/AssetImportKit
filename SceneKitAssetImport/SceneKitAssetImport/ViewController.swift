//
//  ViewController.swift
//  SceneKitAssetImport
//
//  Created by Eugene Bokhan on 2/12/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import Cocoa
import SceneKit
import SceneKit.ModelIO
import AssetImportKit

class ViewController: NSViewController, CAAnimationDelegate, SCNSceneExportDelegate {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var sceneView: SCNView!
    
    // MARK: - UI Actions
    
    
    
    @IBAction func openAssetAction(_ sender: Any) {
        openAsset()
    }
    @IBAction func saveSceneAction(_ sender: Any) {
        exportScene()
    }
    
    // MARK: - Properties
    
    var modelContainerNode: SCNNode = {
        let modelContainerNode = SCNNode()
        modelContainerNode.name = "Model Container Node"
        modelContainerNode.constraints = []
        return modelContainerNode
    }()
    var sceneDidLoad: Bool = false
    var assetPath: String? {
        didSet {
            loadScene()
        }
    }
    
    // MARK: - LifeCyfle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSceneView()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // MARK: - Setup
    
    func setupSceneView() {
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2489546655)
    }
    
    // MARK: - Load model to scene
    
    public func loadScene() {
        
        guard let filePath = assetPath else {
            return
        }
        
        // Clean Scene
        unloadScene()
        sceneView.scene = SCNScene()
        
        if (filePath as NSString).pathExtension == "scn" {
            do {
                let scnScene = try SCNScene(url: URL(fileURLWithPath: filePath), options: nil)
                for childNode in (scnScene.rootNode.childNodes) {
                    self.modelContainerNode.addChildNode(childNode)
                }
            } catch let error {
                print(error)
            }
            
            sceneView.scene?.rootNode.addChildNode(modelContainerNode)
            
        } else if (filePath as NSString).pathExtension == "obj" {
            // Create a MDLAsset from url
            let asset = MDLAsset(url:URL(fileURLWithPath: filePath))
            guard let object = asset.object(at: 0) as? MDLMesh else {
                fatalError("Failed to get mesh from asset.")
            }
            // Wrap the ModelIO object in a SceneKit object
            let node = SCNNode(mdlObject: object)
            self.modelContainerNode.addChildNode(node)
            
            sceneView.scene?.rootNode.addChildNode(modelContainerNode)
            
        } else {
            
            let assetImporter = AssetImporter()
            if let assimpScene = assetImporter.importScene(filePath, postProcessFlags: AssetImporterPostProcessSteps(rawValue: AssetImporterPostProcessSteps.process_FlipUVs.rawValue | AssetImporterPostProcessSteps.process_Triangulate.rawValue)) {
                
                if let modelScene = assimpScene.modelScene {
                    for childNode in modelScene.rootNode.childNodes {
                        self.modelContainerNode.addChildNode(childNode)
                    }
                }
                
                sceneView.scene?.rootNode.addChildNode(modelContainerNode)
                
                let animationKeys = assimpScene.animationKeys()
                // If multiple animations exist, load the first animation
                if let numberOfAnimationKeys = animationKeys?.count {
                    if numberOfAnimationKeys > 0 {
                        var settings = AssetImporterAnimSettings()
                        settings.repeatCount = 5
                        
                        let key = animationKeys![0] as! String
                        let eventBlock: SCNAnimationEventBlock = { animation, animatedObject, playingBackwards in
                            print("Animation Event triggered")
                            return
                        }
                        let animEvent = SCNAnimationEvent(keyTime: 0.1, block: eventBlock)
                        let animEvents: [SCNAnimationEvent]  = [animEvent]
                        settings.animationEvents = animEvents
                        settings.delegate = self
                        
                        if var animation = assimpScene.animationScenes.value(forKey: key) as? SCNScene {
                            sceneView.scene?.rootNode.addAnimationScene(&animation, forKey: key, with: &settings)
                        }
                        
                    }
                }
            }
        }
        
        
        sceneDidLoad = true
        
    }
    
    func unloadScene() {
        
        for node in modelContainerNode.childNodes {
            node.removeFromParentNode()
            node.removeAllAnimations()
        }
        
        sceneView.scene = nil
        
    }
    
    // MARK: - File Browsing
    
    func openPanel() -> NSOpenPanel {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        return openPanel
    }
    
    func openAsset() {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose an Asset file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["dae", "fbx", "obj", "scn", "md3", "zgl", "xgl", "wrl", "stl", "smd", "raw", "q3s", "q3o", "ply", "xml", "mesh", "off", "nff", "m3sd", "md5anim", "md5mesh", "md2", "irr", "ifc", "dxf", "cob", "bvh", "b3d", "ac", "blend", "hmp", "3ds", "3d", "x", "ter", "max", "ms3d", "mdl", "ase"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                assetPath = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func exportScene() {
        
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["scn"]
        savePanel.begin { (result) -> Void in
            
            if result == NSApplication.ModalResponse.OK {
                
                if let sceneFileURL = savePanel.url, let scene = self.sceneView.scene {
                    
                    let success = scene.write(to: sceneFileURL, options: nil, delegate: self) { (totalProgress, error, stop) in
                        print("Progress \(totalProgress) Error: \(String(describing: error))")
                    }
                    print("Success: \(success)")
                    
                }
                
            } else {
                NSSound.beep()
            }
        }
        
    }


}

