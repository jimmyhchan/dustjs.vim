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


"Comment 
"  starts with '{!'
"  contain anything but '!}', including whitespace and newline
"  ends with '!}'
syntax region dustComment start=+{!+ end=+!}+ contains=Todo containedin=@htmldustContainer

"Basic Units
"  key = [a-zA-Z_$][0-9a-zA-Z_$]*
"  path = .key
"  filter = a bar followed by some key --- escaping encoding filters (disable escape - s, force html escape - h, js encodeURI - u, js encodeURI component -uc, force js escape- j)
"  literal = syntax region xString    #empty string or a literal (contained in 'value of a param' and 'name of a partial'), not a tag and not eol
"  inline_part = special, reference or an unquoted literal (contained in 'value of a param' and 'name of a partial')
syn match dustKey /\v[a-zA-Z_$][0-9a-zA-Z_$]*/  contained
syn match dustPath /\v\.?[a-zA-Z_$]?[.0-9a-zA-Z_$]*/ contained
syn match dustFilter /\%(|s\>\||h\>\||u\>\||uc\>\||j\>\)/ containedin=dustRef contained
syn cluster dustIdentifier contains=dustKey,dustPath 
syn region dustInline matchgroup=dustInlineContent start=/"/ skip=/\\"/ end=/"/ containedin=@dustParams contained contains=@dustInlinePart
syn cluster dustInlinePart contains=dustSpecial,dustLiteral 
syn match dustLiteral /\v[^"]*/ containedin=@dustInlinePart contained

syn match dustContext /\v:[a-zA-Z_$][0-9azA-Z_$]*/ containedin=dustStartSectionTag,dustSelfClosingSectionTag,dustPartial contained 
syn region dustParamKey matchgroup=dustParamKeyContent start=/[\t ]/ end=/=/ containedin=@dustParams contained contains=dustKey nextgroup=dustParamValue oneline
syn region dustParamValue matchgroup=dustParamValueContent start=/=\"?/ end=/["\t]|$/ containedin=@dustParams contained contains=@dustIdentifier,dustInline oneline
syn cluster dustParams contains=dustParamKey,dustParamValue

"Specials (space, newline, return, left brace, right brace)
"  starts with a '{~'
"  followed immediately by a key
"  followed immediately by a '}'
syn match dustSpecialChars /\%({\~s\}\|{\~n\}\|{\~r\}\|{\~lb\}\|{\~rb\}\)/ 

"References
"  starts with a '{'
"  followed immediately by an identifier
"  followed immediately by a '}'
syn match dustRef /\v\{[.0-9a-zA-Z_$|]*\}/ contains=@dustIdentifier,dustFilter containedin=@htmldustContainer
" syn match dustRef /{.\?[0-9a-zA-Z_$|]*}/ 
" syn region dustRef  start=/{/ end=/}/ oneline contains=@dustIdentifier,dustFilter

"Section endtag
"  starts with a '{/'
"  followed immediately by an identifier
"  followed immediately by a '}'
syn match dustEndSectionTag /\v\{\/([.0-9a-zA-Z_$])*\}/ contains=@dustIdentifier


"Section start_tag (all in one line)
"  starts with '{[#?^<+@%]'
"  followed immediately by a sectionName (an identifier)
"  followed immediately by a sectionContext context (optional) -- ':' followed immediately by a key or path
"  followed immediately by many param(s) (optional) -- whitespace, key, '=', key|path|inline
"  followed immediately by a '}'
syn match dustStartSectionTag /\v\{[#?^<+@%][a-zA-Z_$.0-9]+(:[.a-zA-Z_$0-9]+)?( [a-zA-Z0-9_$]+\="?[^"]*"?)*\}/ contains=@dustIdentifier,dustContext,@dustParams
syn match dustSelfClosingSectionTag /\v\{[#?^<+@%][a-zA-Z_$.0-9]+(:[a-zA-Z_$0-9]+)?( [a-zA-Z0-9_$]+\="?[^"]*"?)*\/\}/ contains=@dustIdentifier,dustContext,@dustParams

"Partial self closing tag (all in one line)
"  starts with a '{>'
"  followed immediately by a key or an inline
"  followed immediately by context (optional) -- ':' followed immediately by a key or path
"  followed immediately by a '}'
syn region dustPartial matchgroup=dustPartialContent  start=/{>/ end=/\/}/ contains=dustKey,dustInline,dustContext,dustPartialParamError oneline
syn match dustPartialParamError /\v( [a-zA-Z0-9_$]+\="[^"]*")*/  containedin=dustPartial contained 


"Section else conditional
"  starts with a '{:'
"  followed immediately by an key
"  followed immediately by a '}'
syn match dustConditional /\v\{:[a-zA-Z_$][0-9a-zA-Z_$]*\}/ 




" Clustering
" TODO: ??
" syntax cluster dustInside add=
syntax cluster htmldustContainer add=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6


" Hilighting
HtmlHiLink dustKey Identifier
HtmlHiLink dustPath Include
HtmlHiLink dustRef Statement
HtmlHiLink dustSpecialChars Character
HtmlHiLink dustFilter Special

HtmlHiLink dustStartSectionTag Repeat
HtmlHiLink dustSelfClosingSectionTag Repeat
HtmlHiLink dustContext Special

" HtmlHiLink dustParams Special
" HtmlHiLink dustParamKey Special
" HtmlHiLink dustParamKeyContent Error
" HtmlHiLink dustParamValue Special
" HtmlHiLink dustParamValueContent Error
" HtmlHiLink dustInline Error
" HtmlHiLink dustInlineContent Error

HtmlHiLink dustPartial Include
HtmlHiLink dustPartialContent Include

HtmlHiLink dustEndSectionTag Repeat

HtmlHiLink dustComment Comment
HtmlHiLink dustConditional Conditional

HtmlHiLink dustError Error
HtmlHiLink dustPartialParamError Error

let b:current_syntax = "dustjs"
delcommand HtmlHiLink
