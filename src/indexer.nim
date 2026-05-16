import std/[json, syncio, os]
import crawler as cr

proc buildIndex*(files: seq[cr.File]): JsonNode =
  var index = newJArray()

  for file in files:
    var fileNode = newJObject()
    fileNode["path"] = %file.path
    fileNode["name"] = %file.name
    fileNode["size"] = %file.size
    fileNode["modified"] = %($file.lastModified)

    index.add(fileNode)

  
  let dir = getEnv("LOCALAPPDATA") / ".fastfind"
  if not dirExists(dir):
    createDir(dir)

  let dbPath = dir / "index.json"

  let db = open(dbPath, fmWrite)
  defer: db.close()
  db.write($index)

  return index