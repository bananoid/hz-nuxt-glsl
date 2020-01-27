<template>
  <div class="works">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
// import fragmentShader from '~/assets/shaders/works.frag'
import fragmentShader from '~/assets/shaders/raymarch.glsl'
import ShaderToy from '~/lib/ShaderToy'
/* eslint-disable no-unused-vars */
import TrackPad, { TrackPadDelegate } from '~/lib/TrackPad'

@Component({})
class Works extends Vue implements TrackPadDelegate {
  shaderToys: ShaderToy
  dragStarted: boolean = false
  trackPad: TrackPad
  mounted() {
    const canvas: any = this.$refs.canvas
    this.shaderToys = new ShaderToy(canvas, fragmentShader, true)
    this.trackPad = new TrackPad(canvas)
    this.trackPad.delegate = this
    this.trackPad.setPositon(0, -200)
  }
  onTrackpadPosition(target: TrackPad) {
    this.shaderToys.setMousePosizion(this.trackPad.position)
  }
}
export default Works
</script>

<style lang="stylus" scoped>
.works
  background-color #000
  display flex
  padding 0px
  flex-direction column
  overflow hidden
  >canvas
    width 100%
    flex-grow 1
</style>
