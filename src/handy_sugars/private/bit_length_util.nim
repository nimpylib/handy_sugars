
import std/bitops
export popcount
const BitPerByte = 8
proc bit_length*(self: SomeInteger): int =
  template abs_v: untyped =
    when self is SomeSignedInt: abs(self)
    else: self
  when defined(noUndefinedBitOpts):
    1 + fastLog2(abs_v)
  else:
    sizeof(self) * BitPerByte - bitops.countLeadingZeroBits abs_v
