" Vim syntax file for Razor (.razor / .cshtml)
" Enhanced regex-based highlighting for HTML + C# embedded in Razor
" This is a workaround until full LSP semantic highlighting is supported

if exists("b:current_syntax")
  finish
endif

" ══════════════════════════════════════════════════════════════
" 1. Load HTML syntax as the base layer
" ══════════════════════════════════════════════════════════════
runtime! syntax/html.vim
unlet! b:current_syntax

" ══════════════════════════════════════════════════════════════
" 2. Load C# syntax into a cluster for embedded use
" ══════════════════════════════════════════════════════════════
syntax include @csharpSyntax syntax/cs.vim
unlet! b:current_syntax

" ══════════════════════════════════════════════════════════════
" 3. Razor directives (@page, @using, @inject, etc.)
" ══════════════════════════════════════════════════════════════
syntax match razorDirective /@\(page\|model\|using\|inject\|inherits\|namespace\|layout\|section\|addTagHelper\|removeTagHelper\|tagHelperPrefix\|attribute\|implements\|typeparam\|preservewhitespace\|rendermode\)\>/ containedin=ALL
syntax match razorFunctions /@\(functions\|code\)\>/ containedin=ALL

" ══════════════════════════════════════════════════════════════
" 4. Razor control flow keywords
" ══════════════════════════════════════════════════════════════
syntax match razorKeyword /@\(if\|else\|for\|foreach\|while\|do\|switch\|case\|default\|try\|catch\|finally\|lock\|using\|await\)\>/ containedin=ALL

" ══════════════════════════════════════════════════════════════
" 5. @code { ... } blocks — full C# highlighting
" ══════════════════════════════════════════════════════════════
syntax region razorCodeBlock matchgroup=razorCodeDelimiter start=/@code\_s*{/ end=/}/ contains=@csharpSyntax,razorCodeBlock keepend fold
syntax region razorFunctionsBlock matchgroup=razorCodeDelimiter start=/@functions\_s*{/ end=/}/ contains=@csharpSyntax,razorFunctionsBlock keepend fold

" ══════════════════════════════════════════════════════════════
" 6. @{ ... } explicit code blocks
" ══════════════════════════════════════════════════════════════
syntax region razorExplicitBlock matchgroup=razorCodeDelimiter start=/@{/ end=/}/ contains=@csharpSyntax,razorExplicitBlock keepend fold

" ══════════════════════════════════════════════════════════════
" 7. Control flow blocks with C# inside
" ══════════════════════════════════════════════════════════════
syntax region razorIfBlock matchgroup=razorKeyword start=/@if\_s*(/ end=/)/ contains=@csharpSyntax keepend
syntax region razorElseIfBlock matchgroup=razorKeyword start=/@else\_s\+if\_s*(/ end=/)/ contains=@csharpSyntax keepend
syntax region razorForBlock matchgroup=razorKeyword start=/@for\_s*(/ end=/)/ contains=@csharpSyntax keepend
syntax region razorForeachBlock matchgroup=razorKeyword start=/@foreach\_s*(/ end=/)/ contains=@csharpSyntax keepend
syntax region razorWhileBlock matchgroup=razorKeyword start=/@while\_s*(/ end=/)/ contains=@csharpSyntax keepend
syntax region razorSwitchBlock matchgroup=razorKeyword start=/@switch\_s*(/ end=/)/ contains=@csharpSyntax keepend
syntax region razorLockBlock matchgroup=razorKeyword start=/@lock\_s*(/ end=/)/ contains=@csharpSyntax keepend

" ══════════════════════════════════════════════════════════════
" 8. Inline C# expressions: @expression and @(expression)
" ══════════════════════════════════════════════════════════════
syntax region razorParenExpr matchgroup=razorExprDelimiter start=/@(/ end=/)/ contains=@csharpSyntax keepend containedin=ALL
syntax match razorInlineExpr /@[A-Za-z_][A-Za-z0-9_]*\(\.[A-Za-z_][A-Za-z0-9_]*\)*\(?\)\?/ containedin=ALL,htmlValue,htmlString,htmlTag
syntax match razorAwaitExpr /@await\s\+[A-Za-z_][A-Za-z0-9_]*\(\.[A-Za-z_][A-Za-z0-9_()]*\)*/ containedin=ALL

" ══════════════════════════════════════════════════════════════
" 9. Razor Components (PascalCase tags like <MyComponent />)
" ══════════════════════════════════════════════════════════════
syntax match razorComponent /<\/\?[A-Z][A-Za-z0-9]*/ containedin=ALL
syntax match razorComponentClose /<\/[A-Z][A-Za-z0-9]*\s*>/ containedin=ALL

" ══════════════════════════════════════════════════════════════
" 10. Razor comments @* ... *@
" ══════════════════════════════════════════════════════════════
syntax region razorComment start=/@\*/ end=/\*@/ containedin=ALL

" ══════════════════════════════════════════════════════════════
" 11. Event handlers and bind attributes
" ══════════════════════════════════════════════════════════════
syntax match razorEventHandler /@on[A-Za-z]\+/ containedin=ALL,htmlTag,htmlArg
syntax match razorEventCallback /@on[A-Za-z]\+:preventDefault\|@on[A-Za-z]\+:stopPropagation/ containedin=ALL,htmlTag,htmlArg
syntax match razorBind /@bind\(-[A-Za-z:]\+\)\?/ containedin=ALL,htmlTag,htmlArg
syntax match razorRef /@ref/ containedin=ALL,htmlTag,htmlArg
syntax match razorTypeparam /@typeparam/ containedin=ALL
syntax match razorRenderMode /@rendermode/ containedin=ALL

" ══════════════════════════════════════════════════════════════
" 12. Razor escape (@@)
" ══════════════════════════════════════════════════════════════
syntax match razorEscape /@@/ containedin=ALL

" ══════════════════════════════════════════════════════════════
" 13. Common C# types used inline
" ══════════════════════════════════════════════════════════════
syntax keyword razorCSharpType string int bool void var List Dictionary Task IEnumerable EventCallback RenderFragment MarkupString containedin=razorCodeBlock,razorFunctionsBlock,razorExplicitBlock

" ══════════════════════════════════════════════════════════════
" Highlighting links
" ══════════════════════════════════════════════════════════════
highlight default link razorDirective        PreProc
highlight default link razorFunctions        PreProc
highlight default link razorKeyword          Conditional
highlight default link razorCodeDelimiter    PreProc
highlight default link razorExprDelimiter    Special
highlight default link razorInlineExpr       Identifier
highlight default link razorAwaitExpr        Identifier
highlight default link razorParenExpr        Special
highlight default link razorComponent        Type
highlight default link razorComponentClose   Type
highlight default link razorComment          Comment
highlight default link razorEventHandler     Special
highlight default link razorEventCallback    Special
highlight default link razorBind             Special
highlight default link razorRef              Special
highlight default link razorTypeparam        PreProc
highlight default link razorRenderMode       PreProc
highlight default link razorEscape           SpecialChar
highlight default link razorCSharpType       Type

let b:current_syntax = "razor"
