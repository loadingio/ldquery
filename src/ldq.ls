if !(ld$?) =>
  # ldQ: wrapper version
  ld$obj = (dom) -> dom <<< ld$obj.prototype
  ld$ = -> new ld$obj it
  ld$obj.prototype = do
    find: (s, n) ->
      if !((r = @).querySelector) => [r,s,n] = [document, r.toString!, s]
      if s instanceof HTMLElement => return s
      try
        if n == 0 => return r.querySelector s
        ret = Array.from(r.querySelectorAll s)
        if n => ret[n] else ret
      catch e
        console.warn "ld$.find exception: #s / #n under ", r
        throw e
    index: -> Array.from(@parentNode.childNodes).indexOf(@)
    child: -> Array.from(@childNodes)
    parent: (s, e = document) ->
      n = @; while n and n != e => n = n.parentNode # must under e
      if n != e => return null
      # must match s selector
      n = @; while n and n != e and (!n.matches or (n.matches and !n.matches(s))) => n = n.parentNode
      if n == e and (!e.matches or !e.matches(s)) => return null
      return n
    cls: (o) -> for k,v of o => @classList[if v => \add else \remove] k
    attr: (n,v) ->
      if typeof(n) == \object => (for k,v of n => @setAttribute(k,v))
      else if !v? => @getAttribute(n) else @setAttribute n, v
    on: (n,cb) -> @addEventListener n, cb
    remove: -> if @parentNode => @parentNode.removeChild @
    insertAfter: (n, s) -> @insertBefore n, s.nextSibling

  # ldQ: direct function call
  for k,v of ld$obj.prototype => ((k,v) -> ld$[k] = (z, ...args) -> v.apply z, args)(k,v)

  # for Creating Element
  ns = {svg: "http://www.w3.org/2000/svg"}

  ld$ <<< do
    json: (v) ->
      try
        return JSON.parse(v)
      catch
        return v
    fetch: (u, o={}, opt={}) -> new Promise (res, rej) ->
      c = {} <<< o
      if opt.json =>
        c <<< body: JSON.stringify(opt.json)
        c.{}headers['Content-Type'] = 'application/json; charset=UTF-8'
      if opt.params => u := u + ("?" + ["#k=#{encodeURIComponent(v)}" for k,v of that].join(\&))
      if ld$.fetch.headers => c.{}headers <<< ld$.fetch.headers
      h = setTimeout (->
        # see "error" section in README.
        rej (new Error("timeout") <<< {id: 1006, message: "timeout", name: "ldError"})
        h := null
      ), (opt.timeout or (20 * 1000))
      fetch(u, c).then (v) ->
        if !h => return
        clearTimeout h
        if !(v and v.ok) => v.clone!text!then (t) ->
          try
            json = JSON.parse(t)
            if (json and json.name == \ldError) =>
              # see "error" section in README.
              return rej new Error("#{v.status} #t") <<< {data: t, code: v.status} <<< json
          catch e
            json = null
          # see "error" section in README.
          return rej(
            new Error("#{v.status} #t") <<< {
              data: t, json: json,
              id: v.status, code: v.status, name: \ldError, message: t
            }
          )
        else res(if opt.type? => v[opt.type]! else v)
    create: (o) ->
      n = if o.ns => document.createElementNS(ns[o.ns] or o.ns, o.name) else document.createElement(o.name)
      n.style <<< o.style if o.style
      [[k,v] for k,v of o.attr].map((p) -> n.setAttribute p.0, p.1) if o.attr
      n.classList.add.apply n.classList, o.className if o.className
      n.innerText = o.text if o.text
      n.innerHTML = o.html if o.html
      n
  ld$.fetch.headers = {}
  # ldQ: pollute Native DOM
  # HTMLElement.prototype <<< ld$obj.prototype
