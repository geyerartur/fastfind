version = "0.1.0"
author = "Geyer Artur"
description = "Fast file indexer and search for Windows"
license = "MIT"
srcDir = "src"
binDir = "dist"
bin = @["fastfind"]

requires "nim >= 2.2.6"

task test, "Run all tests":
  exec "nim r tests/test_crawler.nim"
  exec "nim r tests/test_indexer.nim"