Vim for Dustjs
================

based on github.com/juvenn/mustache.vim.git
dustjs.vim for working with dust js templates (http://akdubya.github.com/dustjs/). 


### Install for pathogen

    cd ~/.vim/
    git submodule add git://github.com/jimmyhchan/dustjs.vim.git bundle/dustjs
    vim bundle/dustjs/example.dust


## extra stuff added for working with other plugins
* NERDCommenter
 add this:
   let g:NERDCustomDelimiters = {
     'dustjs': { 'left': '{!', 'right': '!}' }
   }

* tpope's surround
   let g:surround_{char2nr('d')} = "{\r}"
* snipmate (https://github.com/garbas/vim-snipmate)
   snipmate should be pathogen aware so it should work out of the box 

## Thanks
* [Github/juvenn](/juvenn) for the mustache.vim plugin
* [Github/akdubya](/akdubya) for dust.js


