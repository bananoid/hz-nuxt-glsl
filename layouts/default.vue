<template>
  <div class="layout">
    <menu>
      <div class="logo">Giosuè Russo</div>
      <ul>
        <li v-for="item in menu" :key="item.label">
          <template v-if="item.section">
            <a :href="item.section">
              {{ item.label }}
            </a>
          </template>
          <template v-if="item.link">
            <a :href="item.link">
              {{ item.label }}
            </a>
          </template>
        </li>
      </ul>
      <ul>
        <li>
          <nuxt-link :to="switchLocalePath('en')">ENG</nuxt-link>
        </li>
        <li>
          <nuxt-link :to="switchLocalePath('ja')">日本語</nuxt-link>
        </li>
      </ul>
    </menu>
    <nuxt />
    <footer>All right reserved Giosuè Russo 2019</footer>
  </div>
</template>

<script lang="js">
export default {
  data() {
    return {
      menu: [
        {
          label: this.$t('Works'),
          section: '#works'
        },
        {
          label: this.$t('About'),
          section: '#about'
        },
        {
          label: this.$t('Contacts'),
          section: '#contacts'
        },
        {
          label: this.$t('Instagram'),
          link: 'https://www.instagram.com/makitorin/'
        }
      ]
    }
  }
}
</script>

<style lang="stylus">
*
  box-sizing border-box

body
  background-color alpha(#fff,1.0)
  // font-family: 'Roboto', sans-serif;
  font-family: 'Raleway', 'Noto Sans JP', sans-serif

.layout
  // background-color alpha(#f00,0.3)
  min-height 100vh
  position relative
  display flex
  flex-direction column
  letter-spacing 0.1em
  > menu
    background-color alpha(#fff,0.9)
    display flex
    justify-content space-between
    min-height 40px
    position sticky
    top 0
    left 0
    >.logo
      padding 0px 16px
      display flex
      justify-content center
      align-items center
      text-transform uppercase
      // background-color alpha(#f00,0.3)

    > ul
      display flex
      > li
        > a
          padding 0px 16px
          display flex
          justify-content center
          align-items center
          // background-color alpha(#f00,0.3)
          text-decoration none
          color #333
          height 40px
          text-transform uppercase
          position relative
          &:hover
            background-color alpha(#fff,1)
            opacity 0.6
          &:active
            background-color alpha(#fff,1)
            opacity 0.3

        //   &:after
        //     content ""
        //     position absolute
        //     top 8px
        //     bottom 8px
        //     width 2px
        //     right -1px
        //     background-color alpha(#000,0.2)
        // &:last-child
        //   > a
        //     &:after
        //       display none



  >.page
    flex-grow 1
    >section
      background-color alpha(#fff,0.3)
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
