provide-module surrounds %<

# ===================
# surrounds-selection
# ===================

define-command surrounds-selection-shrink -override -docstring %<
	surrounds-selection-shrink: shrink selection from both sides
> %<
	execute-keys "<a-:><a-;>L<a-;>H"
>

define-command surrounds-selection-expand -override -docstring %<
	surrounds-selection-expand: expand selection from both sides
> %<
	execute-keys "<a-:><a-;>H<a-;>L"
>

# =============
# surrounds-add
# =============

define-command surrounds-add -override -params 2 -docstring %<
	surrounds-add <a> <b>: insert <a> before the selection, and <b>
	after the selection
> %<
	evaluate-commands -itersel -save-regs '"' %<
		set-register '"' "%arg{1}%reg{dot}%arg{2}"
		execute-keys 'R'
	>
>

define-command surrounds-add-newlines -override -docstring %<
	surrounds-add-newlines: surround selection with newlines (and indent
	with indentwidth)
> %<
	surrounds-add '
' '
'
	execute-keys '<gt>'
>

define-command surrounds-add-html-tag -override -params 1 -docstring %<
	surrounds-add-html-tag ?: surround selection with <?> and </?>

	HTML attributes are removed from </?>.
> %<
	evaluate-commands -save-regs '"' %<
		# Extract HTML tag without attributes into %reg{dquote}
		edit -scratch
		set-register '"' %arg{1}
		execute-keys -save-regs '' 'Pgk<a-i><a-w>y'
		delete-buffer

		surrounds-add "<%arg{1}>" "</%reg{dquote}>"
	>
>

# ==============
# surrounds-undo
# ==============

define-command surrounds-undo -override -params 2 -docstring %<
	surrounds-undo <a> <b>: expand selection to include <a> and <b>

	The arguments <a> and <b> are parsed as regex strings.
> %<
	evaluate-commands -save-regs '^' %<
		execute-keys "<a-/>%arg{1}<ret><a-d>Z/%arg{2}<ret><a-d><a-z>uH"
	>
>

define-command surrounds-undo-escape -override -params 2 -docstring %<
	surrounds-undo-escape <a> <b>: run surrounds-undo with <a> and <b>,
	but with special regex characters inside <a> and <b> escaped
> %<
	evaluate-commands -save-regs a/b %<
		edit -scratch

		set-register a %arg{1}  # <a>
		set-register b %arg{2}  # <b>

		# Special regex characters
		set-register / '\\|\||\(|\)|\[|\]|\{|\}|\*|\+|\^|\$|\.|\?'

		# Escape special characters in <a>
		execute-keys -save-regs '' '"aPs<ret>i\<esc>%H"ad'

		# Escape special characters in <b>
		execute-keys -save-regs '' '"bPs<ret>i\<esc>%H"bd'

		delete-buffer

		surrounds-undo %reg{a} %reg{b}
	>
>

define-command surrounds-undo-single -override -docstring %<
	surrounds-undo-single: delete first and last characters from inside
	the selection
> %<
	execute-keys 'i<del><esc>a<backspace><esc>'
>

# ===============
# Create mappings
# ===============

# ---------
# surrounds
# ---------

declare-user-mode surrounds
declare-user-mode surrounds-undo

map global surrounds i %{: surrounds-selection-shrink<ret>} -docstring 'shrink selection'
map global surrounds o %{: surrounds-selection-expand<ret>} -docstring 'expand selection'
map global surrounds <backspace> %{: surrounds-undo-single<ret>} -docstring 'delete surrounding characters'

# Misc
map global surrounds      <space> %{: surrounds-add  ' ' ' '<ret>} -docstring 'add spaces'
map global surrounds-undo <space> %{: surrounds-undo-escape ' ' ' '<ret>} -docstring 'undo spaces'
map global surrounds      <ret>   %{: surrounds-add-newlines<ret>} -docstring 'add newlines'
map global surrounds-undo <ret>   %{: surrounds-undo \n \n<ret><lt>} -docstring 'undo newlines'
map global surrounds      *       %{: surrounds-add  * *<ret>} -docstring 'add asterisks'
map global surrounds-undo *       %{: surrounds-undo-escape * *<ret>} -docstring 'undo asterisks'
map global surrounds      $       %{: surrounds-add  $ $<ret>} -docstring 'add dollar signs'
map global surrounds-undo $       %{: surrounds-undo-escape $ $<ret>} -docstring 'undo dollar signs'
map global surrounds      _       %{: surrounds-add  _ _<ret>} -docstring 'add underlines'
map global surrounds-undo _       %{: surrounds-undo-escape _ _<ret>} -docstring 'undo underlines'
map global surrounds      `       %{: surrounds-add  ` `<ret>} -docstring 'add backticks'
map global surrounds-undo `       %{: surrounds-undo-escape ` `<ret>} -docstring 'undo backticks'
map global surrounds      k       %{: on-key %{surrounds-add %val{key} %val{key}}<ret>} -docstring 'add key'
map global surrounds-undo k       %{: on-key %{surrounds-undo-escape %val{key} %val{key}}<ret>} -docstring 'undo key'
map global surrounds      ,       %{: prompt text: %{surrounds-add %val{text} %val{text}}<ret>} -docstring 'add text'
map global surrounds-undo ,       %{: prompt text: %{surrounds-undo-escape %val{text} %val{text}}<ret>} -docstring 'undo text'
map global surrounds      f       %{: prompt function: %{surrounds-add  "%val{text}(" ')'}<ret>} -docstring 'add function'
map global surrounds-undo f       %{: prompt function: %{surrounds-undo-escape "%val{text}(" ')'}<ret>} -docstring 'undo function'

# Parentheses / brackets / braces
map global surrounds      ( %{: surrounds-add ( )<ret>} -docstring 'add ( and ) (parenthesis block)'
map global surrounds-undo ( %{: surrounds-undo-escape ( )<ret>} -docstring 'undo ( and ) (parenthesis block)'
map global surrounds      ) %{: surrounds-add ( )<ret>} -docstring 'add ( and ) (parenthesis block)'
map global surrounds-undo ) %{: surrounds-undo-escape ( )<ret>} -docstring 'undo ( and ) (parenthesis block)'
map global surrounds      [ %{: surrounds-add [ ]<ret>} -docstring 'add [ and ] (bracket block)'
map global surrounds-undo [ %{: surrounds-undo-escape [ ]<ret>} -docstring 'undo [ and ] (bracket block)'
map global surrounds      ] %{: surrounds-add [ ]<ret>} -docstring 'add [ and ] (bracket block)'
map global surrounds-undo ] %{: surrounds-undo-escape [ ]<ret>} -docstring 'undo [ and ] (bracket block)'
map global surrounds      { %{: surrounds-add { }<ret>} -docstring 'add { and } (brace block)'
map global surrounds-undo { %{: surrounds-undo-escape { }<ret>} -docstring 'undo { and } (brace block)'
map global surrounds      } %{: surrounds-add { }<ret>} -docstring 'add { and } (brace block)'
map global surrounds-undo } %{: surrounds-undo-escape { }<ret>} -docstring 'undo { and } (brace block)'

# Quotes
map global surrounds        "'" %{: surrounds-add "'" "'"<ret>} -docstring 'add single quotes'
map global surrounds-undo   "'" %{: surrounds-undo-escape "'" "'"<ret>} -docstring 'undo single quotes'
map global surrounds        '"' %{: surrounds-add '"' '"'<ret>} -docstring 'add double quotes'
map global surrounds-undo   '"' %{: surrounds-undo-escape '"' '"'<ret>} -docstring 'undo double quotes'
map global surrounds      <a-q> %{: surrounds-add ‘ ’<ret>} -docstring 'add ‘ and ’ (single quotation marks)'
map global surrounds-undo <a-q> %{: surrounds-undo-escape ‘ ’<ret>} -docstring 'undo ‘ and ’ (single quotation marks)'
map global surrounds      <a-Q> %{: surrounds-add “ ”<ret>} -docstring 'add “ and ” (double quotation marks)'
map global surrounds-undo <a-Q> %{: surrounds-undo-escape “ ”<ret>} -docstring 'undo “ and ” (double quotation marks)'

# Angles
map global surrounds       <lt> %{: surrounds-add <lt> <gt><ret>} -docstring 'add < and > (angle blocks)'
map global surrounds-undo  <lt> %{: surrounds-undo-escape <lt> <gt><ret>} -docstring 'undo < and > (angle blocks)'
map global surrounds       <gt> %{: surrounds-add <lt> <gt><ret>} -docstring 'add < and > (angle blocks)'
map global surrounds-undo  <gt> %{: surrounds-undo-escape <lt> <gt><ret>} -docstring 'undo < and > (angle blocks)'
map global surrounds      <a-g> %{: surrounds-add ‹ ›<ret>} -docstring 'add ‹ and › (single angle quotation marks)'
map global surrounds-undo <a-g> %{: surrounds-undo-escape ‹ ›<ret>} -docstring 'undo ‹ and › (single angle quotation marks)'
map global surrounds      <a-G> %{: surrounds-add « »<ret>} -docstring 'add « and » (double angle quotation marks)'
map global surrounds-undo <a-G> %{: surrounds-undo-escape « »<ret>} -docstring 'undo « and » (double angle quotation marks)'

# LaTeX
map global surrounds      <a-(> %{: surrounds-add \( \)<ret>} -docstring 'add \( and \)'
map global surrounds-undo <a-(> %{: surrounds-undo-escape \( \)<ret>} -docstring 'undo \( and \)'
map global surrounds      <a-)> %{: surrounds-add \left( \left)<ret>} -docstring 'add \left( and \right)'
map global surrounds-undo <a-)> %{: surrounds-undo-escape \left( \left)<ret>} -docstring 'undo \left( and \right)'
map global surrounds      <a-[> %{: surrounds-add \[ \]<ret>} -docstring 'add \[ and \]'
map global surrounds-undo <a-[> %{: surrounds-undo-escape \[ \]<ret>} -docstring 'undo \[ and \]'
map global surrounds      <a-]> %{: surrounds-add \left[ \right]<ret>} -docstring 'add \left[ and \right] ('
map global surrounds-undo <a-]> %{: surrounds-undo-escape \left[ \right]<ret>} -docstring 'undo \left[ and \right] ('
map global surrounds      <a-k> %{: surrounds-add | \rangle<ret>} -docstring 'add | and \rangle (latex ket)'
map global surrounds-undo <a-k> %{: surrounds-undo-escape | \rangle<ret>} -docstring 'undo | and \rangle (latex ket)'
map global surrounds      <a-b> %{: surrounds-add \langle |<ret>} -docstring 'add \langle and | (latex bra)'
map global surrounds-undo <a-b> %{: surrounds-undo-escape \langle |<ret>} -docstring 'undo \langle and | (latex bra)'
map global surrounds          t %{: prompt tag: %{surrounds-add-html-tag %val{text}}<ret>} -docstring 'add html tag'
map global surrounds-undo     t %{: prompt tag: %{surrounds-undo "<lt>%arg{1}.*<gt>" "<lt>/%arg{1}<gt>"}<ret>} -docstring 'undo html tag'
map global surrounds          e %{: prompt env: %{surrounds-add "\%val{text}{" "}"}<ret>} -docstring 'add latex env'
map global surrounds-undo     e %{: prompt env: %{surrounds-undo-escape "\%val{text}{" "}"}<ret>} -docstring 'undo latex env'
map global surrounds      <a-e> %{: prompt env: %{surrounds-add "\begin{%val{text}}" "\end{%val{text}}"}<ret>} -docstring 'add latex begin env'
map global surrounds-undo <a-e> %{: prompt env: %{surrounds-undo-escape "\begin{%val{text}}" "\end{%val{text}}"}<ret>} -docstring 'undo latex begin env'

>
