using fandoc::FandocDocWriter
using fandoc::FandocParser

internal class TestAll : MarkdownTest {
	
	Void testFandoc() {
		str :=
		"- list item with no leading space

		 1. Numbered title with no leading space
		 =======================================
		 "

		parser	:= FandocParser()
		fandoc	:= parser.parseStr(str)

		// this fails, see "Fandoc parsing bug" - https://fantom.org/forum/topic/2712
		verifyEq(0, parser.errs.size)
	}
	
	Void testFandoc2() {
		str		:= "Lines separated with a single newline\nend up separated with a space"
		fandoc	:= FandocParser().parseStr(str)
		verifyEq(fandoc.children.first->children->first.toStr, "Lines separated with a single newline end up separated with a space")
	}
	
	Void testParser() {
//		Log.get("afPegger").level = LogLevel.debug
		
		//mdown	:= `test/communityResources.md`.toFile.readAllStr
		mdown	:= `test/nhaystack.md`.toFile.readAllStr
//		doc		:= MarkdownParser().parse(mdown)

		buf		:= StrBuf()
//		doc.writeChildren(FandocDocWriter(buf.out))
		
		`test/nhaystack.fandoc`.toFile.out.writeChars(buf.toStr).close
		
		buf.clear
		fandoc	:= FandocParser().parseStr(buf.toStr)
		fandoc.writeChildren(FandocDocWriter(buf.out))

		echo(buf.toStr)
	}
	
	** Mainly for this to look good: https://stackhub.org/package/itwToolkitExt
	Void testCollapses() {
		markdown := ""
		html	 := ""

		// test code blocks may immediately follow text
		markdown = "Example:\n```\nCode\n```"
		html	 ="<p>Example:</p>\n\n<pre>Code</pre>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		// test --- hr --- are put on own line
		markdown = "Example\n-----\nText"
		html	 ="<p>Example</p>\n\n<hr/>\n\n<p>Text</p>"
		verifyEq(html.trim, parseToHtml(markdown, false))
		
		// test block quotes may immediately follow text 
		markdown = "Example\n> Quote"
		html	 ="<p>Example</p>\n\n<blockquote>Quote</blockquote>"
		verifyEq(html.trim, parseToHtml(markdown, false))
	}
}
