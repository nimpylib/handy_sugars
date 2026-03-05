
import std/macros
proc dotSlash(id: NimNode): NimNode = prefix(id, "./")
macro impExp*(pre, names) =
  ##[
    ```Nim
    impExp module, [
      submod1, submod2,
    ]
    ```
    ->
    ```Nim
    import module/[submod1, submod2]
    export submod1, submod2
    ```
  ]##
  result = newStmtList()
  let imp = infix(pre, "/", names)
  result.add nnkImportStmt.newTree(imp)
  let exp = newNimNode nnkExportStmt
  for name in names:
    exp.add name
  result.add exp

macro impExpCwd*(pre, names) =
  ## like `impExp`_ but prefix `pre` with `./`
  ##
  ## `impExpCwd module, xxx` -> `import ./module/xxx; export xxx
  getAst impExp(dotSlash(pre), names)

