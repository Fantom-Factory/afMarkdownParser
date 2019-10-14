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
  
  
  override Int run()
  {
    log.level = logLevel
    log.info( "Log level: ${log.level}" )
    
    ext := srcFile.ext
    if( ext == null ) {
      throw Err( "Source file must have either .md (Markdown) or .fandoc (Fandoc) extension." )
    }
    switch( ext.lower )
    {
      case "md": parseMarkdown
      case "fandoc": parseFandoc
      default: throw Err( "Unsupported file extension: .${ext}; only .md and .fandoc files are supported." )
    }
    return 0
  }
  
  
  Str readInput()
  {
    log.info( "Reading source file `${srcFile}`" )
    content := srcFile.readAllStr
    log.debug( content )
    return content
  }
  
  
  OutStream openOutputStream( Str ext )
  {
    uri := targetFile != null 
      ? Uri( targetFile[ 0 ] ) 
      : srcFile.uri.plusName( srcFile.basename + ".${ext}" )
    outputFile := File( uri )
    if( outputFile.exists && !overwrite ) {
      throw Err( "Process aborted because the target file exists `${outputFile}`. Use option -o to overwrite." )
    }
    log.info( "Creating output file `${outputFile}`" )
    return outputFile.out
  }
  
  
  Void parseMarkdown()
  {
    markdownDoc := MarkdownParser().parse( readInput )
    log.info( "Markdown file parsed" )
    outStream := openOutputStream( "fandoc" )
    markdownDoc.write( FandocDocWriter( outStream ) )
    closeOutput( outStream )
  }
  
  
  Void parseFandoc()
  {
    log.info( "Reading source file `${srcFile}`" )
    fandocDoc := FandocParser().parse( srcFile.name, srcFile.in )
    log.info( "Fandoc file parsed" )
    outStream := openOutputStream( "md" )
    fandocDoc.write( MarkdownDocWriter( outStream ) )
    closeOutput( outStream )
  }
  
  
  Void closeOutput( OutStream outStream )
  {
    outStream.flush
    log.debug( outStream.toStr )
    outStream.close
    log.info( "Done" )
  }
  
}
