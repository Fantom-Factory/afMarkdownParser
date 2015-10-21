
internal class TestImages : MarkdownTest {
	
	Void testLinks() {
		markdown := "![Fantom-Factory](http://www.fantomfactory.org/)"
		html 	 := "<img src='http://www.fantomfactory.org/' alt='Fantom-Factory'/>"
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testImagesDoNotSpanLines() {
		markdown := "![Fantom-\nFactory](http://www.fantomfactory.org/)"
		html 	 := "<p>![Fantom-Factory](http://www.fantomfactory.org/)</p>"
		verifyEq(html.trim, parseToHtml(markdown))

		markdown = "![Fantom-Factory](http://www.fantom\nfactory.org/)"
		html 	 = "<p>![Fantom-Factory](http://www.fantomfactory.org/)</p>"
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
