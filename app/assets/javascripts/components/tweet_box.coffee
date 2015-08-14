class Tweet
  @TEXT_MAX = 140

  constructor: (data = {}) ->
    @text = m.prop(data.text || '')
  remainingCharacters: ->
    Tweet.TEXT_MAX - @text().length
  isOverflow: ->
    @remainingCharacters() < 0
  beforeOverflowText: ->
    @text().slice(Tweet.TEXT_MAX - 10, Tweet.TEXT_MAX)
  overflowText: ->
    @text().slice(Tweet.TEXT_MAX)

vm =
  init: ->
    vm.tweet = new Tweet()

controller = ->
  vm.init()
  @tweet = (e) ->
    url = "https://twitter.com/intent/tweet?text=#{encodeURIComponent(vm.tweet.text())}"
    open(url)
  null

view = (ctrl) ->
  overflowAlert = if vm.tweet.isOverflow()
                    m 'div.alert.alert-warning', [
                      m 'strong', 'Oops! Too Long: ...'
                      m 'span', vm.tweet.beforeOverflowText()
                      m 'strong.bg-danger', vm.tweet.overflowText()
                    ]
                  else
                    m 'span'
  m 'div', [
    m '.row', [
      m '.col-sm-6', [
        m 'div.well', [
          overflowAlert
          m 'p', [
            m 'textarea[rows=3].form-control', { onkeyup: m.withAttr('value', vm.tweet.text) }, vm.tweet.text()
          ]
          m 'p', [
            m 'span', vm.tweet.remainingCharacters()
            m 'button.btn.btn-primary.pull-right', { onclick: ctrl.tweet }, 'Tweet'
          ]
        ]
      ]
    ]
  ]

components.tweetBox =
  component:
    controller: controller
    view: view
  Tweet: Tweet
  vm: vm
    
