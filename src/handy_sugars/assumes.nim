

when defined(nimPreviewSlimSystem):
  import std/[assertions]

const ShouldnotHere = "Shouldn't be here"
proc noreturnUnreachable*(msg = ShouldnotHere){.noReturn, inline, cdecl.} =
  # let optimizer to eliminate related branch
  doAssert false, msg

template unreachable*(msg = ShouldnotHere) = noreturnUnreachable(msg)
template `!!`*[E: CatchableError](err: typedesc[E]; body) =
  ##[
  XXX:NIM-BUG:js-try-expr
  For expr, DO NOT use `!!` (use `!`_),
   `nim js` may make `x = KeyError!!d[k]` disappear in produced JS code.
  ]##
  try: body
  except E: noreturnUnreachable()

template `!`*[E: CatchableError; T: not void](err: typedesc[E]; e: T): T =
  var res: T
  try: res = e
  except E: noreturnUnreachable()
  res

