import Foundation

import Engine_Graphics;
import Engine_Graphics_RenderTarget;
import Engine_Math;
import Engine_Platform;

@MainActor
public class Application {

    private static var s_Instance: Application! = nil

    public var window : Window! = nil;

    internal var running : Bool = true

    public init(){
        Graphics.Initialize(api: 0)

        print("Initializing the Application.")
        self.window = CreateWindow(eventHandler: self, context: Graphics.CreateWindowContext());
        RenderTarget.setCurrent(target: self.window);

        self.window.x = 30
        self.window.y = 30

        Self.s_Instance = self;
    }

    public static func Get() -> Application {
        return Self.s_Instance;
    }

    public func run(){
        print("Running the Application")

        while running {
            window.pollEvents()
            if (!window.isOpen()) {
                running = false
            }

            self.update(0.16)

            self.render()
        }
    }

    private func render() {
        Graphics.SetViewport(size: Rect(x: 0.0, y: 0.0, width: window.width, height: window.height))
        Graphics.Clear(red: 0.15, green: 0.9745, blue: 0.478, alpha: 1.0)

        window.layerManager.render();

        Graphics.SwapBuffers()
    }

    private func update(_ delta: Double) {
        window.layerManager.update(delta)
    }
}

extension Application : @MainActor EventHandler {
    public func keyPressed(event: KeyEvent) {
        event.window.layerManager.keyPressed(event: event)
    }
    public func keyReleased(event: KeyEvent) {
        event.window.layerManager.keyReleased(event: event)
    }
    public func mousePressed(event: MouseEvent) {
        event.window.layerManager.mousePressed(event: event)
    }
    public func mouseReleased(event: MouseEvent) {
        event.window.layerManager.mouseReleased(event: event)
    }
    public func mouseMoved(event: MouseEvent) {
        event.window.layerManager.mouseMoved(event: event)
    }
    public func mouseDragged(event: MouseEvent) {
        event.window.layerManager.mouseDragged(event: event)
    }
    public func mouseScrolled(event: ScrollEvent) {
        event.window.layerManager.mouseScrolled(event: event)
    }
}