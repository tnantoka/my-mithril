Turbolinks.enableProgressBar()

@MyMithril = {
  request: (options) ->
    k = $('meta[name=csrf-param]').prop('content')
    v = $('meta[name=csrf-token]').prop('content')
    options.data[k] = v
    m.request(options)
}

@components = {}
