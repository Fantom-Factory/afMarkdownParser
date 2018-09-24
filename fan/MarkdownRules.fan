using afPegger

@Js
internal class MarkdownRules : TreeRules {
	
	private Regex headingNameRegex   := """\\s*<a \\s*(?:name|id)\\s*=\\s*(?:"|')?\\s*([^\\s"']+)\\s*(?:"|')?\\s*>\\s*</a>\\s*""".toRegex
	
	Rule rootRule() { 
		rules := NamedRules()

		statement		:= rules["statement"]
		paragraph		:= rules["paragraph"]
		heading			:= rules["heading"]
		blockquote		:= rules["blockquote"]
		pre				:= rules["pre"]
		preGithub		:= rules["preGithub"]
		hr				:= rules["hr"]
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
		plainChar		:= rules["plainChar"]

		space			:= anyCharOf([' ', '\t'])
		anySpace		:= zeroOrMore(space)
		eol				:= firstOf { char('\n'), eos }
		blankLine		:= sequence { anySpace, eol, }
		nl				:= char('\n')
		notNl			:= anyCharNot('\n')

		rules["statement"]	= firstOf { heading, hr, ul, ol, pre, preGithub, blockquote, image, paragraph, blankLine, eol, }
		rules["heading"]	= sequence { between(1..6, char('#')).withAction(pushHeading.action), onlyIf(anyCharNot('#')), anySpace, line, popHeading, }
		rules["paragraph"]	= sequence { push("paragraph"), oneOrMore(line), pop, }
		rules["blockquote"]	= sequence { pushBlockquote, char('>'), anySpace, line, pop, }
		rules["pre"]		= sequence { 
			push("pre"),
			oneOf(sequence {
				sequence { str("    "), oneOrMore(notNl), eol, }, 
				zeroOrMore( firstOf { 
					sequence { str("    "), oneOrMore(notNl), eol, }, 
					sequence { between(0..4, char(' ')), nl, },
				} ),
			} ).withAction(addPre), 
			popPre,
		}

		rules["preGithub"]	= sequence { 
			sequence { str("```"), zeroOrMore(notNl), nl, },
			push("pre"),
			strNot("\n```").withAction(addText),
			popPre,
			sequence { str("\n```"), anySpace, eol, },
		}
		
		rules["ul"]			= sequence { 
			push("ul"),
			oneOrMore(sequence {
				pushLi,
				between(0..3, space),
				anyCharOf("*+-".chars),	oneOrMore(space),
				line, 
				zeroOrMore( sequence { 
					between(0..5, space),
					onlyIfNot(sequence { firstOf { anyCharOf("*+-".chars), between(1..6, char('#')), }, oneOrMore(space)}),
					line,					
				}),
				pop("li"),
			}),
			pop, 
		}

		rules["ol"]			= sequence { 
			push("ol"),
			oneOrMore(sequence {
				pushLi,
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

		rules["hr"]			= sequence { 
			push("hr"),
			sequence { atLeast(3, sequence { anyCharOf("_-*".chars), anySpace, }), nl, },
			pop, 
		}
		
		rules["line"]		= sequence { onlyIfNot(firstOf { blankLine, str("```"), hr, blockquote, }), text, eol.withAction(newText), }
		rules["text"]		= oneOrMore( firstOf { italic1, italic2, bold1, bold2, codeSpan, link, anyCharNot('\n').withAction(addChar), })
		//rules["plainChar"]	= onlyIf( sequence { char('\n'), anyAlphaChar, })
		
		// suppress multiline bold and italics, 'cos it may in the middle of a list, or gawd knows where!
		rules["italic1"]	= sequence { onlyIfNot(str("* ")), push("italic"), char('*'), oneOrMore(sequence { onlyIf(notNl), anyCharNot('*'), }).withAction(addText), char('*'), pop, }
		rules["italic2"]	= sequence { onlyIfNot(str("_ ")), push("italic"), char('_'), oneOrMore(sequence { onlyIf(notNl), anyCharNot('_'), }).withAction(addText), char('_'), pop, }
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

	|Str matched, Obj? ctx| addChar() {
		addText()
	}

	Bool makeNewText
	|Str matched, Obj? ctx| newText() {
		|Str matched, TreeCtx ctx| {
			makeNewText = true
		}
	}

	|Str matched, Obj? ctx| addText() {
		|Str matched, TreeCtx ctx| {
			if (ctx.current.items.last?.type == "text" && !makeNewText)
				ctx.current.items.last.matched += matched
			else
				ctx.current.add("text", matched)
			makeNewText = false
		}
	}

	|Str matched, Obj? ctx| addPre() {
		|Str matched, TreeCtx ctx| {
			// remove the default indentation
			rem := 0
			if (matched.startsWith("\t"))
				rem = 1
			if (matched.startsWith("    "))
				rem = 4
			if (rem > 0)
				matched = matched.splitLines.map { it.size >= rem ? it[rem..-1] : it }.join("\n")

			// same as addText()
			if (ctx.current.items.last?.type == "text")
				ctx.current.items.last.matched += matched
			else
				ctx.current.add("text", matched)
		}
	}

	Rule pushHeading() {
		doAction |Str matched, TreeCtx ctx| { 
			// limit heading size to 4, because that's all that Fandoc can handle (esp when printing to Fandoc source)
			// besides, who actually has a legitimate use for <h5> and <h6>!?
			ctx.push("heading", matched, Obj[matched.size.min(4)]) 
		}
	}

	Rule popHeading() {
		doAction |Str matched, TreeCtx ctx| { 
			// tidy up trailing hashes --> ## h2 ##
			text := ctx.current.items.last
			while (text.matched?.endsWith("#") ?: false)
				text.matched = text.matched[0..<-1].trimEnd

			// parse HTML anchor tags as generated by Fantom's MarkdownDocWriter
			// --> "## <a name=\"overview\"></a>Overview"
			matcher := headingNameRegex.matcher(text.matched)
			if (matcher.find) {
				nameTag	 := matcher.group(0)
				anchorId := matcher.group(1)
				text.matched = text.matched[nameTag.size..-1]
				(text.parent.data as Obj[]).push(anchorId)
			}
			ctx.pop
		}
	}

	Rule popPre() {
		doAction |Str matched, TreeCtx ctx| { 
			text := ctx.current.items.last
			text.matched = text.matched?.trimEnd
			ctx.pop
		}
	}

	Rule pushBlockquote() {
		doAction |Str matched, TreeCtx ctx| {
			if (ctx.current.items.last?.type == "blockquote")
				ctx.current = ctx.current.items.last
			else
				ctx.push("blockquote") 
		}
	}

	Rule pushLi() {
		doAction |Str matched, TreeCtx ctx| {
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
				ctx.push("li")
		}
	}
}
