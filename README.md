# `surrounds.kak`

> `execute-keys 'iurround<esc>h6H<space>sksa.kak'`

## Installation

Place `surrounds.kak` in your autoload directory
(`~/.config/kak/autoload`), or source it manually
(`source ...path/to/surrounds.kak`).

## Usage

``` kak
require-module surrounds
map global user s ': enter-user-mode surrounds<ret>'
```

The mappings will be available through the `<space>s` prefix.

All the commands are designed to work so that the *"surrounds"* are
always contained inside the selection. This makes composing surrounds
easier.

If there are multiple selections, the surrounds are applied to each
selection individually.

## Example

Suppose you have the following text:

``` latex
urround
```

And want to change it to:

``` latex
\begin{center}
  \texttt{( surrounds )}
\end{center}
```

To do so, create the surrounds from inside out:

1.  Surround with s: `<space>sks`
2.  Surround with spaces: `<space>s<space>`
3.  Surround with parentheses: `<space>s)`
4.  Surround with latex command `\texttt`: `<space>setexttt<ret>`
5.  Surround with lines (and indent using `indentwidth`):
    `<space>s<ret>`
6.  Surround with latex begin/end: `<space>s<a-e>center<ret>`

## Custom surrounds

It's possible to use the `surrounds-add` to create custom surrounds. See
the `surrounds-add-*` commands in `surrounds.kak` commands for more
examples.

-   Create a surround that wraps the selection with `uwu` and `owo`, and
    map it to `<space>sw`:

        define-command surrounds-add-uwu-owo %{
            surrounds-add uwu owo
        }
        map global surrounds w ': surrounds-add-uwu-owo<ret>'

-   The surrounds don't actually need to *surround*. For example, create
    a surround that inserts `?` after the selection:

        define-command surrounds-add-question %{
            surrounds-add '' ?
        }

-   Prompt for a custom surround. The following command prefixes the
    selection with the text given on the prompt:

        define-command surrounds-add-prefix %{
            prompt surrounds-add-prefix: %{
                surrounds-add "%val{text}: " ''
            }
        }
