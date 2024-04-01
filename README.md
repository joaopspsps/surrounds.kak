# `surrounds.kak`

## Installation

Place `surrounds.kak` in the autoload directory
(`~/.config/kak/autoload`), or source it manually
(`source ...path/to/surrounds.kak`).

## Usage

``` kak
require-module surrounds
map global user s ': enter-user-mode surrounds<ret>'
```

The mappings will be available through the `<space>s` prefix.

## Examples

All commands are designed to work so that the *"surrounds"* are always
inside the selection. This makes composing surrounds easier.

For example, suppose we have the following text:

``` latex
urround
```

And we want to change it to:

``` latex
\begin{center}
  \texttt{( surrounds )}
\end{center}
```

To do that, we create the surrounds from inside out:

1.  Surround with s: `<space>ks<space>`
2.  Surround with spaces: `<space>s<space>`
3.  Surround with parentheses: `<space>s(<space>`
4.  Surround with latex command `\texttt`: `<space>setexttt<ret>`
5.  Surround with lines (and indent using `indentwidth`):
    `<space>s<ret><space>`
6.  Surround with latex begin/end: `<space>s<a-e>center<ret>`

If there are multiple selections, the surrounds are applied to each
individually.

## Creating custom surrounds

It's possible to use the `surrounds-add` to create custom surrounds. See
the `surrounds-add-*` in `surrounds.kak` commands for more examples.

For example, to create a surround that wraps the selection with `uwu`
and `owo`, and map it to `<space>sw`:

``` kak
define-command surrounds-add-uwu-owo -override -hidden %{
    surrounds-add uwu owo
}
map global surrounds w ': surrounds-add-uwu-owo<ret>'
```

The surrounds don't actually need to *surround*. For example, to create
a surround that inserts `?` after the selection:

``` kak
define-command surrounds-add-interrogation -override -hidden %{
    surrounds-add '' ?
}
```

## Limitations

-   `surrounds-add-line` does not work well for text that is not in the
    start of the line.
-   No way to delete surrounds with more than one character (must do it
    manually). However, it is possible to undo the commands (using `u`).
