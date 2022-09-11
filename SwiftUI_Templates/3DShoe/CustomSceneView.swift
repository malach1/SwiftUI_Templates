//
//  CustomSceneView.swift
//  SwiftUI_Templates
//
//  Created by Malachi Hul on 2022/09/11.
//  Copyright © 2022 Hui, Malachi | DCMS. All rights reserved.
//

import SwiftUI
import SceneKit

struct CustomSceneView: UIViewRepresentable {
    @Binding var scene: SCNScene?

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
}

struct CustomSceneView_Previews: PreviewProvider {
    static var previews: some View {
        ThreeDShoe()
    }
}
