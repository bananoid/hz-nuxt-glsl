export default {
  mode: 'universal',
  server: {
    port: 3000, // default: 3000
    host: '0.0.0.0' // default: localhost
  },
  /*
   ** Headers of the page
   */
  head: {
    title: process.env.npm_package_name || '',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || ''
      }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      {
        href:
          'https://fonts.googleapis.com/css?family=Noto+Sans+JP|Raleway|Roboto&display=swap',
        rel: 'stylesheet',
        media: 'screen',
        type: 'text/css'
      }
    ]
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#fff' },
  /*
   ** Global CSS
   */
  css: ['~/assets/styles/reset.styl'],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    // Doc: https://github.com/nuxt-community/eslint-module
    '@nuxtjs/eslint-module',
    '@nuxt/typescript-build'
  ],

  /*
   ** Nuxt.js modules
   */
  modules: [
    [
      'nuxt-i18n',
      {
        /* module options */
      }
    ]
  ],

  i18n: {
    defaultLocale: 'en',
    locales: [
      {
        code: 'en',
        file: 'en.js'
      },
      {
        code: 'ja',
        file: 'ja.js'
      }
    ],
    lazy: true,
    langDir: 'lang/'
  },

  /*
   ** Build configuration
   */
  build: {
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {
      config.module.rules.push(
        {
          test: /\.(glsl|frag|vert)$/,
          loader: 'raw-loader',
          exclude: /node_modules/
        },
        {
          test: /\.(glsl|frag|vert)$/,
          loader: 'glslify-loader',
          exclude: /node_modules/
        }
      )
    }
  }
}
