<template>
  <main class="page">
    <section id="works">
      <h1>{{ $t('Works') }}</h1>
      <h2>underconstrucion</h2>
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
export default {
  components: {}
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
</style>
