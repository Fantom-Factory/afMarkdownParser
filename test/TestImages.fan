//
//internal class TestImages : MarkdownTest {
//	
//	Void testLinks() {
//		markdown := "![Fantom-Factory](http://www.fantomfactory.org/)"
//		html 	 := "<img src='http://www.fantomfactory.org/' alt='Fantom-Factory'/>"
//		verifyEq(html.trim, parseToHtml(markdown))
//	}
//
//	Void testImagesDoNotSpanLines() {
//		markdown := "![Fantom-\nFactory](http://www.fantomfactory.org/)"
//		html 	 := "<p>![Fantom- Factory](http://www.fantomfactory.org/)</p>"
//		verifyEq(html.trim, parseToHtml(markdown))
//
//		markdown = "![Fantom-Factory](http://www.fantom\nfactory.org/)"
//		html 	 = "<p>![Fantom-Factory](http://www.fantom factory.org/)</p>"
//		verifyEq(html.trim, parseToHtml(markdown))
//	}
//
//	Void testImageTitlesAreParsedAndIngored() {
//		markdown := """![alt text](http://i.imgur.com/RSoce9q.jpg "FC-20")"""
//		html 	 := "<img src='http://i.imgur.com/RSoce9q.jpg' alt='alt text'/>"
//		verifyEq(html.trim, parseToHtml(markdown))
//	}
//
//	Void testImageAndText() {
//		markdown := "![Fan](http://www.fantomfactory.org/)\n\nSausages"
//		html 	 := "<img src='http://www.fantomfactory.org/' alt='Fan'/>\n<p>Sausages</p>"
//		verifyEq(html.trim, parseToHtml(markdown))
//	}
//}
