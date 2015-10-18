using afPegger
using fandoc


const class MarkdownParser {
	
	Doc parse(Str markdown) {
		parser := Parser(MarkdownRules().rootRule)
		return ((MarkdownCtx) parser.parseAll(markdown.in, MarkdownCtx())).elems.first
	}
}

internal class MarkdownRules : Rules {
	
	Rule rootRule() {
		rules := NamedRules()

		statement		:= rules["statement"]
		paragraph		:= rules["paragraph"]
		heading			:= rules["heading"]
		line			:= rules["line"]
		text			:= rules["text"]

		eol				:= firstOf { char('\n'), eos }
//		line			:= |->Rule| { sequence { text, eol, } }
		
		rules["statement"]	= firstOf { heading, paragraph, }
		rules["paragraph"]	= sequence { doAction(pushPara), oneOrMore(line), eol, doAction(pop)}
		rules["line"]		= sequence { text, eol, }
		rules["text"]		= oneOrMore( anyCharNot('\n') ).withAction(addText)
		rules["heading"]	= sequence { between(1..4, char('#')).withAction(pushHeading), oneOrMore(anyCharOf([' ', '\t'])), line, doAction(pop), }
		
		return statement
	}
	
	|Str matched, Obj? ctx| pushPara 		:= |Str matched, MarkdownCtx ctx| { ctx.pushPara(matched) }
	|Str matched, Obj? ctx| pushHeading		:= |Str matched, MarkdownCtx ctx| { ctx.pushHeading(matched) }
	|Str matched, Obj? ctx| addText			:= |Str matched, MarkdownCtx ctx| { ctx.addText(matched) }
	|Str matched, Obj? ctx| pop				:= |Str matched, MarkdownCtx ctx| { ctx.pop }
}

internal class MarkdownCtx {
	DocElem[]	elems			:= [Doc()]
	Int?		headingLevel

	Void pushPara(Str matched) {
		echo("pushPara")
		para := Para()
		elems.last.add(para)
		elems.push(para)
	}

	Void pushHeading(Str matched) {
		echo("pushHead: $matched")
		heading := Heading(matched.size)
		elems.last.add(heading)
		elems.push(heading)
		headingLevel = null
	}

	Void addText(Str matched) {
		echo("add text: $matched")
		elems.last.add(DocText(matched))
	}

	Void pop() {
		echo("pop")
		elems.pop
//		elems.first.dump
	}
}
