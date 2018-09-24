
internal class TestCodeSpans : MarkdownTest {
	
	Void testCode() {
		markdown := "Look, I'm `code`!!"
		html 	 := "<p>Look, I'm <code>code</code>!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
		
		markdown = "Look, I'm ` still code ` !!"
		html 	 = "<p>Look, I'm <code> still code </code> !!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testCodeDoesNotSpanLines() {
		markdown := "Look, I'm `not\ncode`!!"
		html 	 := "<p>Look, I'm `not code`!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
