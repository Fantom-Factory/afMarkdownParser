
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
//		Log.get("afPegger").level = LogLevel.debug
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

	Void testParagraphListItems() {
//		Log.get("afPegger").level = LogLevel.debug
		markdown :=
" * Red
 
    Green
 
    Blue
  * Red2
 
    Green2
 
    Blue2
 "

		html :=
"<ul>
 <li>
 <p>Red</p>
 <p>Green</p>
 <p>Blue</p>
 </li>
 <li>
 <p>Red2</p>
 <p>Green2</p>
 <p>Blue2</p>
 </li>
 </ul>"
		verifyEq(html.trim, parseToHtml(markdown))
	}
}
