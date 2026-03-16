import Foundation

public struct Matrix4 {
     /*
           - this matrix should be in column major order.
             Which means multiplication should go this way:
         
            { (x*column0.x) * (x*column1.x) * (x*column2.x) * (x*column3.x) }
                    +               +               +               +
            { (y*column0.y) * (y*column1.y) * (y*column2.y) * (y*column3.y) }
                    +               +               +               +
            { (z*column0.z) * (z*column1.z) * (z*column2.z) * (z*column3.z) }
                    +               +               +               +
            { (w*column0.w) * (w*column1.w) * (w*column2.w) * (w*column3.w) }
         
         */
        var column0: Vec4 = Vec4(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
        var column1: Vec4 = Vec4(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
        var column2: Vec4 = Vec4(x: 0.0, y: 0.0, z: 0.0, w: 0.0)
        var column3: Vec4 = Vec4(x: 0.0, y: 0.0, z: 0.0, w: 0.0)

    init(column0: Vec4, column1: Vec4, column2: Vec4, column3: Vec4) {
        self.column0 = column0;
        self.column1 = column1;
        self.column2 = column2;
        self.column3 = column3;
    }

    public mutating func set(column: Int, row: Int, value: Float) {
        withUnsafeMutablePointer(to: &self.column0) { ptr in return ptr[column].set(index: row, value: value);  }
    }

    public func get(column: Int, row: Int) -> Float {
        var copy: Matrix4 = self;
        let vec: Vec4 = withUnsafePointer(to: &copy.column0) { ptr in return ptr[column];  }
        return vec.get(index: row);
    }

    public func multiply(_ other: Matrix4) -> Matrix4 {
        var matrix: Matrix4 = self;
        for i in 0..<4 { 
            for j in 0..<4 {
                let j0x0i = self.get(column: j, row: 0) * other.get(column: 0, row: i);
                let j1x1i = self.get(column: j, row: 1) * other.get(column: 1, row: i)
                let j2x2i = self.get(column: j, row: 2) * other.get(column: 2, row: i)
                let j3x3i = self.get(column: j, row: 3) * other.get(column: 3, row: i)
                matrix.set(column: j, row: i, value: j0x0i + j1x1i + j2x2i + j3x3i )
            }
        }
        return matrix;
    }

    public func transform(vector: Vec4) -> Vec4 {
        return Vec4(
            x: column0.dotProduct(vector),
            y: column1.dotProduct(vector),
            z: column2.dotProduct(vector),
            w: column3.dotProduct(vector),
        )
    }

    // flips the ordering of the elements of the matrix from column major to row major
    public func transposed() -> Matrix4 {
        var matrix: Matrix4 = self
        
        matrix.column0.y = self.column1.x
        matrix.column0.z = self.column2.x
        matrix.column0.w = self.column3.x

        matrix.column1.x = self.column0.y
        matrix.column1.z = self.column2.y
        matrix.column1.w = self.column3.y

        matrix.column2.x = self.column0.z
        matrix.column2.y = self.column1.z
        matrix.column2.w = self.column3.z
        
        matrix.column3.x = self.column0.w
        matrix.column3.y = self.column1.w
        matrix.column3.z = self.column2.w

        return matrix
    }

    // returns the Identity Matrix. A matrix with diagonal 1s across it.
    public static func Identity() -> Matrix4 {
        return Matrix4(
            column0: Vec4(x: 1.0, y: 0.0, z: 0.0, w: 0.0),
            column1: Vec4(x: 0.0, y: 1.0, z: 0.0, w: 0.0),
            column2: Vec4(x: 0.0, y: 0.0, z: 1.0, w: 0.0),
            column3: Vec4(x: 0.0, y: 0.0, z: 0.0, w: 1.0),
        )
    }
    // returns a Scale Matrix that will scale all vectors applied to it.
    public static func Scale(_ scale: Vec3) -> Matrix4 {
        return Scale(scale.x, scale.y, scale.z)
    }
    public static func Scale(_ scaleX: Float, _ scaleY: Float, _ scaleZ: Float) -> Matrix4 {
        return Matrix4(
            column0: Vec4(x: scaleX, y: 0.0, z: 0.0, w: 0.0),
            column1: Vec4(x: 0.0, y: scaleY, z: 0.0, w: 0.0),
            column2: Vec4(x: 0.0, y: 0.0, z: scaleZ, w: 0.0),
            column3: Vec4(x: 0.0, y: 0.0, z: 0.0, w: 1.0),
        )
    }
    // returns a matrix that will rotate a vector in space by "degrees" around the X axis
    public static func RotationX(degrees: Float) -> Matrix4 {        
        let radians: Float = degrees * .pi / 180.0
        return Matrix4(
            column0: Vec4(x: 1.0, y: 0.0,          z: 0.0,           w: 0.0),
            column1: Vec4(x: 0.0, y: cos(radians), z: -sin(radians), w: 0.0),
            column2: Vec4(x: 0.0, y: sin(radians), z: cos(radians),  w: 0.0),
            column3: Vec4(x: 0.0, y: 0.0,          z: 0.0,           w: 1.0),
        )
    }
    // returns a matrix that will rotate a vector in space by "degrees" around the Y axis
    public static func RotationY(degrees: Float) -> Matrix4 {
        let radians: Float = degrees * .pi / 180.0
        return Matrix4(
            column0: Vec4(x: cos(radians),  y: 0.0, z: sin(radians), w: 0.0),
            column1: Vec4(x: 0.0,           y: 1.0, z: 0.0,          w: 0.0),
            column2: Vec4(x: -sin(radians), y: 0.0, z: cos(radians), w: 0.0),
            column3: Vec4(x: 0.0,           y: 0.0, z: 0.0,          w: 1.0),
        )
    }
    // returns a matrix that will rotate a vector in space by "degrees" around the Z axis
    public static func RotationZ(degrees: Float) -> Matrix4 {
        let radians: Float = degrees * .pi / 180.0
        return Matrix4(
            column0: Vec4(x: cos(radians),  y: -sin(radians), z: 0.0, w: 0.0),
            column1: Vec4(x: sin(radians),  y: cos(radians),  z: 0.0, w: 0.0),
            column2: Vec4(x: 0.0,           y: 0.0,           z: 1.0, w: 0.0),
            column3: Vec4(x: 0.0,           y: 0.0,           z: 0.0, w: 1.0),
        )
    }
    public static func Translation(_ translation: Vec3) -> Matrix4 {
        return Translation(translation.x, translation.y, translation.z)
    }
    // return a Matrix that will displace a Vector by:
    //  translationX - in the x direction,
    //  translationY - in the y direction
    //  translationZ - in the z direction
    public static func Translation(_ translationX: Float, _ translationY: Float, _ translationZ: Float) -> Matrix4 {
        return Matrix4(
            column0: Vec4(x: 1.0, y: 0.0, z: 0.0, w: translationX),
            column1: Vec4(x: 0.0, y: 1.0, z: 0.0, w: translationY),
            column2: Vec4(x: 0.0, y: 0.0, z: 1.0, w: translationZ),
            column3: Vec4(x: 0.0, y: 0.0, z: 0.0, w: 1.0         ),
        )
    }
    // a 2d Projection Matrix that will switch 0, 0 to be the top left corner of the screen
    public static func Orthographic(_ width: Float, _ height: Float, _ nearPlane: Float, _ farPlane: Float)-> Matrix4 {
        return Matrix4(
            column0: Vec4(x: 2 / width, y: 0.0,        z: 0.0,                                 w: -1),
            column1: Vec4(x: 0.0,       y: 2 / height, z: 0.0,                                 w: -1),
            column2: Vec4(x: 0.0,       y: 0.0,        z: -nearPlane / (farPlane - nearPlane), w: 0.0),
            column3: Vec4(x: 0.0,       y: 0.0,        z: 0.0,                                 w: 1.0),
        )
    }
    // a 2d Projection Matrix that will switch 0, 0 to be the top left corner of the screen
    public static func Perspective(_ fieldOfView: Float, _ width: Float, _ height: Float, _ nearPlane: Float, _ farPlane: Float)-> Matrix4 {
        let tanHalfFov: Float = tan((fieldOfView * .pi / 180.0) * 0.5)
        let aspectRatio: Float = width / height

        return Matrix4(
            column0: Vec4(x: 1.0 / (aspectRatio * tanHalfFov), y: 0.0,              z: 0.0,                                              w: 0),
            column1: Vec4(x: 0.0,                              y: 1.0 / tanHalfFov, z: 0.0,                                              w: 0),
            column2: Vec4(x: 0.0,                              y: 0.0,              z: -(farPlane + nearPlane) / (farPlane - nearPlane), w: -(2.0 * farPlane * nearPlane) / (farPlane - nearPlane)),
            column3: Vec4(x: 0.0,                              y: 0.0,              z: -1.0,                                             w: 1.0),
        )        
    }

    // returns a nice looking string representation of the matrix's values inside nice braces
    public func toString() -> String {
        return  """
            Matrix {
                {  \(self.column0.x ), \(self.column1.x ), \(self.column2.x ), \(self.column3.x ) }
                {  \(self.column0.y ), \(self.column1.y ), \(self.column2.y ), \(self.column3.y ) }
                {  \(self.column0.z ), \(self.column1.z ), \(self.column2.z ), \(self.column3.z ) }
                {  \(self.column0.w ), \(self.column1.w ), \(self.column2.w ), \(self.column3.w ) }
            }
            """
    }
    // a way to check if matricies are not the same
    public static func !=(first: Matrix4 , second: Matrix4) -> Bool {
        return first.column0.x != second.column0.x && first.column0.y != second.column0.y && first.column0.z != second.column0.z && first.column0.w != second.column0.w
            && first.column1.x != second.column1.x && first.column1.y != second.column1.y && first.column1.z != second.column1.z && first.column1.w != second.column1.w
            && first.column2.x != second.column2.x && first.column2.y != second.column2.y && first.column2.z != second.column2.z && first.column2.w != second.column2.w
            && first.column3.x != second.column3.x && first.column3.y != second.column3.y && first.column3.z != second.column3.z && first.column3.w != second.column3.w
    }
    // a way to check if matricies are the same
    public static func ==(first: Matrix4 , second: Matrix4) -> Bool {
        return first.column0.x == second.column0.x && first.column0.y == second.column0.y && first.column0.z == second.column0.z && first.column0.w == second.column0.w
            && first.column1.x == second.column1.x && first.column1.y == second.column1.y && first.column1.z == second.column1.z && first.column1.w == second.column1.w
            && first.column2.x == second.column2.x && first.column2.y == second.column2.y && first.column2.z == second.column2.z && first.column2.w == second.column2.w
            && first.column3.x == second.column3.x && first.column3.y == second.column3.y && first.column3.z == second.column3.z && first.column3.w == second.column3.w
    }

}