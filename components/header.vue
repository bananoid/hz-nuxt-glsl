<template>
  <menu>
    <div class="logo">HZ</div>
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
        // {
        //   label: this.$t('Instagram'),
        //   link: 'https://www.instagram.com/makitorin/'
        // }
      ]
    }
  }
}
</script>

<style lang="stylus" scoped>
menu
  background-color alpha(#000,0.7)
  display flex
  justify-content space-between
  min-height 40px
  max-width 100%
  overflow hidden
  z-index 100
  visibility hidden //Todo: Reactivate

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
        text-decoration none
        color #fff
        height 40px
        text-transform uppercase
        position relative
        white-space nowrap
        &:hover
          background-color alpha(#fff,0.1)
        &:active
          background-color alpha(#fff,0.2)

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
</style>
