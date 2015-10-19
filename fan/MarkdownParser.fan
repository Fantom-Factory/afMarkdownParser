using afPegger
using fandoc


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
					case "paragraph":
						push(Para())
					case "blockquote":
						if (elems.last.children.last isnot BlockQuote)
							push(BlockQuote())
						else
							repush()
					case "heading":
						push(Heading(item.data))
					case "text":
						add(DocText(item.matched))
				}
			},
			|TreeItem item| {
				switch (item.type) {
					case "paragraph":
					case "blockquote":
					case "heading":
						pop()
				}
			}
		)
			
		return elems.first
	}
}

internal class MarkdownRules : TreeRules {
	
	Rule rootRule() {
		rules := NamedRules()

		statement		:= rules["statement"]
		paragraph		:= rules["paragraph"]
		heading			:= rules["heading"]
		blockquote		:= rules["blockquote"]
		line			:= rules["line"]
		text			:= rules["text"]

		eol				:= firstOf { char('\n'), eos }
		
		rules["statement"]	= firstOf { heading, blockquote, paragraph, eol, }
		rules["paragraph"]	= sequence { push("paragraph"), oneOrMore(line), eol, pop, }
		rules["heading"]	= sequence { between(1..4, char('#')).withAction(pushHeading), oneOrMore(anyCharOf([' ', '\t'])), line, pop, }
		rules["blockquote"]	= sequence { push("blockquote"), char('>'), oneOrMore(anyCharOf([' ', '\t'])), line, pop, }
		rules["line"]		= sequence { text, eol, }
		rules["text"]		= oneOrMore( anyCharNot('\n') ).withAction(addAction("text"))
		
		return statement
	}
	
	|Str matched, Obj? ctx| pushHeading() {
		|Str matched, Obj? ctx| { ((TreeCtx) ctx).push("heading", matched, matched.size) }
	}

//	|Str matched, Obj? ctx| pushPara 		:= |Str matched, MarkdownCtx ctx| { ctx.pushPara(matched) }
//	|Str matched, Obj? ctx| pushHeading		:= |Str matched, MarkdownCtx ctx| { ctx.pushHeading(matched) }
//	|Str matched, Obj? ctx| pushBlockquote	:= |Str matched, MarkdownCtx ctx| { ctx.pushBlockquote(matched) }
//	|Str matched, Obj? ctx| addText			:= |Str matched, MarkdownCtx ctx| { ctx.addText(matched) }
//	|Str matched, Obj? ctx| pop				:= |Str matched, MarkdownCtx ctx| { ctx.pop }
}

//internal class MarkdownCtx {
//	DocElem[]	elems			:= [Doc()]
//	Int?		headingLevel
//
//	Void pushPara(Str matched) {
//		push(Para())
//	}
//
//	Void pushHeading(Str matched) {
//		push(Heading(matched.size))
//		headingLevel = null
//	}
//
//	Void pushBlockquote(Str matched) {
//		push(BlockQuote())
//	}
//
//	Void addText(Str matched) {
//		elems.last.add(DocText(matched))
//	}
//
//	private Void push(DocElem elem) {
//		elems.last.add(elem)
//		elems.push(elem)		
//	}
//
//	Void pop() {
//		echo("pop")
//		elems.pop
////		elems.first.dump
//	}
//	
//}
