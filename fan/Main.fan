using util
using fandoc

class Main : AbstractMain
{
  
  @Arg { help = "Source Markdown (.md) or Fandoc (.fandoc) file to convert." }
  File? srcFile
  
  @Opt { aliases=[ "o" ]; help = "Overwrite target file if exists. By default aborts the process if the target file exists." }
  Bool overwrite := false
  
  @Opt { aliases=[ "l" ]; help = "Sets the logging level to any of [silent, err, warn, info, debug]." }
  LogLevel logLevel := LogLevel.info
  
  
  File? outputFile
  
  
  override Int run()
  {
    log.level = logLevel
    log.info( "Log level: ${log.level}" )
    
    ext := srcFile.ext
    if( ext == null ) { throw Err( "Source file must have either .md (Markdown) or .fandoc (Fandoc) extension." ) }
    
    exitCode := 0
   
    switch( ext.lower )
    {
      case "md": exitCode = parseMarkdown
      case "fandoc": exitCode = parseFandoc
      default: throw Err( "Unsupported file extension: .${ext}; only .md and .fandoc files are supported." )
    }
    return exitCode
  }
  
  
  Str readInput()
  {
    log.info( "Reading source file ${srcFile}" )
    content := srcFile.readAllBuf.in.readAllStr
    log.debug( content )
    return content
  }
  
  
  Buf getOutputBuffer( Str ext )
  {
    outputFile = File( Uri( srcFile.basename + ".${ext}" ) )
    if( outputFile.exists && !overwrite ) { throw Err( "Process aborted because the target file exists `${outputFile}`. Use option -o to overwrite." ) }
    log.info( "Creating output file `${outputFile}`" )
    return outputFile.open( "rw" )
  }
  
  
  Int parseMarkdown()
  {
    buf := getOutputBuffer( "fandoc" )
    markdownDoc := MarkdownParser().parse( readInput )
    log.info( "Markdown file parsed" )
    markdownDoc.write( FandocDocWriter( buf.out ) )
    log.debug( buf.toStr )
    log.info( "Done" )
    return buf.close ? 0 : -1
  }
  
  
  Int parseFandoc()
  {
    readInput
    return 0
  }
  
}
