
internal class TestUnorderedLists : MarkdownTest {
	
	Void testUnorderedLists() {

		markdown :=
"* Red
  + Green
   - Blue
 "

		html :=
"<ul>
 <li>Red</li>
 
 <li>Green</li>
 
 <li>Blue</li>
 </ul>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testHangingIndents() {
		Log.get("afPegger").level = LogLevel.debug

		markdown :=
"  * Red, 
     Green, 
     Blue
 "

		html :=
"<ul>
 <li>Red, Green, Blue</li>
 </ul>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}

	Void testLazyIndents() {
		Log.get("afPegger").level = LogLevel.debug

		markdown :=
"  * Red, 
 Green, 
 Blue
 "

		html :=
"<ul>
 <li>Red, Green, Blue</li>
 </ul>
 "
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
