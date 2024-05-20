provide-module surrounds %{

define-command surrounds-select-inner -override -docstring %<
	surrounds-select-inner: shrink selection from both sides by one
	character
> %<
	execute-keys '<a-:>H<a-;>L'
>

define-command surrounds-delete -override -docstring %<
	surrounds-delete: delete first and last characters from selection
> %<
	execute-keys -draft '<a-S>d'
	execute-keys '<a-:>H'
>

# =======================
# surrounds-add* commands
# =======================

define-command surrounds-add -params 2 -override -docstring %<
	surrounds-add <before> <after>: insert <before> before the selection,
	and <after> after the selection
> %<
	evaluate-commands -itersel -save-regs '"' %<
		set-register '"' "%arg{1}%val{selection}%arg{2}"
		execute-keys 'R'
	>
>

define-command surrounds-add-line -override %<
	surrounds-add '
' '
'
	execute-keys '<gt>'
>

define-command surrounds-add-key -override %<
	echo "surrounds-add-key:"
	on-key %<
		surrounds-add %val{key} %val{key}
	>
>

define-command surrounds-add-html-tag -override %<
	prompt surrounds-add-html-tag: %<
		surrounds-add "<%val{text}>" "</%val{text}>"
	>
>

define-command surrounds-add-function -override %<
	prompt surrounds-add-function: %<
		surrounds-add "%val{text}(" ')'
	>
>

# -----------------------
# left, right, left-right
# -----------------------

define-command surrounds-add-left -override %<
	prompt surrounds-add-left: %<
		surrounds-add %val{text} ''
	>
>

define-command surrounds-add-right -override %<
	prompt surrounds-add-right: %<
		surrounds-add '' %val{text}
	>
>

define-command surrounds-add-left-right -override %<
	prompt surrounds-add-left-right: %<
		surrounds-add %val{text} %val{text}
	>
>

# ---------------
# LaTeX surrounds
# ---------------

define-command surrounds-add-latex-env -override %<
	prompt surrounds-add-tex-env: %<
		surrounds-add "\%val{text}{" "}"
	>
>

define-command surrounds-add-latex-begin-env -override %<
	prompt surrounds-add-latex-begin-env: %<
		surrounds-add "\begin{%val{text}}" "\end{%val{text}}"
	>
>

define-command surrounds-add-latex-math-inline -override %<
	surrounds-add '\(' '\)'
>

define-command surrounds-add-latex-math-displayed -override %<
	surrounds-add-line
	surrounds-add '\[' '\]'
>

define-command surrounds-add-latex-ket -override %<
	surrounds-add '|' '\rangle'
>

define-command surrounds-add-latex-bra -override %<
	surrounds-add '\langle ' '|'
>

# ==============================
# Create surrounds mode mappings
# ==============================

define-command _surrounds-map-pair -override -hidden -params 4 %<
	map global surrounds %arg{1} ": surrounds-add %%🐈%arg{2}🐈 %%🐈%arg{3}🐈<ret>" -docstring %arg{4}
>

declare-user-mode surrounds

map global surrounds s ': surrounds-select-inner<ret>' -docstring 'select inner'
map global surrounds <backspace> ': surrounds-delete<ret>' -docstring 'delete'

map global surrounds <ret> ': surrounds-add-line<ret>' -docstring 'add line'
map global surrounds k ': surrounds-add-key<ret>' -docstring 'add key'
map global surrounds t ': surrounds-add-html-tag<ret>' -docstring 'add html tag'
map global surrounds e ': surrounds-add-latex-env<ret>' -docstring 'add latex env'
map global surrounds <a-e> ': surrounds-add-latex-begin-env<ret>' -docstring 'add latex begin env'
map global surrounds f ': surrounds-add-function<ret>' -docstring 'add function'
map global surrounds , ': surrounds-add-left-right<ret>' -docstring 'add left-right'
map global surrounds h ': surrounds-add-left<ret>' -docstring 'add left'
map global surrounds l ': surrounds-add-right<ret>' -docstring 'add right'

_surrounds-map-pair <space> ' ' ' ' 'space'
_surrounds-map-pair $ $ $ 'dollar'
_surrounds-map-pair * * * 'asterisk'
_surrounds-map-pair _ _ _ 'underline'

_surrounds-map-pair b ( ) 'parenthesis block'
_surrounds-map-pair ( ( ) 'parenthesis block'
_surrounds-map-pair ) ( ) 'parenthesis block'

_surrounds-map-pair B { } 'brace block'
_surrounds-map-pair { { } 'brace block'
_surrounds-map-pair } { } 'brace block'

_surrounds-map-pair r [ ] 'bracket block'
_surrounds-map-pair [ [ ] 'bracket block'
_surrounds-map-pair ] [ ] 'bracket block'

_surrounds-map-pair a <lt> <gt> 'angle block'
_surrounds-map-pair <lt> <lt> <gt> 'angle block'
_surrounds-map-pair <gt> <lt> <gt> 'angle block'

_surrounds-map-pair Q '"' '"' 'double quote'
_surrounds-map-pair '"' '"' '"' 'double quote'

_surrounds-map-pair q "'" "'" 'single quote'
_surrounds-map-pair "'" "'" "'" 'single quote'

_surrounds-map-pair g ` ` 'grave'
_surrounds-map-pair ` ` ` 'grave'

_surrounds-map-pair <a-Q> “ ” 'double quotation mark'
_surrounds-map-pair <a-q> ‘ ’ 'single quotation mark'

_surrounds-map-pair <a-G> « » 'double angle quotation mark'
_surrounds-map-pair <a-g> ‹ › 'single angle quotation mark'

}
