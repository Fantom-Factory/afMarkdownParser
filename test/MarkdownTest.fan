using afPegger
using fandoc

internal class MarkdownTest : Test {
	
	Str parseToHtml(Str markdown, Bool trimLines := true) {
		parser	:= MyMarkdownParser()
		tree	:= parser.parseTree(markdown)
		echo(tree)
		fandoc	:= parser.toFandoc(tree) 
		buf		:= StrBuf()
		fandoc.writeChildren(HtmlDocWriter(buf.out))
		html	:= buf.toStr.replace("\n\n", trimLines ? "\n" : "\n\n").trim
		echo(html)
		return html
	}
}

internal const class MyMarkdownParser : MarkdownParser {
	override MarkdownRules markdownRules() {
		MyMarkdownRules()
	}
}

internal class MyMarkdownRules : MarkdownRules {
	override |Str matched, Obj? ctx| addHr() {
		|Str matched, TreeCtx ctx| {
			ctx.current.add("text", "--hr--")
		}
	}
}