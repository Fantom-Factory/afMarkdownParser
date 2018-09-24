
internal class TestHr : MarkdownTest {
	
	Void testHr() {
		// examples from http://daringfireball.net/projects/markdown/syntax#hr
		// hr must START with the _-*
		markdown := "---\n"
		html	 := "<hr/>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		markdown = "---------------------------------------\n"
		html	 = "<hr/>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		markdown = "- - -\n"
		html	 = "<hr/>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		markdown = "-   -   -  \n"
		html	 = "<hr/>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		markdown = "** * **  \n"
		html	 = "<hr/>"
		verifyEq(html.trim, parseToHtml(markdown, false))

		markdown = "____  \n"
		html	 = "<hr/>"
		verifyEq(html.trim, parseToHtml(markdown, false))
	}	
}
