
internal class TestText : MarkdownTest {
	
	Void testText() {
		markdown := "this text should\nhave a space"
		html	 := "<p>this text should have a space</p>"
		verifyEq(html.trim, parseToHtml(markdown, false))
	}
}
