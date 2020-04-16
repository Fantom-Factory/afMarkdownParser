using afPegger
using fandoc::HtmlDocWriter

internal class MarkdownTest : Test {
	
	Bool debug
	
	Str parseToHtml(Str markdown, Bool trimLines := true) {
		Peg#.pod.log.level	= debug ? LogLevel.debug : LogLevel.info

		parser	:= MarkdownParser()
		grammar	:= parser.grammar
		match	:= grammar["markdown"].match(markdown) ?: throw ParseErr("Could not parse Markdown")
		match.dump
		fandoc	:= MarkdownWalker(parser).walk(match).root

		buf		:= StrBuf()
		fandoc.writeChildren(HtmlDocWriter(buf.out))
		html	:= buf.toStr.replace("\n\n", trimLines ? "\n" : "\n\n").trim
		echo(html)
		return html
	}
}
