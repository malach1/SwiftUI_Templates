//
//  3DShoe.swift
//  SwiftUI_Templates
//
//  Created by Malachi Hul on 2022/09/11.
//  Copyright © 2022 Hui, Malachi | DCMS. All rights reserved.
//

import SwiftUI
import SceneKit

struct ThreeDShoe: View {
    @State var scene: SCNScene? = .init(named: "Nike_Air_Jordan.scn")
    @State var isVerticalLook: Bool = false
    
    @GestureState var offset: CGFloat = 0
    var body: some View {
        VStack{
            // MARK: 3D Preview
            CustomSceneView(scene: $scene)
                .frame(height: 350)
                .padding(.top,-50)
                .padding(.bottom,-15)
                .zIndex(-10)
            
            CustomSeeker()
        }
        .padding()
    }
    
    // MARK: Custom Seeker
    @ViewBuilder
    func CustomSeeker()->some View {
        GeometryReader{_ in
            Rectangle()
                .trim(from: 0, to: 0.474)
                .stroke(.linearGradient(colors: [
                    .clear,
                    .clear,
                    .white.opacity(0.2),
                    .white.opacity(0.6),
                    .white,
                    .white.opacity(0.6),
                    .white.opacity(0.2),
                    .clear,
                    .clear
                ], startPoint: .leading, endPoint: .trailing),style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [3], dashPhase: 1))
                .offset(x: offset)
                .overlay {
                    // MARK: Seeker View
                    HStack(spacing: 3){
                        Image(systemName: "arrowtriangle.left.fill")
                            .font(.caption)
                        
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal,7)
                    .padding(.vertical,10)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
                    .offset(y: -12)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { value, out, _ in
                                // Reducing The Size of the Knob
                                // Assuming the Total Size will be 40
                                // So Reducing 40/2 -> 20
                                out = value.location.x - 20
                            })
                    )
                }
        }
        .frame(height: 20)
        .onChange(of: offset, perform: { newValue in
            rotateObject(animate: offset == .zero)
        })
        .animation(.easeInOut(duration: 0.4), value: offset == .zero)
    }
    
    // MARK: Rotating 3D Object Programatically
    func rotateObject(animate: Bool = false) {
        // The Rotation is more or like same as 3D Rotation in SwiftUI
        // Y Will Be Used for Horizontal Rotataion
        // And Vice Versa for X
        if animate{
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.4
        }
        let newAngle = Float((offset * .pi) / 180)
        
        // MARK: Now Rotate the New Child Node
        if isVerticalLook{
            scene?.rootNode.childNode(withName: "Root", recursively: true)?.eulerAngles.x = newAngle
        }else{
            scene?.rootNode.childNode(withName: "Root", recursively: true)?.eulerAngles.y = newAngle
        }
        
        if animate{
            SCNTransaction.commit()
        }
    }
}

struct ThreeDShoe_Previews: PreviewProvider {
    static var previews: some View {
        ThreeDShoe()
    }
}
