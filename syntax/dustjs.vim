" dustjs.vim - Dustjs syntax
" Language:	Dustjs
" Author:	Jimmy Chan <jimmyhchan@gmail.com>
" Version:	1
" Last Change:  March 13th 2012
" References:	
"   [Dust](http://akdubya.github.com/dustjs/)
"
" Licensed under the same terms as Vim itself.
" 
" ================================================================================


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Standard HiLink will not work with included syntax files
if version < 508
  command! -nargs=+ HtmlHiLink hi link <args>
else
  command! -nargs=+ HtmlHiLink hi def link <args>
endif


" variables ({hello}) 
syntax region dustVariable matchgroup=dustMarker start=+{+ end=+}+ containedin=@htmldustContainer oneline
  " special characters (space, newline, return, left brace, right brace)
  syn match dustSpecialChars /\%(\~s\>\|\~n\>\|\~r\>\|\~lb\>\|\~rb\>\)/ containedin=dustVariable contained
  " escaping encoding filters (disable escape - s, force html escape - h, js encodeURI - u, js encodeURI component -uc, force js escape- j)
   syntax match dustFilters /\%(|s\>\||h\>\||u\>\||uc\>\||j\>\)/ containedin=dustVariable contained


" looping and other block type tags (section, exists, notexists, partial, block, helper, pragma ) [ #?^<+@% ]  
syntax region dustNodeSections  matchgroup=dustSection start=+{[#?^<+@%]+ end=+}+ containedin=@htmldustContainer oneline
syntax region dustInlinePartial matchgroup=dustSection start=+{[>]+ end=+\/}+ containedin=@htmldustContainer  oneline
syntax region dustInlinePartialError matchgroup=dustError start=+{[>]+ end=+[^/]}+ containedin=@htmldustContainer  oneline
syntax region dustEndTag matchgroup=dustEndSection start=+{[/]+ end=+}+ oneline

" logic tags
syn match dustConditional /\<\%(\:else\)\>/ containedin=dustSection contained
" TODO: dustConditionalError  make {:else} outside a dust Section error


" Comments
syntax region dustComment start=+{!+ end=+!}+ contains=Todo containedin=htmlHead


" Clustering
" TODO: ??
" syntax cluster dustInside add=
syntax cluster htmldustContainer add=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6


" Hilighting
HtmlHiLink dustMarker Statement
HtmlHiLink dustVariable Statement
HtmlHiLink dustSpecialChars Characters
HtmlHiLink dustFilters Special

HtmlHiLink dustNodeSections Identifier
HtmlHiLink dustSection Repeat
HtmlHiLink dustInlinePartial Include
HtmlHiLink dustEndTag Identifier
HtmlHiLink dustEndSection Repeat

HtmlHiLink dustComment Comment
HtmlHiLink dustConditional Conditional

HtmlHiLink dustError Error
HtmlHiLink dustInlinePartialError Error

let b:current_syntax = "dustjs"
delcommand HtmlHiLink
