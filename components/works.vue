<template>
  <div class="works">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'
import ShaderToy from '~/lib/ShaderToy'

@Component({})
class Works extends Vue {
  shaderToys: ShaderToy
  mounted() {
    const canvas: any = this.$refs.canvas
    this.shaderToys = new ShaderToy(canvas)
  }
}
export default Works
</script>

<style lang="stylus" scoped>
.works
  background-color #f00
  display flex
  padding 2px
  >canvas
    flex-grow 1
</style>
