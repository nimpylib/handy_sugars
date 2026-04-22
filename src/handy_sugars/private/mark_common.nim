
import std/macros

template addErrorPragma*(result; msg: NimNode) =
  result.body = newEmptyNode()
  result.addPragma newColonExpr(
    ident"error",
    msg,
  )

const
  DocSep = "\n\n"
func prependDocAndClearOther*(res: NimNode, docToPrepend: string) =
  let n = docToPrepend
  var body = res.body
  if body[0].kind != nnkCommentStmt:
    res.body = newCommentStmtNode(n)
  else: res.body = newCommentStmtNode(n & DocSep & body[0].strVal)

