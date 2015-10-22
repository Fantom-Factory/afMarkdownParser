using fandoc

internal class MarkdownTest : Test {
	
	Str parseToHtml(Str markdown, Bool trimLines := true) {
		parser	:= MarkdownParser()
		tree	:= parser.parseTree(markdown)
		echo(tree)
		fandoc	:= parser.toFandoc(tree) 
		buf		:= StrBuf()
		fandoc.writeChildren(HtmlDocWriter(buf.out))
		echo(buf.toStr)
		return buf.toStr.replace("\n\n", trimLines ? "\n" : "\n\n").trim
	}
}
