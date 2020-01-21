<template>
  <main class="page">
    <section id="works">
      <works></works>
    </section>
    <section id="about">
      <h1>{{ $t('About') }}</h1>
      <h2>underconstrucion</h2>
    </section>
    <section id="contacts">
      <h1>{{ $t('Contacts') }}</h1>
      <h2>underconstrucion</h2>
    </section>
  </main>
</template>

<script lang="ts">
import works from '~/components/works.vue'

export default {
  components: { works }
}
</script>

<style lang="stylus" scoped>
main
  > section
    display flex
    justify-content center
    align-items center
    flex-direction column
    >h1
      font-weight normal
      text-transform uppercase
    >h2
      font-weight normal
      text-transform uppercase
      font-size 0.8em

#works
  max-height calc(100vh - 10px)
  >.works
    width 100%
    height 100%
    flex-grow 1
</style>
