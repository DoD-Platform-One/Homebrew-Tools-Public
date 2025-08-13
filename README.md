# homebrew-tools-public

Big Bang's [homebrew](https://brew.sh/) tap for distributing end user tooling.

Homebrew bills itself as "The Missing Package Manager for macOS (or Linux)".

## User Setup

### 1. You'll need `brew` installed

First, install homebrew on your Mac or Linux machine by following their [official instructions](https://brew.sh/).

### 2. Then add this repository as a "tap"

Add this repository as a homebrew tap:

```console
> brew tap bigbang/tools-public https://repo1.dso.mil/big-bang/apps/developer-tools/homebrew-tools-public.git

==> Tapping bigbang/tools-public
Cloning into '/opt/homebrew/Library/Taps/bigbang/homebrew-tools-public'...
remote: Enumerating objects: 168, done.
remote: Counting objects: 100% (33/33), done.
remote: Compressing objects: 100% (20/20), done.
remote: Total 168 (delta 22), reused 13 (delta 13), pack-reused 135 (from 1)
Receiving objects: 100% (168/168), 27.27 KiB | 9.09 MiB/s, done.
Resolving deltas: 100% (65/65), done.
Tapped 2 formulae (27 files, 48.5KB).
```

### 3. Finally, install `bbctl`

Install `bbctl` from our tap:

```console
❯ brew install bbctl
==> Downloading https://formulae.brew.sh/api/formula.jws.json
######################################################################################### 100.0%
==> Downloading https://formulae.brew.sh/api/cask.jws.json
######################################################################################### 100.0%
==> Fetching bigbang/tools-public/bbctl
==> Downloading https://repo1.dso.mil/big-bang/product/packages/bbctl/-/archive/0.7.6/bbctl-0.7.
  -#O=-#   #     #
==> Installing bbctl from bigbang/tools-public
==> go build -ldflags=-s -w -X static.buildDate=2025-01-09T22:54:09Z
🍺  /opt/homebrew/Cellar/bbctl/0.7.6: 7 files, 91.6MB, built in 6 seconds
```

## References

- [`bbctl` home](https://repo1.dso.mil/big-bang/apps/developer-tools/bbctl)
- [`brew` home](https://brew.sh/)
