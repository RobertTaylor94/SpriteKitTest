//
//  ContentView.swift
//  SpriteKitTest
//
//  Created by Robert on 19/07/2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        VStack {
            SKViewContainer()
        }
    }
}

//MARK: SKViewContainer

struct SKViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = SKView()
        view.showsFPS = true
        
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        
        view.presentScene(scene)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
