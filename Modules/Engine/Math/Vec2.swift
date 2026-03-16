public struct Vec2 {
    public var x: Float
    public var y: Float

    public init(x: Float, y: Float) {
        self.x = x; self.y = y;
    }

    public func get(index: Int) -> Float {
        var copy: Vec2 = self;
        return withUnsafePointer(to: &copy.x) { ptr in return ptr[Int(index)];  }
    }
    public mutating func set(index: Int, value: Float) {
        withUnsafeMutablePointer(to: &self.x) { ptr in ptr[Int(index)] = value;  }
    }

    public func dotProduct(_ other: Vec2) -> Float {
        return (x*other.x)+(y*other.y);
    }
}