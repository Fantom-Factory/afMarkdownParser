
internal class TestBlockQuotes : MarkdownTest {
	
	Void testBlockQuotes() {
		markdown :=
"para 1
 
 > Pardon my french

 > Pardon my dutch
 para 2

 >   Pardon my german
 >Pardon my spanish
 "
		html :=
"<p>para 1</p>
 <blockquote>Pardon my french Pardon my dutch</blockquote>
 <p>para 2</p>
 <blockquote>Pardon my german Pardon my spanish</blockquote>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
