using afPegger
using fandoc::HtmlDocWriter

internal class MarkdownTest : Test {
	
	Str parseToHtml(Str markdown, Bool trimLines := true) {
		parser	:= MarkdownParser()
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
