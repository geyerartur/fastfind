import std/[json, sets, os, strutils, times]
import crawler as cr

const K = 3

type IndexFile = object
  path, name, extension: string
  size: int64

proc sweep(query: string, k: int): seq[cr.File] =
  let db_path = getEnv("LOCALAPPDATA") / ".fastfind" / "index.json"
  var result: seq[cr.File]

  if query.len < k:
    return @[]

  var chunksSeq: seq[string] = @[]

  for i in 0 ..< query.len - k + 1:
    chunksSeq.add(query[i ..< i + k])

  let db = parseFile(db_path)
  if db.kind != JArray:
    return @[]

  var seen: HashSet[string]

  for node in db:
    let fileNode = cr.File(
      path: node["path"].getStr(),
      name: node["name"].getStr(),
      kind: pcFile, # temporary default
      extension: node["extension"].getStr(),
      size: node["size"].getInt(),
      creationTime: fromUnix(0),   # placeholder
      lastModified: fromUnix(0)    # placeholder
    )

    for chunk in chunksSeq:
      if fileNode.name.contains(chunk) and not seen.contains(fileNode.path):
        seen.incl(fileNode.path)
        result.add(fileNode)

  return result


proc search*(query: string): seq[cr.File] =
  result = sweep(query, K)

  return result