using fandoc

internal class TestAll : MarkdownTest {
	
	Void testParser() {
		
//		Log.get("afPegger").level = LogLevel.debug
		
		parseToHtml(`test/communityResources.md`.toFile.readAllStr)

		//		parser := MarkdownParser()
//		fandoc := parser.parse(`test/cheatsheet.md`.toFile.readAllStr)
//		buf := StrBuf()
//		fandoc.write(FandocDocWriter(buf.out))
//		echo(buf.toStr)
	}
	
}
