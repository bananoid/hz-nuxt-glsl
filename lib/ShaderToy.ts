import {
  WebGLRenderer,
  OrthographicCamera,
  Scene,
  PlaneBufferGeometry,
  Mesh,
  ShaderMaterial,
  Vector3
} from 'three'

type UniformValue<T> = {
  value: T
}

type Uniforms = {
  iTime: UniformValue<number>
  iResolution: UniformValue<Vector3>
}

export default class ShaderToy {
  canvas: HTMLCanvasElement
  renderer: WebGLRenderer
  camera: OrthographicCamera
  scene: Scene
  plane: PlaneBufferGeometry
  material: ShaderMaterial
  width: number = 0
  height: number = 0
  uniforms: Uniforms = {
    iTime: { value: 0 },
    iResolution: { value: new Vector3() }
  }

  constructor(canvas: HTMLCanvasElement, fragmentShader: string) {
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

    this.material = new ShaderMaterial({
      fragmentShader,
      uniforms: this.uniforms
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

  render(time: number = 0) {
    time *= 0.001
    this.resizeRendererToCanvasSize()

    this.uniforms.iResolution.value.set(this.width, this.height, 1)
    this.uniforms.iTime.value = time

    this.renderer.render(this.scene, this.camera)
    requestAnimationFrame(this.render.bind(this))
  }
}
