public struct Vec3 {
    public var x: Float
    public var y: Float
    public var z: Float

    public init(x: Float, y: Float, z: Float) {
        self.x = x; self.y = y; self.z = z;
    }

    public func get(index: Int) -> Float {
        var copy: Vec3 = self
        return withUnsafePointer(to: &copy.x) { ptr in return ptr[Int(index)];  }
    }
    public mutating func set(index: Int, value: Float) {
        withUnsafeMutablePointer(to: &self.x) { ptr in ptr[Int(index)] = value;  }
    }

    public func dotProduct(_ other: Vec3) -> Float {
        return (x*other.x)+(y*other.y)+(z*other.z);
    }
}