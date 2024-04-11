provide-module surrounds %{

define-command surrounds-select-inner -override -hidden -docstring %<
	surrounds-select-inner: shrink selection from both sides by one
	character
> %<
	execute-keys '<a-:>H<a-;>L'
>

define-command surrounds-delete -override -hidden -docstring %<
	surrounds-delete: delete first and last characters from selection
> %<
	execute-keys -draft '<a-S>d'
	execute-keys '<a-:>H'
>

##
## surrounds-add* commands
##

define-command surrounds-add -params 2 -override -docstring %<
	surrounds-add <before> <after>: insert <before> before the selection,
	and <after> after the selection
> %<
	evaluate-commands -itersel -save-regs '"' %<
		set-register '"' "%arg{1}%val{selection}%arg{2}"
		execute-keys 'R'
	>
>

define-command surrounds-add-line -override -hidden %<
	surrounds-add '
' '
'
	execute-keys '<gt>'
>

define-command surrounds-add-key -override -hidden %<
	echo "surrounds-add-key:"
	on-key %<
		surrounds-add %val{key} %val{key}
	>
>

define-command surrounds-add-left-right -override -hidden %<
	prompt surrounds-add-left-right: %<
		surrounds-add %val{text} %val{text}
	>
>

define-command surrounds-add-left -override -hidden %<
	prompt surrounds-add-left: %<
		surrounds-add %val{text} ''
	>
>

define-command surrounds-add-right -override -hidden %<
	prompt surrounds-add-right: %<
		surrounds-add '' %val{text}
	>
>

define-command surrounds-add-html-tag -override -hidden %<
	prompt surrounds-add-html-tag: %<
		surrounds-add "<%val{text}>" "</%val{text}>"
	>
>

define-command surrounds-add-tex-env -override -hidden %<
	prompt surrounds-add-tex-env: %<
		surrounds-add "\%val{text}{" "}"
	>
>

define-command surrounds-add-tex-begin-env -override -hidden %<
	prompt surrounds-add-tex-begin-env: %<
		surrounds-add "\begin{%val{text}}" "\end{%val{text}}"
	>
>

define-command surrounds-add-function -override -hidden %<
	prompt surrounds-add-function: %<
		surrounds-add "%val{text}(" ')'
	>
>

##
## Create surrounds mode mappings
##

define-command surrounds-map-pair -override -params 4 %<
	map global surrounds %arg{1} ": surrounds-add %%🐈%arg{2}🐈 %%🐈%arg{3}🐈<ret>" -docstring %arg{4}
>

declare-user-mode surrounds

map global surrounds s ': surrounds-select-inner<ret>' -docstring 'select inner'
map global surrounds <backspace> ': surrounds-delete<ret>' -docstring 'delete'

map global surrounds <ret> ': surrounds-add-line<ret>' -docstring 'add line'
map global surrounds k ': surrounds-add-key<ret>' -docstring 'add key'
map global surrounds t ': surrounds-add-html-tag<ret>' -docstring 'add html tag'
map global surrounds e ': surrounds-add-tex-env<ret>' -docstring 'add latex env'
map global surrounds <a-e> ': surrounds-add-tex-begin-env<ret>' -docstring 'add latex begin env'
map global surrounds f ': surrounds-add-function<ret>' -docstring 'add function'
map global surrounds , ': surrounds-add-left-right<ret>' -docstring 'add left-right'
map global surrounds h ': surrounds-add-left<ret>' -docstring 'add left'
map global surrounds l ': surrounds-add-right<ret>' -docstring 'add right'

surrounds-map-pair <space> ' ' ' ' 'space'
surrounds-map-pair $ $ $ 'dollar'
surrounds-map-pair * * * 'asterisk'
surrounds-map-pair _ _ _ 'underline'

surrounds-map-pair b ( ) 'parenthesis block'
surrounds-map-pair ( ( ) 'parenthesis block'
surrounds-map-pair ) ( ) 'parenthesis block'

surrounds-map-pair B { } 'brace block'
surrounds-map-pair { { } 'brace block'
surrounds-map-pair } { } 'brace block'

surrounds-map-pair r [ ] 'bracket block'
surrounds-map-pair [ [ ] 'bracket block'
surrounds-map-pair ] [ ] 'bracket block'

surrounds-map-pair a <lt> <gt> 'angle block'
surrounds-map-pair <lt> <lt> <gt> 'angle block'
surrounds-map-pair <gt> <lt> <gt> 'angle block'

surrounds-map-pair Q '"' '"' 'double quote'
surrounds-map-pair '"' '"' '"' 'double quote'

surrounds-map-pair q "'" "'" 'single quote'
surrounds-map-pair "'" "'" "'" 'single quote'

surrounds-map-pair g ` ` 'grave'
surrounds-map-pair ` ` ` 'grave'

surrounds-map-pair <a-Q> “ ” 'double quotation mark'
surrounds-map-pair <a-q> ‘ ’ 'single quotation mark'

surrounds-map-pair <a-G> « » 'double angle quotation mark'
surrounds-map-pair <a-g> ‹ › 'single angle quotation mark'

}
