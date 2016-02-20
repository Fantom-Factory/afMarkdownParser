#Markdown Parser v0.0.2
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom.org/)
[![pod: v0.0.2](http://img.shields.io/badge/pod-v0.0.2-yellow.svg)](http://www.fantomfactory.org/pods/afMarkdownParser)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

*Markdown Parser is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Parses Markdown text into Fandoc objects.

Supported Markdown syntax:

- Headings
- Paragraphs
- Block quotes
- Lists (ordered and unordered)
- Links and images
- Bold and italics
- Code blocks and code spans

Markdown Parser uses the extensible Parsing Expression Grammer as provider by [Pegger](http://pods.fantomfactory.org/pods/afPegger).

Note that this markdown implementation is known to be incomplete. For example, it does not support reference links or backslash escaping `*` and `_` characters. But it should be usable to most casual users.

## Install

Install `Markdown Parser` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://pods.fantomfactory.org/fanr/ afMarkdownParser

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afMarkdownParser 0.0"]

## Documentation

Full API & fandocs are available on the [Fantom Pod Repository](http://pods.fantomfactory.org/pods/afMarkdownParser/).

## Usage

1 class - 1 method - 1 argument - 1 return value.

It's pretty self explanatory!

## Cheatsheet

A cheatsheet of supported markdown syntax:

```
# Heading 1

## Heading 2

### Heading 3

#### Heading 4

This is *italic* and so is _this_

This is **bold** and so is __this__

These are just * stars * and _ stripes _

This is a `code` span

    Void main() {
        echo("This is a code block")
    }

This is a link to [Fantom-Factory](http://www.fantomfactory.org/)

![Fanny the Fantom Image](http://www.fantomfactory.org/fanny.png)

> This is a block quote. - said Fanny

 * An unordered list
 * An unordered list
 * An unordered list

 1. An ordered list
 1. An ordered list
 1. An ordered list
```

## Html

To convert Markdown to HTML use the `HtmlDocWriter` class to print fandoc `Doc` objects.

```
fandoc := MarkdownParser().parse("...markdown...")
buf    := StrBuf()
fandoc.writeChildren(HtmlDocWriter(buf.out))
html   := buf.toStr
```

Note that Fantom also ships with a `FandocDocWriter` and a `MarkdownDocWriter`.

