#About

The parser folder contains a simple ruby programm to convert the *latex* notes into plain *html* with minor modifications to work with [bootstrap](http://getbootstrap)

#Todo

* Parser for **bibtex**
* Implement syntax highlighting (DONE with javascript)

##Hihglighting code

We are using [prettify.js](http://code.google.com/p/google-code-prettify/) in the html version to do that. But given that notes are static, it would be better to do so with pygments.rb.
