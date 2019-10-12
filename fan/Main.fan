using util
using fandoc

class Main : AbstractMain
{
  
  @Arg { help = "Source Markdown (.md) or Fandoc (.fandoc) file to convert." }
  File? srcFile
  
  @Arg { help = "Name of the destination file. Defaults to source filename with the opposite extension." }
  Str[]? targetFile
  
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
    uri := targetFile != null 
      ? Uri( targetFile[ 0 ] ) 
      : srcFile.uri.plusName( srcFile.basename + ".${ext}" )
    outputFile = File( uri )
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
    buf := getOutputBuffer( "md" )
    fandocDoc := FandocParser().parse( srcFile.name, srcFile.in )
    log.info( "Fandoc file parsed" )
    fandocDoc.write( MarkdownDocWriter( buf.out ) )
    log.debug( buf.toStr )
    log.info( "Done" )
    return buf.close ? 0 : -1
  }
  
}
