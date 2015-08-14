tweetBox = components.tweetBox

describe 'TweetBox', ->
  describe 'model', ->
    describe '#constructor', ->
      it 'can create instance without options', ->
        t = new tweetBox.Tweet()
        expect(t.text()).toBe('')
      it 'can create instance with initial values', ->
        t = new tweetBox.Tweet(text: 'tweet')
        expect(t.text()).toBe('tweet')
    describe '#remainingCharacters', ->
      it 'can return remaining characters', ->
        s = ('a' for i in [0...10]).join('')
        t = new tweetBox.Tweet(text: s)
        expect(t.remainingCharacters()).toBe(130)
    describe '#isOverflow', ->
      it 'can return text is overflow or not', ->
        s = ('a' for i in [0...140]).join('')
        t = new tweetBox.Tweet(text: s)
        expect(t.isOverflow()).toBe(false)

        s += 'b'
        t.text(s)
        expect(t.isOverflow()).toBe(true)
    describe '#OverflowText', ->
      it 'can return text before overflow', ->
        s = ('a' for i in [0...139]).join('')
        s += 'bc'
        t = new tweetBox.Tweet(text: s)

        expect(t.beforeOverflowText()).toBe('aaaaaaaaab')
        expect(t.overflowText()).toBe('c')

  describe 'vm', ->
    describe '#init', ->
      it 'can initialize vm', ->
        tweetBox.vm.init()
        expect(tweetBox.vm.tweet.text()).toBe('')

  describe 'controller', ->
    describe '#constructor', ->
      beforeEach ->
        spyOn(tweetBox.vm, 'init').and.callThrough()
      it 'can call vm.init', ->
        new tweetBox.component.controller()
        expect(tweetBox.vm.init).toHaveBeenCalled()

    describe '#tweet', ->
      beforeEach ->
        spyOn(window, 'open')
      it 'can call window.open with url', ->
        ctrl = new tweetBox.component.controller()
        tweetBox.vm.tweet.text('tweet')
        ctrl.tweet()
        url = "https://twitter.com/intent/tweet?text=tweet"
        expect(window.open).toHaveBeenCalledWith(url)

  describe 'view', ->
    it 'has no alert', ->
      ctrl = new tweetBox.component.controller()
      view = tweetBox.component.view(ctrl)
      expect(view.children[0].children[0].children[0].children[0].attrs.className).toBe(undefined)
    it 'has alert', ->
      s = ('a' for i in [0...142]).join('')
      ctrl = new tweetBox.component.controller()
      tweetBox.vm.tweet.text(s)
      view = tweetBox.component.view(ctrl)
      expect(view.children[0].children[0].children[0].children[0].attrs.className).toBe('alert alert-warning')

