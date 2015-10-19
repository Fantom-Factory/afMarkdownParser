
internal class TestHeadings : MarkdownTest {
	
	Void testHeadings() {
		markdown :=
"# h1
 ## h2
 ### h3
 #### h4
 ##### Fandoc only supports 4 heading levels
 "
		html :=
"<h1>h1</h1>
 
 <h2>h2</h2>
 
 <h3>h3</h3>
 
 <h4>h4</h4>
 
 <p>##### Fandoc only supports 4 heading levels</p> 
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
