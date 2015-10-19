
internal class TestBoldAndItalics : MarkdownTest {
	
	Void testItalicStars() {
		markdown := "Look, I'm *italic*!!"
		html 	 := "<p>Look, I'm <em>italic</em>!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
		
		markdown = "Look, I'm * not * !!"
		html 	 = "<p>Look, I'm * not * !!</p>"
		verifyEq(html.trim, parseToHtml(markdown))

		// too tricky for now, can't be arsed
//		markdown = "Look, I'm \\*not\\* !!"
//		html 	 = "<p>Look, I'm *not* !!</p>"
//		verifyEq(html.trim, parseToHtml(markdown))		
	}

	Void testItalicUnderscore() {
		markdown := "Look, I'm _italic_!!"
		html 	 := "<p>Look, I'm <em>italic</em>!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
		
		markdown = "Look, I'm _ not _ !!"
		html 	 = "<p>Look, I'm _ not _ !!</p>"
		verifyEq(html.trim, parseToHtml(markdown))

		// too tricky for now, can't be arsed
//		markdown = "Look, I'm \\_not\\_ !!"
//		html 	 = "<p>Look, I'm _not_ !!</p>"
//		verifyEq(html.trim, parseToHtml(markdown))		
	}

	Void testBoldStars() {
//				Log.get("afPegger").level = LogLevel.debug

		markdown := "Look, I'm **bold**!!"
		html 	 := "<p>Look, I'm <strong>bold</strong>!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testBoldUnderscore() {
		markdown := "Look, I'm __bold__!!"
		html 	 := "<p>Look, I'm <strong>bold</strong>!!</p>"
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
