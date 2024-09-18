provide-module surrounds %<

define-command surrounds-select-text -override -params 1 -docstring %<
	surrounds-select-text: expand selection to surround given text
> %<
	execute-keys "<a-/>%arg{1}<ret>?%arg{1}<ret>"
>

define-command surrounds-select-inner -override -docstring %<
	surrounds-select-inner: shrink selection from both sides by one
	character
> %<
	execute-keys '<a-:><a-;>L<a-;>H'
>

define-command surrounds-delete -override -docstring %<
	surrounds-delete: delete first and last characters from inside
	the selection
> %<
	execute-keys 'i<del><esc>a<backspace><esc>'
>

# =============
# surrounds-add
# =============

define-command surrounds-add -override -params 2 -docstring %<
	surrounds-add <before> <after>: insert <before> before the selection,
	and <after> after the selection
> %<
	evaluate-commands -itersel -save-regs '"' %<
		set-register '"' "%arg{1}%reg{dot}%arg{2}"
		execute-keys 'R'
	>
>

define-command surrounds-add-text -override -params 1 -docstring %<
	surrounds-add-text <arg>: surround selection with <arg>
> %<
	surrounds-add %arg{1} %arg{1}
>

define-command surrounds-add-line -override -docstring %<
	surrounds-add-line: surround selection with newlines
> %<
	surrounds-add '
' '
'
	execute-keys '<gt>'
>

define-command surrounds-add-html-tag -override -params 1 -docstring %<
	surrounds-add-html-tag ?: surround selection with <?> and </?>
> %<
	surrounds-add "<%arg{1}>" "</%arg{1}>"
>

define-command surrounds-add-function -override -params 1 -docstring %<
	surrounds-add-function ?: surround selection with ?( and )
> %<
	surrounds-add "%arg{1}(" ')'
>

# ---------------
# LaTeX surrounds
# ---------------

define-command surrounds-add-latex-env -override -params 1 -docstring %<
	surrounds-add-latex-env ?: surround selection with \?{ and }
> %<
	surrounds-add "\%arg{1}{" "}"
>

define-command surrounds-add-latex-begin-env -override -params 1 -docstring %<
	surrounds-add-latex-begin-env ?: surround selection with \begin{?} and \end{?}
> %<
	surrounds-add "\begin{%arg{1}}" "\end{%arg{1}}"
>

define-command surrounds-add-latex-math-inline -override -docstring %<
	surrounds-add-latex-math-inline: add \( and \) around selection
> %<
	surrounds-add '\(' '\)'
>

define-command surrounds-add-latex-math-displayed -override -docstring %<
	surrounds-add-latex-math-displayed: surround selection with newlines
	and then with \[ and \]
> %<
	surrounds-add-line
	surrounds-add '\[' '\]'
>

define-command surrounds-add-latex-ket -override -docstring %<
	surrounds-add-latex-ket: surround selection with | and \rangle
> %<
	surrounds-add '|' '\rangle'
>

define-command surrounds-add-latex-bra -override -docstring %<
	surrounds-add-latex-bra: surround selection with \langle and |
> %<
	surrounds-add '\langle ' '|'
>

define-command surrounds-add-latex-left-right-parentheses -override -docstring %<
	surrounds-add-latex-left-right-parentheses: surround selection with
	\left( and \right)
> %<
	surrounds-add '\left( ' ' \right)'
>

define-command surrounds-add-latex-left-right-brackets -override -docstring %<
	surrounds-add-latex-left-right-brackets: surround selection with
	\left[ and \right]
> %<
	surrounds-add '\left[ ' ' \right]'
>

# ==============================
# Create surrounds mode mappings
# ==============================

define-command _surrounds-map-pair -override -hidden -params 4 %<
	map global surrounds %arg{1} ": surrounds-add %%🐈%arg{2}🐈 %%🐈%arg{3}🐈<ret>" -docstring %arg{4}
>

declare-user-mode surrounds

map global surrounds <backspace> ': surrounds-delete<ret>' -docstring 'delete character before and after'
map global surrounds <ret> ': surrounds-add-line<ret>' -docstring 'add line'
map global surrounds <a-(> ': surrounds-add-latex-left-right-parentheses<ret>' -docstring 'add latex \left( and \right)'
map global surrounds <a-)> ': surrounds-add-latex-left-right-parentheses<ret>' -docstring 'add latex \left( and \right)'
map global surrounds <a-[> ': surrounds-add-latex-left-right-brackets<ret>' -docstring 'add latex \left[ and \right]'
map global surrounds <a-]> ': surrounds-add-latex-left-right-brackets<ret>' -docstring 'add latex \left[ and \right]'

map global surrounds k %{: on-key %{surrounds-add-key %val{key}}<ret>} -docstring 'add key'
map global surrounds , %{: prompt text: %{surrounds-add-text %val{text}}<ret>} -docstring 'add text'
map global surrounds f %{: prompt function: %{surrounds-add-function %val{text}}<ret>} -docstring 'add function'
map global surrounds t %{: prompt tag: %{surrounds-add-html-tag %val{text}}<ret>} -docstring 'add html tag'
map global surrounds e %{: prompt env: %{surrounds-add-latex-env %val{text}}<ret>} -docstring 'add latex env'
map global surrounds <a-e> %{: prompt env: %{surrounds-add-latex-begin-env %val{text}}<ret>} -docstring 'add latex begin env'

_surrounds-map-pair <space> ' ' ' ' 'space'
_surrounds-map-pair $ $ $ 'dollar'
_surrounds-map-pair 4 $ $ 'dollar'
_surrounds-map-pair * * * 'asterisk'
_surrounds-map-pair 8 * * 'asterisk'
_surrounds-map-pair _ _ _ 'underline'

_surrounds-map-pair ( ( ) 'parenthesis block'
_surrounds-map-pair ) ( ) 'parenthesis block'
_surrounds-map-pair 9 ( ) 'parenthesis block'
_surrounds-map-pair 0 ( ) 'parenthesis block'

_surrounds-map-pair [ [ ] 'bracket block'
_surrounds-map-pair ] [ ] 'bracket block'

_surrounds-map-pair { { } 'brace block'
_surrounds-map-pair } { } 'brace block'

_surrounds-map-pair <lt> <lt> <gt> 'angle block'
_surrounds-map-pair <gt> <lt> <gt> 'angle block'

_surrounds-map-pair ` ` ` 'grave'

_surrounds-map-pair '"' '"' '"' 'double quote'
_surrounds-map-pair "'" "'" "'" 'single quote'
_surrounds-map-pair <a-Q> “ ” 'double quotation mark'
_surrounds-map-pair <a-q> ‘ ’ 'single quotation mark'

_surrounds-map-pair <a-G> « » 'double angle quotation mark'
_surrounds-map-pair <a-g> ‹ › 'single angle quotation mark'

>
