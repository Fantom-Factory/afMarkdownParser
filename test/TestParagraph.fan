
internal class TestParagraph : MarkdownTest {
	
	Void testParagraph() {
		markdown :=
"Paragraphs are very easy; separate them with a blank line. You can write your paragraph on one long line,
 or you can
 wrap the lines yourself
 if you prefer.
 
 para 2
 
 
 para 3
 "
		html :=
"<p>Paragraphs are very easy; separate them with a blank line. You can write your paragraph on one long line,or you canwrap the lines yourselfif you prefer.</p>
 <p>para 2</p>
 <p>para 3</p>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
