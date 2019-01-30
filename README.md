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

invoke these functions with ld$, e.g., 

````
    ld$.find(document.body, '.btn', 0) 
````


It also provides in wrapper style:

````
    ld$(document.body).find('.btn', 0)
````


While it's not a good idea but you can pollute the native DOM for a more intuitive way to use these functions:

````
    HTMLElement.prototype <<< ld$obj.prototype
````

This could be enabled by remove the comment mark in corresponding line inside ldq.ls.



# License

MIT License.
