
internal class TestHeadings : MarkdownTest {
	
	Void testHeadings() {
		markdown :=
"# h1
 ## h2
 ###   h3   ###
 ####h4##
 ##### h5 ################
 ###### h6
 ####### 7 hashes will never be a heading
 "
		html :=
"<h1>h1</h1>
 <h2>h2</h2>
 <h3>h3</h3>
 <h4>h4</h4>
 <h5>h5</h5>
 <h6>h6</h6>
 <p>####### 7 hashes will never be a heading</p> 
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testHeadingCanEndList() {
		// 'cos this is what the crappy Fantom MarkdownWriter generates
		markdown :=
"* Stuff
 * Moar Stuff
 ## <a name='sfx'></a>sfxTitle
 Stuff
 "
		html :=
"<ul>
 <li>Stuff</li>
 <li>Moar Stuff</li>
 </ul>
 <h2 id='sfx'>sfxTitle</h2>
 <p>Stuff</p>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
