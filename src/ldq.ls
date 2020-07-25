(->
  if !(ld$?) =>
    # ldQ: wrapper version
    ajax-err = (s, d, j) ->
      new Error("#s #d") <<< { data: d, json: j, id: s, code: s, name: \ldError, message: d }
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
        # if no selector - we are testing if s is under e.
        if !s => return @
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

    xhrpar = (u, o, p) ->
      c = {} <<< o
      if p.json =>
        c <<< body: JSON.stringify(p.json)
        c.{}headers['Content-Type'] = 'application/json; charset=UTF-8'
      if p.params => u = u + ("?" + ["#k=#{encodeURIComponent(v)}" for k,v of that].join(\&))
      if ld$.fetch.headers and !p.no-default-headers => c.{}headers <<< ld$.fetch.headers
      return {c, u}

    ld$ <<< do
      json: (v) ->
        try
          return JSON.parse(v)
        catch
          return v
      fetch: (url, o={}, opt={}) -> new Promise (res, rej) ->
        {u,c} = xhrpar(url,o,opt)
        h = setTimeout (->
          # see "error" section in README.
          rej ajax-err(1006, "timeout")
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
                return rej(ajax-err(v.status, t) <<< json)
            catch e
              json = null
            # see "error" section in README.
            return rej( ajax-err(v.status, t, json) )
          else res(if opt.type? => v[opt.type]! else v)

      create: (o) ->
        n = if o.ns => document.createElementNS(ns[o.ns] or o.ns, o.name) else document.createElement(o.name)
        n.style <<< o.style if o.style
        [[k,v] for k,v of o.attr].map((p) -> n.setAttribute p.0, p.1) if o.attr
        n.classList.add.apply n.classList, o.className if o.className
        n.innerText = o.text if o.text
        n.innerHTML = o.html if o.html
        n
    ld$.xhr = (url, o = {}, opt = {}) -> new Promise (res, rej) ->
      {u,c} = xhrpar(url,o,opt)
      x = new XMLHttpRequest!
      x.onreadystatechange = ->
        if x.readyState == XMLHttpRequest.DONE =>
          if x.status == 200 =>
            try
              ret = if opt.type == \json => JSON.parse(x.responseText) else x.responseText
            catch e
              return rej ajax-err(x.status, x.responseText )
            return res ret
          else return rej ajax-err(x.status, x.responseText )
      x.onloadstart = -> opt.progress {percent: 0, val: 0, len: 0}
      if opt.progress =>
        p = (evt) ->
          [val,len] = [evt.loaded, evt.total]
          opt.progress {percent: (val/len), val, len}
        if x.upload => x.upload.onprogress = p else x.onprogress = p
      x.open (c.method or \GET), u, true
      for k,v of (c.headers or {}) => x.setRequestHeader k, v
      x.send c.body

    ld$.fetch.headers = {}
    # ldQ: pollute Native DOM
    # HTMLElement.prototype <<< ld$obj.prototype
    # fetch = require "node-fetch" makes fetch a local variable
    # thus we pre-set it with window.fetch for using fetch in client side.
    if window? =>
      window.ld$ = ld$
      fetch = window.fetch
    if module? =>
      if !fetch? => fetch = require "node-fetch"
      module.exports = ld$
)!
