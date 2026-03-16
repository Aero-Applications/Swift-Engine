public struct Vec4 {
    public var x: Float32;
    public var y: Float32;
    public var z: Float32;
    public var w: Float32;

    public init(x: Float32, y: Float32, z: Float32, w: Float32) {
        self.x = x; self.y = y; self.z = z; self.w = w;
    }

    public func get(index: Int) -> Float {
        var copy = self
        return withUnsafePointer(to: &copy.x) { ptr in return ptr[Int(index)];  }
    }
    public mutating func set(index: Int, value: Float) {
        withUnsafeMutablePointer(to: &self.x) { ptr in ptr[Int(index)] = value;  }
    }

    public func transformed(matrix: Matrix4) -> Vec4 {
        return Vec4(
            x: self.dotProduct(matrix.column0),
            y: self.dotProduct(matrix.column1),
            z: self.dotProduct(matrix.column2),
            w: self.dotProduct(matrix.column3),
        );
    }

    public func dotProduct(_ other: Vec4) -> Float32 {
        return (x*other.x)+(y*other.y)+(z*other.z)+(w*other.w);
    }
}