import std/[os]

proc main() =
  let args = commandLineParams()
  if args.len == 0:
    echo "fastfind - search files instantly"
    echo "Usage: fastfind <search term>"
  else:
    echo "Searching for: ", args[0]
    # later you'll call your indexer here

when isMainModule:
  main()