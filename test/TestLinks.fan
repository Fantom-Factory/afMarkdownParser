
internal class TestLinks : MarkdownTest {
	
	Void testLinks() {
		markdown := "Link to [Fantom-Factory](http://www.fantomfactory.org/)!!"
		html 	 := "<p>Link to <a href='http://www.fantomfactory.org/'>Fantom-Factory</a>!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
		
		markdown = "Link to [Fantom-Factory](http://www.fantomfactory.org/)!!"
		html 	 = "<p>Link to <a href='http://www.fantomfactory.org/'>Fantom-Factory</a>!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testLinksDoNotSpanLines() {
		markdown := "Not a link to [Fantom-\nFactory](http://www.fantomfactory.org/)!!"
		html 	 := "<p>Not a link to [Fantom-Factory](http://www.fantomfactory.org/)!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))

		markdown = "Not a link to [Fantom-Factory](http://www.fantom\nfactory.org/)!!"
		html 	 = "<p>Not a link to [Fantom-Factory](http://www.fantomfactory.org/)!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
