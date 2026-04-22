
import std/macros
import ./private/mark_common

const nimDoc = defined(nimdoc)
macro platformAvailImpl(inPlat: static[bool]; platStr: static[string]; def) =
  if nimDoc:
    def.prependDocAndClearOther ".. hint:: `Availability" &
        "<https://docs.python.org/3/library/intro.html#availability>`_: " &
          platStr
    return def
  if inPlat:
    return def
  result = def
  result.addErrorPragma(newLit "this is only available on platform: " & platStr & '.')

template platformAvail*(platform; def) =
  ## Pragma on procs to generate doc of sth like `Availability: Windows.`
  ##
  ## Currently, `platform` must be something
  ## that can be put within `defined`.
  bind platformAvailImpl
  platformAvailImpl(defined(platform), astToStr(platform), def)

template platformAvailWhen*(platform; cond: bool; def) =
  bind platformAvailImpl
  platformAvailImpl(defined(platform) and cond,
    astToStr(platform) & " when " & astToStr(cond), def)

template platformUnavail*(platform; def) =
  bind platformAvailImpl
  platformAvailImpl(not defined(platform), "not " & astToStr(platform), def)

template platformNoJs*(def) =
  bind platformUnavail
  platformUnavail(js, def)


