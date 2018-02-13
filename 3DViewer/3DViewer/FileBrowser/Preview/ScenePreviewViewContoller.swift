//
//  ScenePreviewViewContoller.swift
//  3DViewer
//
//  Created by Eugene Bokhan on 9/14/17.
//  Copyright © 2017 Eugene Bokhan. All rights reserved.
//

import UIKit
import ModelIO
import SceneKit
import SceneKit.ModelIO
import AssetImportKit

class ScenePreviewViewContoller: UIViewController, CAAnimationDelegate {

    // MARK: - UI Elements
    
    var sceneView = SCNView()
    
    // MARK: - Properties
    
    var scene = SCNScene()
    var modelContainerNode: SCNNode = {
        let modelContainerNode = SCNNode()
        modelContainerNode.name = "Model Container Node"
        modelContainerNode.constraints = []
        return modelContainerNode
    }()

    var file: FBFile? {
        didSet {
            self.title = file?.displayName
        }
    }
    var sceneDidLoad: Bool = false
    
    // MARK: -  View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the SceneView
        setupSceneView()
        setupButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sceneView.frame = self.view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !sceneDidLoad {
            MBProgressHUD.showAdded(to: self.sceneView, animated: true)
            DispatchQueue.main.async {
                self.loadScene()
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.sceneView, animated: true)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unloadScene()
    }
    
    // MARK: - Setup
    
    func setupSceneView() {
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
        sceneView.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.3490196078, blue: 0.3490196078, alpha: 1)
        sceneView.showsStatistics = true
        self.view.addSubview(sceneView)
    }
    
    func setupButtons() {
        // Share button
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ScenePreviewViewContoller.shareFile(_:)))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    // MARK: - Share
    
    @objc func shareFile(_ sender: UIBarButtonItem) {
        guard let file = file else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [file.filePath], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad &&
            activityViewController.responds(to: #selector(getter: popoverPresentationController)) {
            activityViewController.popoverPresentationController?.barButtonItem = sender
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Load model to scene
    
    public func loadScene() {
        
        guard let file = file else {
            return
        }
        
        let filePath = file.filePath.path
        
        DispatchQueue.main.async {
            
            if (filePath as NSString).pathExtension == "scn" {
                do {
                    let scnScene = try SCNScene(url: URL(fileURLWithPath: filePath), options: nil)
                    for childNode in (scnScene.rootNode.childNodes) {
                        self.modelContainerNode.addChildNode(childNode)
                    }
                } catch let error {
                    print(error)
                }
            } else if (filePath as NSString).pathExtension == "obj" {
                // Create a MDLAsset from url
                let asset = MDLAsset(url:URL(fileURLWithPath: filePath))
                guard let object = asset.object(at: 0) as? MDLMesh else {
                    fatalError("Failed to get mesh from asset.")
                }
                // Wrap the ModelIO object in a SceneKit object
                let node = SCNNode(mdlObject: object)
                self.modelContainerNode.addChildNode(node)
                
            } else {
                
                let assetImporter = AssetImporter()
                let fileURL = URL(fileURLWithPath: filePath)
                if let assimpScene = assetImporter.importScene(filePath, postProcessFlags: AssetImporterPostProcessSteps(rawValue: AssetImporterPostProcessSteps.process_FlipUVs.rawValue | AssetImporterPostProcessSteps.process_Triangulate.rawValue )) {
                    
                    if let modelScene = assimpScene.modelScene {
                        for childNode in modelScene.rootNode.childNodes {
                            self.modelContainerNode.addChildNode(childNode)
                        }
                    }
                    
                    let animationKeys = assimpScene.animationKeys()
                    // If multiple animations exist, load the first animation
                    if let numberOfAnimationKeys = animationKeys?.count {
                        if numberOfAnimationKeys > 0 {
                            var settings = AssetImporterAnimSettings()
                            settings.repeatCount = 5
                            
                            let key = animationKeys![0] as! String
                            let eventBlock: SCNAnimationEventBlock = { animation, animatedObject, playingBackwards in
                                print("Animation Event triggered")
                                // To test removing animation uncomment
                                // Then the animation wont repeat 3 times
                                // as it will be removed after 90% of the first loop
                                // is completed, as event key time is 0.9
                                // self.scene.rootNode.removeAnimationScene(forKey: key, fadeOutDuration: 0.3)
                                // self.scene.rootNode.pauseAnimationScene(forKey: key)
                                // self.scene.rootNode.resumeAnimation(forKey: key)
                                return
                            }
                            let animEvent = SCNAnimationEvent(keyTime: 0.1, block: eventBlock)
                            let animEvents: [SCNAnimationEvent]  = [animEvent]
                            settings.animationEvents = animEvents
                            settings.delegate = self
                            
                            if var animation = assimpScene.animationScenes.value(forKey: key) as? SCNScene {
                                self.modelContainerNode.addAnimationScene(&animation, forKey: key, with: &settings)
                            }
                            
                        }
                    }
                }
            }
        }

        sceneView.scene?.rootNode.addChildNode(self.modelContainerNode)
        sceneDidLoad = true
        
    }
    
    // MARK: - Dismiss SceneView
    
    func unloadScene() {
        for node in self.scene.rootNode.childNodes {
            node.removeFromParentNode()
            node.removeAllAnimations()
        }
    }
}
