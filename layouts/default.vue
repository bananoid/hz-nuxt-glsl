<template>
  <div class="layout">
    <main-header />
    <nuxt />
    <footer>All right reserved Giosuè Russo 2019</footer>
  </div>
</template>

<script lang="js">
import mainHeader from '~/components/header.vue'

export default {
  components:{ mainHeader },
  data() {
    return {
    }
  }
}
</script>

<style lang="stylus">
*
  box-sizing border-box

body
  background-color #000
  color #fff
  // font-family: 'Roboto', sans-serif;
  font-family: 'Raleway', 'Noto Sans JP', sans-serif

.layout
  // background-color alpha(#f00,0.3)
  min-height 100vh
  position relative
  display flex
  flex-direction column
  letter-spacing 0.1em

  >.page
    flex-grow 1
    >section
      min-height calc(100vh - 60px)
      // border 8px solid #f00
  > footer
    // background-color alpha(#000,0.1)
    padding 0px 8px
    display flex
    justify-content center
    align-items center
    min-height 32px
    font-size 0.6em
.grid
  background-color #00f
</style>
