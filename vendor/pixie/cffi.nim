# =========================================
# Mutable C string (aka `unsigned char*`)
# =========================================

type
  cmstring* = distinct cmstringImpl
  cmstringImpl {.importc: "NU8*".} = cstring

proc `$`*(self: cmstring): string {.borrow.}

# =========================================
# Immutable C string (aka `const unsigned char*`)
# =========================================

type
  cistring* = distinct cistringImpl
  cistringImpl {.importc: "const NU8*".} = cstring

proc `$`*(self: cistring): string {.borrow.}
