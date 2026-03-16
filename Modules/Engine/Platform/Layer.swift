@MainActor
public struct LayerManager {
    private var layers: [Layer] = []

    public mutating func add(layer: Layer) {
        layers.append(layer);
    }

    public mutating func remove(layer: Layer) {
        guard let index = indexOf(layer: layer) else { return; }
        layers.remove(at: index);
    }

    public func indexOf(layer: Layer) -> Int? {
        return layers.firstIndex(of: layer);
    }

    public func render() {
        for layer in layers {
            layer.render();
        }
    }
    public func update(_ delta: Double) {
        for layer in layers.reversed() {
            if (layer.update(delta)) {
                return;
            }
        }
    }

    public func keyPressed(event: KeyEvent) {
        for layer in layers.reversed() {
            layer.keyPressed(event: event);
        }
    }
    public func keyReleased(event: KeyEvent) {
        for layer in layers.reversed() {
            layer.keyReleased(event: event);
        }
    }
    public func mousePressed(event: MouseEvent) {
        for layer in layers.reversed() {
            layer.mousePressed(event: event);
        }
    }
    public func mouseReleased(event: MouseEvent) {
        for layer in layers.reversed() {
            layer.mouseReleased(event: event);
        }
    }
    public func mouseMoved(event: MouseEvent) {
        for layer in layers.reversed() {
            layer.mouseMoved(event: event);
        }
    }
    public func mouseDragged(event: MouseEvent) {
        for layer in layers.reversed() {
            layer.mouseDragged(event: event);
        }
    }
    public func mouseScrolled(event: ScrollEvent) {
        for layer in layers.reversed() {
            layer.mouseScrolled(event: event);
        }
    }
}

@MainActor
open class Layer : @MainActor Equatable, @MainActor EventHandler {
    public init() {}

    open func render() {}
    open func update(_ delta: Double) -> Bool { return false }

    // =========================================================================    
    // EventHandler implementation
    // =========================================================================

    open func keyPressed(event: KeyEvent) {

    }
    open func keyReleased(event: KeyEvent) {

    }
    open func mousePressed(event: MouseEvent) {

    }
    open func mouseReleased(event: MouseEvent) {

    }
    open func mouseMoved(event: MouseEvent) {

    }
    open func mouseDragged(event: MouseEvent) {

    }
    open func mouseScrolled(event: ScrollEvent) {

    }

    // =========================================================================    
    // Equatable implementation
    // =========================================================================

    public static func == (lhs: Layer, rhs: Layer) -> Bool {
        return lhs === rhs
    }
}