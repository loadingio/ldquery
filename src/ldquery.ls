HTMLElement.prototype <<< do
  find: (s, n) ->
    if n == 0 => return @querySelector s
    ret = Array.from(@querySelectorAll s)
    if n => ret[n] else ret
  index: -> Array.from(@parentNode.childNodes).indexOf(@)
  child: -> Array.from(@childNodes)
  parent: (s, e = document) ->
    n = @; while n and n != e => n = n.parentNode # must under e
    if n != e => return null
    n = @; while n and n != e and !n.matches(s) => n = n.parentNode # must match s selector
    if n == e and !e.matches(s) => return null
    return n
  attr: (n,v) -> if !v? => @getAttribute(n) else @setAttribute n, v
  on: (n,cb) -> @addEventListener n, cb
  remove: -> @parentNode.removeChild @
  insertAfter: (n, s) -> s.parentNode.insertBefore n, s.nextSibling
