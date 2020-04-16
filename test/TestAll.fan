
internal class TestAll : MarkdownTest {
	
	** Mainly for this to look good: https://stackhub.org/package/itwToolkitExt
	** It's not GOOD markdown but I suspect the dodgy Fandoc writer produces this
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
