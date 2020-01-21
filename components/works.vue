<template>
  <div class="works">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import fragmentShader from '~/assets/shaders/works.frag'
import ShaderToy from '~/lib/ShaderToy'

@Component({})
class Works extends Vue {
  shaderToys: ShaderToy
  mounted() {
    const canvas: any = this.$refs.canvas
    this.shaderToys = new ShaderToy(canvas, fragmentShader)
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
