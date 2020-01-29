import { Vector2 } from 'three'

export interface TrackPadDelegate {
  onTrackpadPosition(target: TrackPad, position: Vector2): void
}

export default class TrackPad {
  private isDragging: boolean = false
  private targetEl: HTMLElement
  delegate: TrackPadDelegate
  pointerX = 0
  pointerY = 0
  position = new Vector2(0, 0)
  velocity = new Vector2(0, 0)
  dragVelocity = new Vector2(0, 0)
  friction = 0.95

  constructor(targetEl: HTMLElement) {
    this.targetEl = targetEl
    targetEl.addEventListener('mousedown', this.startDrag.bind(this))
    targetEl.addEventListener('mouseup', this.stopDrag.bind(this))
    targetEl.addEventListener('mousemove', this.drag.bind(this))

    targetEl.addEventListener('touchstart', this.startDrag.bind(this))
    targetEl.addEventListener('touchend', this.stopDrag.bind(this))
    targetEl.addEventListener('touchmove', this.drag.bind(this))

    this.animate()
  }

  setPositon(x: number, y: number) {
    // Todo: make parametric
    y = Math.min(y, 0)
    y = Math.max(y, -350)

    this.position.set(x, y)
    this.delegate && this.delegate.onTrackpadPosition(this, this.position)
  }

  private startDrag() {
    this.isDragging = true
  }

  private stopDrag() {
    this.isDragging = false
  }

  private drag(e: Event) {
    e.preventDefault()
    if (!this.isDragging) {
      return
    }

    if (!window.event) {
      return
    }

    if (window.event.type === 'mousemove') {
      const mouseEvent = <MouseEvent>window.event
      this.dragVelocity.set(mouseEvent.movementX, mouseEvent.movementY)
    } else {
      const touchEvent = <TouchEvent>window.event
      const touch = touchEvent.touches[0]
      const deltaX = this.pointerX - touch.clientX
      const deltaY = this.pointerY - touch.clientY
      this.pointerX = touch.clientX
      this.pointerY = touch.clientY
      this.dragVelocity.set(deltaX, deltaY)
    }
  }

  private animate() {
    this.update()
    window.requestAnimationFrame(this.animate.bind(this))
  }

  update() {
    this.applyDragForce()
    this.velocity.multiplyScalar(this.friction)
    this.position.add(this.velocity)
    this.setPositon(this.position.x, this.position.y)
    this.delegate && this.delegate.onTrackpadPosition(this, this.position)
  }

  applyForce(force: Vector2) {
    this.velocity.add(force)
  }

  applyDragForce() {
    if (!this.isDragging) {
      return
    }

    this.applyForce(this.dragVelocity.multiplyScalar(0.1))
  }
}
