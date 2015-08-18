class Todo
  constructor: (data = {}) ->
    @description = m.prop(data.description || '')
    @done = m.prop(false)

  @list: ->
    m.request(method: 'GET', url: '/todos', type: Todo, initialValue: [])
  @save: (list) ->
    data =
      todos: list.filter (t) -> !t.done()
    MyMithril.request(method: 'POST', url: '/todos', data: data)

vm =
  init: ->
    vm.list = Todo.list()
    vm.description = m.prop('')
    vm.entered = m.prop(false)
  add: ->
    if vm.description().length
      todo = new Todo(description: vm.description())
      vm.list().push(todo)
      vm.description('')
      Todo.save(vm.list())
  toggle: (value) ->
    @done(value)
    Todo.save(vm.list())
  onkeyup: (value) ->
    vm.description(value) unless vm.entered()
    vm.entered(false)
  onkeypress: (e) ->
    if e.keyCode == 13
      vm.entered(true)
      vm.add()
    else
      m.redraw.strategy('none')

controller = ->
  vm.init()
  null

view = ->
  m 'div', [
    m '.row', [
      m '.col-sm-4', [
        m '.input-group', [
          m 'input.form-control', {
            value: vm.description()
            onkeyup: m.withAttr('value', vm.onkeyup)
            onkeypress: vm.onkeypress
          }
          m 'span.input-group-btn', m 'button.btn.btn-primary', onclick: vm.add, 'Add'
        ]
      ]
    ]
    m 'div', vm.list().map (t) ->
      textDecoraton = if t.done() then 'line-through' else 'none'
      m '.checkbox', [
        m 'label', [
          m 'input[type=checkbox]', onclick: m.withAttr('checked', vm.toggle.bind(t)), value: t.done()
          m 'span', { style: { textDecoration: textDecoraton } }, t.description()
        ]
      ]
  ]

components.todo =
  component:
    controller: controller
    view: view
  Todo: Todo
  vm: vm
    
