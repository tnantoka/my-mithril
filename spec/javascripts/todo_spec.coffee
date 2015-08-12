todo = components.todo

describe 'Todo', ->
  describe 'model', ->
    describe '#constructor', ->
      it 'can create instance without options', ->
        t = new todo.Todo()
        expect(t.description()).toBe('')
        expect(t.done()).toBe(false)
      it 'can create instance with initial values', ->
        t = new todo.Todo(description: 'buy milk')
        expect(t.description()).toBe('buy milk')
        expect(t.done()).toBe(false)

    describe 'server access', ->
      sinon.xhr.supportsCORS = true
      server = null
      beforeEach ->
        server = sinon.fakeServer.create()
        server.respondImmediately = true
        m.deps({ XMLHttpRequest: server.xhr })
      afterEach ->
        server.restore()

      describe '.list', ->
        it 'can create single object from request', (done) ->
          server.respondWith 'GET', '/todos', [
            200
            { 'Content-Type': 'application/json' }
            JSON.stringify(description: 'buy milk')
          ]
          todo.Todo.list().then (t) ->
            expect(t.description()).toBe('buy milk')
            done()
          server.respond() # FIXME: `server.respondImmediately = true` doesn't work?

      describe '.save', ->
        it 'can store objects', ->
          t = new todo.Todo(description: 'buy milk')
          todo.Todo.save([t])
          r = server.requests[0]
          expect(r.method).toBe('POST')
          expect(r.url).toBe('/todos')
          body = JSON.parse(r.requestBody)
          expect(body.todos[0].description).toBe('buy milk')

  describe 'vm', ->
    beforeEach ->
      spyOn(todo.Todo, 'save').and.callThrough()

    describe '#init', ->
      it 'can initialize vm', ->
        todo.vm.init()
        expect(todo.vm.description()).toBe('')

    describe '.add', ->
      it 'can add todo', ->
        todo.vm.init()

        todo.vm.description('buy milk')
        todo.vm.add()

        expect(todo.vm.list()[0].description()).toBe('buy milk')
        expect(todo.Todo.save).toHaveBeenCalled()

    describe '.toggle', ->
      it 'can toggle todo.done', ->
        t = new todo.Todo()
        toggle = todo.vm.toggle.bind(t)
        toggle(true)

        expect(t.done()).toBe(true)
        expect(todo.Todo.save).toHaveBeenCalled()

    describe '.onkeypress', ->
      beforeEach ->
        spyOn(todo.vm, 'add').and.callThrough()
        spyOn(m.redraw, 'strategy').and.callThrough()

      describe 'with enter key', ->
        it 'can call vm.add', ->
          todo.vm.init()
          todo.vm.onkeypress(keyCode: 13)
          expect(todo.vm.add).toHaveBeenCalled()

      describe 'without enter key', ->
        it 'can call m.redraw.strategy with none', ->
          todo.vm.init()
          todo.vm.onkeypress({})
          expect(m.redraw.strategy).toHaveBeenCalledWith('none')

  describe 'controller', ->
    beforeEach ->
      spyOn(todo.vm, 'init').and.callThrough()

    describe '#constructor', ->
      it 'can call vm.init', ->
        new todo.component.controller()
        expect(todo.vm.init).toHaveBeenCalled()

  describe 'view', ->
    it 'has no item', ->
      ctrl = new todo.component.controller()
      view = todo.component.view(ctrl)
      expect(view.children[1].children.length).toBe(0)
    it 'has three items', ->
      ctrl = new todo.component.controller()
      todo.vm.list ['task1', 'task2', 'task3'].map (desc) ->
        new todo.Todo(description: desc)
      todo.vm.list()[0].done(true)
      view = todo.component.view(ctrl)
      expect(view.children[1].children.length).toBe(3)


