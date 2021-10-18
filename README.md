# SpriteView-not-pausing

Sample SwiftUI / SpriteKit Xcode 13 project showing a simple `ContentView` that displays a [`SpriteView`](https://developer.apple.com/documentation/spritekit/spriteview) with a `@State var paused` property that is passed to the SpriteView, and the SpriteView doesn't pause when the property changes.

It seems that the SpriteView is not picking up the updates and is not changing the underlying SKView and SKScene inside it, after the initial render.

Related questions:

- TODO

![SpriteView-not-pausing-with-state](SpriteView-not-pausing.gif)

All the code is in [ContentView.swift](https://github.com/clns/SpriteView-not-pausing/blob/main/SpriteView-not-pausing/ContentView.swift):

```swift
import SwiftUI
import SpriteKit

class GameScene: SKScene, ObservableObject {
    @Published var updates = 0
    private let label = SKLabelNode(text: "Updates:\n0")
    
    override func didMove(to view: SKView) {
        addChild(label)
        label.numberOfLines = 2
    }
    
    override func update(_ currentTime: TimeInterval) {
        updates += 1
        label.text = "Updates in SKScene:\n\(updates)"
    }
}

struct ContentView: View {
    @State private var paused = false
    
    @StateObject private var scene: GameScene = {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .fill
        return scene
    }()
    
    var body: some View {
        if #available(iOS 15.0, *) {
            print(Self._printChanges())
        }
        return ZStack {
            SpriteView(scene: scene, isPaused: paused).ignoresSafeArea()
            VStack {
                Text("Updates from SKScene: \(scene.updates)").padding().foregroundColor(.white)
                Button("Paused: \(paused)" as String) {
                    paused.toggle()
                }.padding()
                Spacer()
            }
        }
    }
}
```
