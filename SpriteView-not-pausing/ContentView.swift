import SwiftUI
import SpriteKit

class GameScene: SKScene, ObservableObject {
    @Published var updates = 0
    private let label = SKLabelNode(text: "Updates in SKScene:\n0")
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
