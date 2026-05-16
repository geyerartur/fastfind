import crawler, indexer, std/[os, strutils]

type
  Command = enum
    cmdIndex, cmdSearch, cmdHelp

proc printHelp() =
  echo """
fastfind - Blazing fast file search for Windows

Usage:
  fastfind index <path>         Index files in a directory
  fastfind search <query>       Search indexed files
  fastfind help                 Show this help

Examples:
  fastfind index C:\Users\You\Documents
  fastfind search invoice
"""

proc parseCommand(): Command =
  let args = commandLineParams()
  if args.len == 0:
    return cmdHelp
  
  case args[0].toLowerAscii()
  of "index": return cmdIndex
  of "search": return cmdSearch
  else: return cmdHelp

proc main() =
  let cmd = parseCommand()
  case cmd
  of cmdHelp:
    printHelp()
  of cmdIndex:
    if commandLineParams().len < 2:
      echo "Error: Need a path to index"
      printHelp()
    else:
      let path = commandLineParams()[1]
      echo "Indexing: ", path
      let files = crawler.walkDirectory(path)
      echo "Got ", files.len, " files"
      let index = indexer.buildIndex(files)
  of cmdSearch:
    if commandLineParams().len < 2:
      echo "Error: Need a search query"
      printHelp()
    else:
      let query = commandLineParams()[1]
      echo "Searching for: ", query
      # TODO: call search logic

when isMainModule:
  main()