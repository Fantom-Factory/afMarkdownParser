using util
using fandoc

class Main : AbstractMain
{
  
  @Arg { help = "Source Markdown (.md) or Fandoc (.fandoc) file to convert." }
  File? srcFile
  
  @Opt { aliases=["l"]; help = "Sets the logging level to any of [silent, err, warn, info, debug]." }
  LogLevel loggingLevel := LogLevel.info
  
  
  
  override Int run()
  {
    log.level = loggingLevel
    
    ext := srcFile.ext
    if( ext == null ) { throw Err( "Source file must have either .md (Markdown) or .fandoc (Fandoc) extension." ) }
    
        mdLines := srcFile.open( "r" ).readAllLines
    content := ""
    mdLines.each {
      content = content + "\r\n" + it
    }
    
    log.debug( content )
    
    exitCode := 0
   
    switch( ext.lower )
    {
      case "md": exitCode = parseMarkdown( content )
      case "fandoc": exitCode = parseFandoc( content )
      default: throw Err( "Unsupported file extension: .${ext}; only .md and .fandoc files are supported." )
    }
    return exitCode
  }
  
  
  Int parseMarkdown( Str mdContent )
  {
    markdownDoc := MarkdownParser().parse( mdContent )
    
    buf := StrBuf()
    markdownDoc.write( FandocDocWriter( buf.out ) )

    log.info( buf.toStr )
    return 0
  }
  
  
  Int parseFandoc( Str fandocContent )
  {
    log.info( fandocContent )
    return 0
  }
  
}
