# `surrounds.kak`

> `execute-keys 'iurround<esc>h6H<space>sksa.kak'`

`surrounds.kak` is all about "surrounds": parentheses, quotes, HTML
tags, etc. This Kakoune plugin provides convenient mappings to
manipulate surrounds.

## Installation

Place `surrounds.kak` in your autoload directory
(`~/.config/kak/autoload`), or source it manually
(`source ...path/to/surrounds.kak`).

## Usage

There are two user modes available:

-   `surrounds`: for inserting surrounds (and some other functions)
-   `surrounds-undo`: for undoing (deleting) surrounds.

To use the mappings provided, require the `surrounds` module in your
kakrc and create mappings to the user modes:

``` kak
require-module surrounds
map global user s ': enter-user-mode surrounds<ret>'
map global user S ': enter-user-mode surrounds-undo<ret>'
```

The mappings will be available through the `<space>s` and `<space>S`
prefixes.

## Example: usage

Suppose you have the following text:

``` latex
urround
```

And want to change it to:

``` html
<code class="important">
    \begin{center}
        \texttt{( surrounds )}
    \end{center}
</code>
```

To do so, select the text `urround`, and create the surrounds from
inside out:

1.  Surround with s: `<space>sks`
2.  Surround with spaces: `<space>s<space>`
3.  Surround with parentheses: `<space>s)`
4.  Surround with latex command `\texttt`: `<space>setexttt<ret>`
5.  Surround with newlines and indent: `<space>s<ret><gt>`
6.  Surround with latex begin/end: `<space>s<a-e>center<ret>`
7.  Surround with newlines and indent: `<space>s<ret><gt>`
8.  Surround with the `code` HTML tag (with attributes):
    `<space>stcode class="important"<ret>`

Now, suppose you changed your mind, and want to remove the
`\begin{center}..\end{center}` from the code, so it becomes:

``` html
<code class="important">
    \texttt{( surrounds )}
</code>
```

To do so, position the cursor somewhere inside the begin/end (e.g.,
above the `\texttt`), and run the following mappings:

1.  Undo the latex begin/end: `<space>S<a-e>center<ret>`
2.  Unindent and undo the newlines: `<lt><space>S<ret>`

And there you have it. Check out the rest of the available mappings
through the `<space>s` and `<space>S` prefixes at your leisure.

## How it works

`surrounds.kak` is designed in such a way that the *"surrounds"* are
always contained inside the selection. This makes composing surrounds
easier.

If there are multiple selections, the surrounds are applied to each
selection individually.

There are only three foundational commands in `surrounds.kak`, upon
which all the other functionality is built:

-   `surrounds-add <a> <b>`: this command simply inserts the strings
    `<a>` and `<b>` before and after the selection respectively. The
    selection is expaned to include these surrounds, so that surrounds
    can be easily composed.

-   `surrounds-undo <a> <b>`: removes the first `<a>` found before the
    current cursor position and the first `<b>` after, then selects the
    text between these strings. This allows you to then replace the
    removed surrounds with a different one.

    \![NOTE\] The arguments `<a>` and `<b>` are parsed as regex strings,
    so special characters such as `(` and `.` must be manually escaped.
    Another option is to use `surrounds-undo-escape`.

-   `surrounds-undo-escape <a> <b>`: same as `surrounds-undo`, but with
    special regex characters inside `<a>` and `<b>` escaped.

## Example: custom surrounds

-   Wrap the selection with `uwu` and `owo`:

    ``` kak
    surrounds-add uwu owo
    ```

-   The surrounds don't actually need to *surround*. For example, insert
    a question mark after the selection:

    ``` kak
    surrounds-add '' ?
    ```

-   Prompt for a custom surround. The following command prefixes the
    selection with the text given on the prompt:

    ``` kak
    define-command surrounds-add-prefix %{
        prompt text: %{
            surrounds-add "%val{text}: " ''
        }
    }
    ```

## Roadmap

-   Implement a mode for just selecting surrounds without deleting them.

## Licensing

`surrounds.kak` is licensed under the terms of the [Unlicense
license](LICENSE).
