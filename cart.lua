-- The cart's source. build.lua turns this plus label.png into the
-- .g1rcart the launcher installs.
return {
  id = "omega_random_competition",
  title = "OMEGA RANDOM COMPETITION",
  version = "1.0.0",
  author = "bryanthaboi",
  base = "red",
  seal = "sealed",
  shell = "#7B1B22",
  finish = "holo",
  speeds = { 1, 2 },
  summary = "Bois Club Randomizer as its own cartridge. One seed, paired warps, 1x or 2x only.",
  repo = "bryanthaboi/omega-random-competition",
  mods = {
    { id = "bcr", source = "github", repo = "bryanthaboi/bcr",
      version = "1.0.0",
      sha256 = "83a111b49c4e8c4fd4d6886d60a673372cb9e9d334e091360048587da23938f0" },
  },
  load_order = { "bcr" },
}
