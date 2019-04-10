if !(ld$?) =>
  # ldQ: wrapper version
  ld$obj = (dom) -> dom <<< ld$obj.prototype
  ld$ = -> new ld$obj it
  ld$obj.prototype = do
    find: (s, n) ->
      if s instanceof HTMLElement => return s
      if n == 0 => return @querySelector s
      ret = Array.from(@querySelectorAll s)
      if n => ret[n] else ret
    index: -> Array.from(@parentNode.childNodes).indexOf(@)
    child: -> Array.from(@childNodes)
    parent: (s, e = document) ->
      n = @; while n and n != e => n = n.parentNode # must under e
      if n != e => return null
      n = @; while n and n != e and n.matches and !n.matches(s) => n = n.parentNode # must match s selector
      if n == e and (!e.matches or !e.matches(s)) => return null
      return n
    cls: (o) -> for k,v of o => @classList[if v => \add else \remove] k
    attr: (n,v) -> if !v? => @getAttribute(n) else @setAttribute n, v
    on: (n,cb) -> @addEventListener n, cb
    remove: -> @parentNode.removeChild @
    insertAfter: (n, s) -> @insertBefore n, s.nextSibling

  # ldQ: direct function call
  for k,v of ld$obj.prototype => ((k,v) -> ld$[k] = (z, ...args) -> v.apply z, args)(k,v)
  ld$ <<< do
    fetch: (u, o, opt={}) -> fetch(u, o).then ->
      if !(it and it.ok) => e = (new Error!) <<< {data: it}; throw e
      else if opt.type? => it[opt.type]! else it
    create: (o) ->
      n = document.createElement(o.name)
      n.style <<< o.style if o.style
      n.classList.add.apply n.classList, o.className if o.className
      n.innerText = o.text if o.text
      n.innerHTML = o.html if o.html
      n

  # ldQ: pollute Native DOM
  # HTMLElement.prototype <<< ld$obj.prototype
