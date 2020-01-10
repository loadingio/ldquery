// Generated by LiveScript 1.3.1
var ld$obj, ld$, k, ref$, v, ns, slice$ = [].slice;
if (!(typeof ld$ != 'undefined' && ld$ !== null)) {
  ld$obj = function(dom){
    return import$(dom, ld$obj.prototype);
  };
  ld$ = function(it){
    return new ld$obj(it);
  };
  ld$obj.prototype = {
    find: function(s, n){
      var ret;
      if (s instanceof HTMLElement) {
        return s;
      }
      if (n === 0) {
        return this.querySelector(s);
      }
      ret = Array.from(this.querySelectorAll(s));
      if (n) {
        return ret[n];
      } else {
        return ret;
      }
    },
    index: function(){
      return Array.from(this.parentNode.childNodes).indexOf(this);
    },
    child: function(){
      return Array.from(this.childNodes);
    },
    parent: function(s, e){
      var n;
      e == null && (e = document);
      n = this;
      while (n && n !== e) {
        n = n.parentNode;
      }
      if (n !== e) {
        return null;
      }
      n = this;
      while (n && n !== e && (!n.matches || (n.matches && !n.matches(s)))) {
        n = n.parentNode;
      }
      if (n === e && (!e.matches || !e.matches(s))) {
        return null;
      }
      return n;
    },
    cls: function(o){
      var k, v, results$ = [];
      for (k in o) {
        v = o[k];
        results$.push(this.classList[v ? 'add' : 'remove'](k));
      }
      return results$;
    },
    attr: function(n, v){
      var k, results$ = [];
      if (typeof n === 'object') {
        for (k in n) {
          v = n[k];
          results$.push(this.setAttribute(k, v));
        }
        return results$;
      } else if (v == null) {
        return this.getAttribute(n);
      } else {
        return this.setAttribute(n, v);
      }
    },
    on: function(n, cb){
      return this.addEventListener(n, cb);
    },
    remove: function(){
      if (this.parentNode) {
        return this.parentNode.removeChild(this);
      }
    },
    insertAfter: function(n, s){
      return this.insertBefore(n, s.nextSibling);
    }
  };
  for (k in ref$ = ld$obj.prototype) {
    v = ref$[k];
    fn$(k, v);
  }
  ns = {
    svg: "http://www.w3.org/2000/svg"
  };
  import$(ld$, {
    json: function(v){
      var e;
      try {
        return JSON.parse(v);
      } catch (e$) {
        e = e$;
        return v;
      }
    },
    fetch: function(u, o, opt){
      o == null && (o = {});
      opt == null && (opt = {});
      return new Promise(function(res, rej){
        var c, that, k, v, h;
        c = import$({}, o);
        if (opt.json) {
          c.body = JSON.stringify(opt.json);
          (c.headers || (c.headers = {}))['Content-Type'] = 'application/json; charset=UTF-8';
        }
        if (that = opt.params) {
          u = u + ("?" + (function(){
            var ref$, results$ = [];
            for (k in ref$ = that) {
              v = ref$[k];
              results$.push(k + "=" + encodeURIComponent(v));
            }
            return results$;
          }()).join('&'));
        }
        if (ld$.fetch.headers) {
          import$(c.headers || (c.headers = {}), ld$.fetch.headers);
        }
        h = setTimeout(function(){
          var ref$;
          rej((ref$ = new Error("timeout"), ref$.id = 1006, ref$.message = "timeout", ref$.name = "ldError", ref$));
          return h = null;
        }, opt.timeout || 20 * 1000);
        return fetch(u, c).then(function(v){
          if (!h) {
            return;
          }
          clearTimeout(h);
          if (!(v && v.ok)) {
            return v.clone().text().then(function(t){
              var json, ref$, e;
              try {
                json = JSON.parse(t);
                if (json && json.name === 'ldError') {
                  return rej(import$((ref$ = new Error(v.status + " " + t), ref$.data = t, ref$.code = v.status, ref$), json));
                }
              } catch (e$) {
                e = e$;
                json = null;
              }
              return rej((ref$ = new Error(v.status + " " + t), ref$.data = t, ref$.json = json, ref$.id = v.status, ref$.code = v.status, ref$.name = 'ldError', ref$.message = t, ref$));
            });
          } else {
            return res(opt.type != null ? v[opt.type]() : v);
          }
        });
      });
    },
    create: function(o){
      var n, k, v;
      n = o.ns
        ? document.createElementNS(ns[o.ns] || o.ns, o.name)
        : document.createElement(o.name);
      if (o.style) {
        import$(n.style, o.style);
      }
      if (o.attr) {
        (function(){
          var ref$, results$ = [];
          for (k in ref$ = o.attr) {
            v = ref$[k];
            results$.push([k, v]);
          }
          return results$;
        }()).map(function(p){
          return n.setAttribute(p[0], p[1]);
        });
      }
      if (o.className) {
        n.classList.add.apply(n.classList, o.className);
      }
      if (o.text) {
        n.innerText = o.text;
      }
      if (o.html) {
        n.innerHTML = o.html;
      }
      return n;
    }
  });
  ld$.fetch.headers = {};
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
function fn$(k, v){
  return ld$[k] = function(z){
    var args;
    args = slice$.call(arguments, 1);
    return v.apply(z, args);
  };
}
