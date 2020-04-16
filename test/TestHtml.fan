
internal class TestHtml : MarkdownTest {
	
	Void testHtml() {
		markdown := "## <a name=\"overview\"></a>Overview"
		html 	 := "<h2 id='overview'>Overview</h2>"
		verifyEq(html.trim, parseToHtml(markdown))

		markdown = "##   <a id = ' overview '>  </a>   Overview"
		html 	 = "<h2 id='overview'>Overview</h2>"
		verifyEq(html.trim, parseToHtml(markdown))

		markdown = "## <a name=overview></a>Overview"
		html 	 = "<h2 id='overview'>Overview</h2>"
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
