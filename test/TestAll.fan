using fandoc

internal class TestAll : MarkdownTest {
	
	Void testParser() {
		
//		Log.get("afPegger").level = LogLevel.debug
		
		parseToHtml(`test/communityResources.md`.toFile.readAllStr)

		//		parser := MarkdownParser()
//		fandoc := parser.parse(`test/cheatsheet.md`.toFile.readAllStr)
//		buf := StrBuf()
//		fandoc.write(FandocDocWriter(buf.out))
//		echo(buf.toStr)
	}
	
	
	** Mainly for: https://stackhub.org/package/itwToolkitExt
	Void testCollapses() {

		// text code blocks may immediately follow text
		markdown := "Example:\n```\nCode\n```"
		html	 :="<p>Example:</p>\n\n<pre>Code</pre>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		// text --- hr --- are put on own line
		
		markdown = "Example\n-----\nText"
		html	 ="<p>Example</p>\n<p>----</p><p>Text</p>"
		verifyEq(html.trim, parseToHtml(markdown, false))
		
	}
	
}
