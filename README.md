# ldQuery

lightweight DOM Helpers.

## Usage

ldQuery provides following functions:

 * find(node, selector, index):
   shorthand for querySelector and querySelectorAll. return array when index is omitted.
 * index(node): index of node in childNodes of its parent.
 * child(node): children of node, in Array.
 * parent(node, selector, endNode):
   search parent(including node) for which matching the selector, until endNode is reached. return null if not found.
 * attr(node, name, value): get attribute "name" if value is omitted. set attribute if value is provided.
 * on(node, name, callback): addEventListener on event name.
 * remove(node): remove node from parent.
 * insertAfter(node, newNode, oldNode): insert newNode after oldNode under node.
 * fetch: fetch api helper. 
 * json(data): handy function to convert things to object.

invoke these functions with ld$, e.g., 

`
    ld$.find(document.body, '.btn', 0) 
`


It also provides in wrapper style:

`
    ld$(document.body).find('.btn', 0)
`


While it's not a good idea but you can pollute the native DOM for a more intuitive way to use these functions:

`
    HTMLElement.prototype <<< ld$obj.prototype
`

This could be enabled by remove the comment mark in corresponding line inside ldq.ls.



## Fetch

ldQuery wraps fetch api with promise-based error handling and some additional parameter.

`
    ld$.fetch(<URL>, <RAWOPTION>, <LDQOPTION>)
      .then ->  ...
      .catch (e) -> # use e.data to get raw response from fetch
`

Common raw options:

 * method: HTTP method. e.g., "POST"
 * body: things to send to server. pass JSON by stringify it.
   - `ld$.fetch "url", {body: JSON.stringify({data: 1})}`
 * headers: header hash. customize your own header here.

Common ldQuery Options:

 * type: indicate the response data type. could be `text` or `json`.
 * json: json object to pass. shorthand for manually setting headers and stringify object.
   - this:
     `ld$.fetch("url", {}, {json: {data: 1}})`
   - is the same with this:
     `ld$.fetch("url", {body: "{data: 1}", headers: {'Content-Type': 'application/json; charset=UTF-8'}})`
 * params: shorthand for setting get params. expect an object with key/value pair. will convert it to querystring.
   - this:
     `ld$.fetch("url", {}, {params: {qs: "some text"}}
   - is the same with this:
     `ld$.fetch("url?qs=some%20text", {}, {})


You can also config global headers by updating values in ld$.fetch.headers:

`
    ld$.fetch.headers["X-CSRF-TOKEN"] = ...
`


## Compatibility

ldQuery uses following modern web features:

 * fetch api - not support in IE, Older Edge ( <= 13). Use polyfill to support to IE >= 11
 * classList - not support well in IE. Use Polyfill to fix this.
 * Array.from - not supported in IE. Use Polyfill to fix this.


## License

MIT License.
