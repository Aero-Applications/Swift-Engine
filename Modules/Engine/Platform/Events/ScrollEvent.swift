@MainActor
public struct ScrollEvent {
    public let window : Window
    public let delta : Float

    public init(x: Float, y: Float, delta: Float, window : Window) {
        MouseEvent.LastX = MouseEvent.X
        MouseEvent.LastY = MouseEvent.Y
        MouseEvent.X = x
        MouseEvent.Y = y

        self.delta = delta
        self.window = window
    }

    public func getDelta() -> Float {
        return self.delta
    }

    public func getXVelocity() -> Float {
        return MouseEvent.X - MouseEvent.LastX
    }

    public func getYVelocity() -> Float {
        return MouseEvent.Y - MouseEvent.LastY
    }

    public func getModifiers() -> Modifiers {
        return Event.ActiveModifiers
    }
}