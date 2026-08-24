# OMEGA RANDOM COMPETITION

A custom cartridge for [gen1recomp](https://github.com/bryanthaboi/gen1recomp). It
ships one mod, the [Bois Club Randomizer](https://github.com/bryanthaboi/bcr),
pinned to a version and sealed, so every copy of this cart is the same cart.

## The rules it enforces

- **One mod, sealed.** BCR at a pinned version and nothing else. The mod set
  cannot be added to, taken from, or switched off.
- **1x or 2x only.** The speed ladder is pinned, so there is no fast-forwarding
  past a bad encounter.
- **One seed per run**, taken from your player name and the clock when you start.

## Installing it

Download `omega_random_competition.g1rcart` from
[Releases](../../releases), drop it in the launcher's carts folder, and pick it
from Custom Carts on the Red page. If BCR is not installed, the cart's page
offers to install it at the pinned version; it refuses any archive whose hash is
not the one this cart recorded.

## What is in this repo

| File | Role |
|---|---|
| `cart.lua` | the cart itself: title, shell, seal, speeds, and the pinned mod |
| `label.png` | the label art |
| `build.lua` | builds the installable `.g1rcart` |

A `.g1rcart` is one self-contained text file, not an archive. The label art has
to travel with the cart, so `build.lua` base64s the PNG into the manifest. That
is why the built file is far larger than `cart.lua` suggests.

## Building it yourself

```sh
luajit build.lua /path/to/gen1recomp
```

It uses the engine's own `CartManifest` to encode, so the output can never drift
from what the launcher installs, and it decodes the result before writing to
prove the file is loadable.

## Cutting a release

Bump `version` in `cart.lua` and push to `main`. CI builds the cart and
publishes it with a `sha256sums.txt`. A version that already has a release is
skipped rather than rebuilt.

## Changing the pinned mod

`mods[1].sha256` must be the hash of the release archive BCR's own CI publishes,
not of a local build: the workflow rewrites the version inside the archive, so a
locally packed zip hashes differently. Take the value from BCR's
`sha256sums.txt`.
