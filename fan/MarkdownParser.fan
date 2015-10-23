using afPegger
using fandoc


internal class MarkdownRules : TreeRules {
	
	Rule rootRule() {
		rules := NamedRules()

		statement		:= rules["statement"]
		paragraph		:= rules["paragraph"]
		heading			:= rules["heading"]
		blockquote		:= rules["blockquote"]
		pre				:= rules["pre"]
		ul				:= rules["ul"]
		ol				:= rules["ol"]
		image			:= rules["image"]
		line			:= rules["line"]
		bold1			:= rules["bold1"]
		bold2			:= rules["bold2"]
		italic1			:= rules["italic1"]
		italic2			:= rules["italic2"]
		codeSpan		:= rules["code"]
		link			:= rules["link"]
		text			:= rules["text"]

		eol				:= firstOf { char('\n'), eos }
		space			:= anyCharOf([' ', '\t'])
		anySpace		:= zeroOrMore(space)
		
		rules["statement"]	= firstOf { heading, ul, ol, pre, blockquote, image, paragraph, eol, }
		rules["paragraph"]	= sequence { push("paragraph"), oneOrMore(line), eol, pop, }
		rules["heading"]	= sequence { between(1..4, char('#')).withAction(pushHeading), onlyIf(anyCharNot('#')), anySpace, line, pop, }
		rules["pre"]		= sequence { 
			push("pre"),
			oneOf(sequence {
				sequence { str("    "), oneOrMore(anyCharNot('\n')), char('\n'), }, 
				oneOrMore( firstOf { 
					sequence { str("    "), oneOrMore(anyCharNot('\n')), char('\n'), }, 
					sequence { between(0..4, char(' ')), char('\n'), },
				} ),
			} ).withAction(addText), 
			pop,
		}
		
		rules["ul"]			= sequence { 
			push("ul"),
			oneOrMore(sequence {
				doAction(pushLi),
				between(0..3, space),
				anyCharOf("*+-".chars),	oneOrMore(space),
				line, 
				zeroOrMore( sequence { 
					between(0..5, space),
					onlyIfNot(sequence { anyCharOf("*+-".chars), oneOrMore(space)}),
					line,					
				}),
				pop("li"),
			}),
			pop, 
		}

		rules["ol"]			= sequence { 
			push("ol"),
			oneOrMore(sequence {
				doAction(pushLi),
				between(0..3, space),
				oneOrMore(anyNumChar), char('.'), oneOrMore(space),
				line, 
				zeroOrMore( sequence { 
					between(0..5, space),
					onlyIfNot( sequence { oneOrMore(anyNumChar), char('.'), oneOrMore(space), }),
					line,					
				}),
				pop("li"),
			}),
			pop, 
		}
		
		rules["blockquote"]	= sequence { push("blockquote"), char('>'), anySpace, line, pop, }
		rules["line"]		= sequence { text, eol, }
		rules["text"]		= oneOrMore( firstOf { italic1, italic2, bold1, bold2, codeSpan, link, anyCharNot('\n').withAction(addText), })
		
		// suppress multiline bold and italics, 'cos it may in the middle of a list, or gawd knows where!
		rules["italic1"]	= sequence { onlyIfNot(str("* ")), push("italic"), char('*'), oneOrMore(sequence { onlyIf(anyCharNot('\n')), anyCharNot('*'), }).withAction(addText), char('*'), pop, }
		rules["italic2"]	= sequence { onlyIfNot(str("_ ")), push("italic"), char('_'), oneOrMore(sequence { onlyIf(anyCharNot('\n')), anyCharNot('_'), }).withAction(addText), char('_'), pop, }
		rules["bold1"]		= sequence { push("bold"), str("**"), oneOrMore(anyCharNotOf(['*', '\n'])).withAction(addText), str("**"), pop, }
		rules["bold2"]		= sequence { push("bold"), str("__"), oneOrMore(anyCharNot('_')).withAction(addText), str("__"), pop, }
		rules["code"]		= sequence { push("code"), char('`'), oneOrMore(sequence { onlyIf(anyCharNot('\n')), anyCharNot('`'), }).withAction(addText), char('`'), pop, }
		rules["link"]		= sequence { 
			push("link"), 
			char('['), oneOrMore(sequence { onlyIf(anyCharNot('\n')), anyCharNot(']'), }).withAction(addAction("linkText")), char(']'), 
			char('('), oneOrMore(sequence { onlyIf(anyCharNot('\n')), anyCharNot(')'), }).withAction(addAction("linkHref")), char(')'), 
			pop,
		}
		rules["image"]		= sequence { 
			push("image"),
			char('!'),
			char('['), oneOrMore(sequence { onlyIf(anyCharNot('\n')), anyCharNot(']'), }).withAction(addAction("imageAlt")), char(']'), 
			char('('), oneOrMore(sequence { onlyIf(anyCharNot('\n')), anyCharNot(')'), }).withAction(addAction("imageSrc")), char(')'),
			anySpace, eol,
			pop,
		}

		return statement
	}

	|Str matched, Obj? ctx| addText() {
		|Str matched, TreeCtx ctx| {
			if (ctx.current.items.last?.type == "text")
				ctx.current.items.last.matched += matched
			else
				ctx.current.add("text", matched)
		}
	}

	|Str matched, Obj? ctx| pushHeading() {
		|Str matched, TreeCtx ctx| { ctx.push("heading", matched, matched.size) }
	}

	|Str matched, Obj? ctx| pushLi() {
		|Str matched, TreeCtx ctx| {
			ul := ctx.current.prev
			if (ul?.type == "ul" || ul?.type == "ol") {
				// merge the two ul's
				ctx.current.parent.items.remove(ctx.current)
				ctx.current = ul
				
				// enclose the previous li in a p
				li  := ul.items.last
				txt := li.items.dup
				li.items.clear
				p   := li.add("paragraph")
				txt.each { p.addItem(it) }
				
				ctx.push("li").push("paragraph")
			} else 
				ctx.push("li", matched)
		}
	}
}

const class MarkdownParser {

	Doc parse(Str markdown) {
		toFandoc(parseTree(markdown))
	}

	TreeCtx parseTree(Str markdown) {
		parser := Parser(MarkdownRules().rootRule)
		return ((TreeCtx) parser.parseAll(markdown.in, TreeCtx()))
	}
	
	Doc toFandoc(TreeCtx tree) {
		elems := DocElem[Doc()]
		push  := |DocElem elem| {
			elems.last.add(elem)
			elems.push(elem)
		} 
		add  := |DocNode elem| {
			elems.last.add(elem)
		} 
		pop   := |->| {
			elems.pop
		}
		repush := |->| {
			elems.push(elems.last.children.last)
		} 
	
		tree.root.walk(
			|TreeItem item| {
				switch (item.type) {
					case "blockquote":
						if (elems.last.children.last isnot BlockQuote)
							push(BlockQuote())
						else
							repush()
					case "paragraph"	: push(Para())
					case "heading"		: push(Heading(item.data))
					case "pre"			: push(Pre())
					case "ul"			: push(UnorderedList())
					case "ol"			: push(OrderedList(OrderedListStyle.number))
					case "li"			: push(ListItem())
					case "italic"		: push(Emphasis())
					case "bold"			: push(Strong())
					case "code"			: push(Code())
					case "text"			: add(DocText(item.matched))
				}
			},
			|TreeItem item| {
				switch (item.type) {
					case "paragraph":
					case "blockquote":
					case "ul":
					case "ol":
					case "li":
					case "italic":
					case "bold":
					case "code":
						pop()
					
					case "pre":
						heading := (Pre) elems.last
						text	:= (DocText?) heading.children.last
						text.str = text.str.trimEnd
						pop()
					
					case "heading":
						// tidy up trailing hashes --> ## h2 ##
						heading := (Heading) elems.last
						text	:= (DocText?) heading.children.last
						while (text?.str?.endsWith("#") ?: false)
							text.str = text.str[0..<-1].trimEnd
						pop()
					
					case "link":
						text := item.items.find { it.type == "linkText" }.matched
						href := item.items.find { it.type == "linkHref" }.matched
						push(Link(href))
						add(DocText(text))
						pop()

					case "link":
						text := item.items.find { it.type == "linkText" }.matched
						href := item.items.find { it.type == "linkHref" }.matched
						push(Link(href))
						add(DocText(text))
						pop()

					case "image":
						alt := item.items.find { it.type == "imageAlt" }.matched
						src := item.items.find { it.type == "imageSrc" }.matched
						push(Image(src, alt))
						pop()
				}
			}
		)

		return elems.first
	}
}
