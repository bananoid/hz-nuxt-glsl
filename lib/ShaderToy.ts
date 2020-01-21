import {
  WebGLRenderer,
  OrthographicCamera,
  Scene,
  PlaneBufferGeometry,
  MeshBasicMaterial,
  Mesh
} from 'three'

export default class ShaderToy {
  canvas: HTMLCanvasElement
  renderer: WebGLRenderer
  camera: OrthographicCamera
  scene: Scene
  plane: PlaneBufferGeometry
  material: MeshBasicMaterial
  width: number = 0
  height: number = 0

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas
    this.renderer = new WebGLRenderer({
      canvas
    })

    this.renderer.autoClearColor = false
    this.camera = new OrthographicCamera(
      -1, // left
      1, // right
      1, // top
      -1, // bottom
      -1, // near,
      1 // far
    )
    this.scene = new Scene()
    this.plane = new PlaneBufferGeometry(2, 2)
    this.material = new MeshBasicMaterial({
      color: '#000000'
    })
    const mesh = new Mesh(this.plane, this.material)
    this.scene.add(mesh)

    this.render()
  }

  resizeRendererToCanvasSize() {
    const width = this.canvas.clientWidth
    const height = this.canvas.clientHeight
    const needResize = this.width !== width || this.height !== height
    this.width = width
    this.height = height
    if (this.renderer && needResize) {
      this.renderer.setSize(width, height, false)
    }
    return needResize
  }

  render() {
    this.resizeRendererToCanvasSize()
    this.renderer.render(this.scene, this.camera)
    requestAnimationFrame(this.render)
  }
}
