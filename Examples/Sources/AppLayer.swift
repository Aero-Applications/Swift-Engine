import Engine_Platform;
import Engine_Graphics;
import Engine_Core;
import Engine_Math;

@MainActor
class AppLayer : Layer {

    struct ShaderData {
        let projection: Matrix4;
        let view: Matrix4;
        let model: Matrix4;
    }

    let shader: Shader
    let mesh: Mesh
    let buffer: ShaderBuffer

    let projection : Matrix4
    let view : Matrix4
    var rotation : Vec3 = Vec3(x: 0.0, y: 0.0, z: 0.0)
    var pos: Vec3 = Vec3(x: 0.0, y: 0.0, z: -10.0)

    override init() {
        self.shader = Shader.Create(filePath: "");

        let vertecies: [Mesh.Vertex] = [
            Mesh.Vertex(Vec3(x: -0.5, y: -0.5, z: -0.0)),
            Mesh.Vertex(Vec3(x: 0.0, y: 0.5, z: -0.0)),
            Mesh.Vertex(Vec3(x: 0.5, y: -0.5, z: -0.0))
        ]

        let indecies: [UInt32] = [
            0,
            1,
            2
        ]
        
        self.mesh = Mesh(vertecies: vertecies.span, indecies: indecies.span);

        self.projection = Matrix4.Perspective(90, Application.Get().window.width, Application.Get().window.height, 0.01, 100)
        self.view = Matrix4.Identity()

        self.buffer = ShaderBuffer.Create(data: ShaderData(
            projection: self.projection,
            view: self.view,
            model: Self.CalculateModelMatrix(self.pos, self.rotation),
        ))

        super.init()
    }

    override func render() {
        Graphics.SetShader(shader: shader)
        Graphics.UploadShaderBuffer(data: buffer)

        Graphics3D.RenderMesh(mesh: mesh)
    }

    override func mouseDragged(event: MouseEvent) {
        let xVelocity: Float = event.getXVelocity()
        let yVelocity: Float = event.getYVelocity()

        rotation.x += xVelocity
        rotation.y += yVelocity

        buffer.update(data: ShaderData(projection: self.projection, view: self.view, model: Self.CalculateModelMatrix(self.pos, self.rotation)))
    }

    override func mouseScrolled(event: ScrollEvent) {
        let delta: Float = event.getDelta()

        self.pos.z += delta
        if (pos.z > -1.0){
            pos.z = -1.0
        }
        if (pos.z < -100) {
            pos.z = -100
        }

        buffer.update(data: ShaderData(projection: self.projection, view: self.view, model: Self.CalculateModelMatrix(self.pos, self.rotation)))
    }

    @MainActor
    static func CalculateModelMatrix(_ pos: Vec3, _ rotation: Vec3) -> Matrix4 {
        return Matrix4.Translation(pos).multiply(Matrix4.RotationX(degrees: rotation.y)).multiply(Matrix4.RotationY(degrees: rotation.x));
    }
}