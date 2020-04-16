using fandoc::FandocDocWriter
using fandoc::FandocParser

internal class TestNHaystack : MarkdownTest {

	** This is a large document that posed me lots of problems! 
	Void testNHaystack() {
//		Log.get("afPegger").level = LogLevel.debug
		
		//mdown	:= `test/communityResources.md`.toFile.readAllStr
		mdown	:= `test/nhaystack.md`.toFile.readAllStr
		doc		:= MarkdownParser().parse(mdown)

		buf		:= StrBuf()
		doc.writeChildren(FandocDocWriter(buf.out))
		
		`test/nhaystack.fandoc`.toFile.out.writeChars(buf.toStr).close
		
		buf.clear
		fandoc	:= FandocParser().parseStr(buf.toStr)
		fandoc.writeChildren(FandocDocWriter(buf.out))

		echo(buf.toStr)
	}
}
