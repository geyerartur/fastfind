import std/os
import std/times

type
  File* = object
    path*: string
    name*: string
    kind*: PathComponent
    extension*: string
    size*: int64
    creationTime*: Time
    lastModified*: Time

proc getKind(path: string): PathComponent =
  if dirExists(path):
    pcDir
  else:
    pcFile

proc toFile(path: string): File =
  let sp = splitPath(path)
  let sf = splitFile(path)

  File(
    path: path,
    name: sp.tail,
    kind: getKind(path),
    extension: sf.ext,
    size: getFileSize(path),
    creationTime: getCreationTime(path),
    lastModified: getLastModificationTime(path)
  )

proc walkDirectory*(path: string): seq[File] =
  for file in walkDirRec(path):
    if fileExists(file):
      result.add(toFile(file))