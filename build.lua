-- Builds the installable .g1rcart from cart.lua + label.png.
-- Uses the engine's own CartManifest so the format can never drift:
--   luajit build.lua <path-to-gen1recomp> [outfile]
local engine = assert(arg[1], "usage: luajit build.lua <gen1recomp path> [out]")
local outPath = arg[2]
package.path = engine .. "/?.lua;" .. engine .. "/?/init.lua;" .. package.path

love = require("tests.love_stub")
local CartManifest = require("src.carts.CartManifest")
local Base64 = require("src.core.Base64")

local here = (arg[0]:match("^(.*)[/\\]") or ".")
local cart = dofile(here .. "/cart.lua")

local f = assert(io.open(here .. "/label.png", "rb"), "label.png is missing")
local png = f:read("*a")
f:close()
-- The label has to travel inside the cart: a .g1rcart is one self-contained
-- file, so the art is base64 in the manifest rather than a sibling file.
cart.labelArt = { encoding = "base64", data = Base64.encode(png), bytes = #png }

local parsed, err = CartManifest.parse(cart)
if not parsed then
  io.stderr:write("cart.lua is not valid: " .. tostring(err) .. "\n")
  os.exit(1)
end
local art, artErr = CartManifest.parseLabelArt(cart.labelArt)
if not art then
  io.stderr:write("label.png rejected: " .. tostring(artErr) .. "\n")
  os.exit(1)
end
parsed.labelArt = art

local blob = CartManifest.encode(parsed)
outPath = outPath or (here .. "/" .. parsed.id .. CartManifest.EXT)
local out = assert(io.open(outPath, "wb"))
out:write(blob)
out:close()

local back, decodeErr = CartManifest.decode(blob)
if not back then
  io.stderr:write("built cart does not decode: " .. tostring(decodeErr) .. "\n")
  os.exit(1)
end
print(("%s  %s v%s  %d bytes  hash %s"):format(outPath, back.title,
  back.version, #blob, CartManifest.hash(back)))
print(("label art %d bytes, %d pinned mod(s), seal %s"):format(
  back.labelArt and back.labelArt.bytes or 0, #back.mods, back.seal))
