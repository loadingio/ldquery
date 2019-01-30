# sample usage
body = document.body
[
  ld$(body).find(\div)  # Wrapper
  ld$.find(body, \div)  # Function call
  body.find(\div)       # Native DOM
].map -> console.log it
