### 🛑 STOP 🛑 THIS FILE IS GENERATED BY bbctl's `make brew-regenerate`.
### Do NOT modify by hand.

# homebrew formula HOWTO: https://rubydoc.brew.sh/Formula.html
class Bbctl < Formula
  desc "Simplifies development, operations, and maintenance of Big Bang"
  homepage "https://repo1.dso.mil/big-bang/apps/developer-tools/bbctl"
  url "https://repo1.dso.mil/big-bang/apps/developer-tools/bbctl/-/archive/v1.5.0/bbctl-v1.5.0.tar.gz"
  sha256 "cce59014b3f35a6bbe03425552886b41f8f15885d6b4d4afbd791ce637946d46"
  license "Apache-2.0"
  head "https://repo1.dso.mil/big-bang/apps/developer-tools/bbctl.git", branch: "main"

  # TODO: prebuilt binaries can be downloaded directly if we can set them up
  # See: https://docs.brew.sh/Bottles
  # bottle do
  # end

  depends_on "go" => :build

  def install
    # CGO is not needed by bbctl and was causing issues on some linuxbrew installs
    ENV["CGO_ENABLED"] = "0"

    # This formula hardcodes buildDate to match the actual released_at date of
    # the bbctl tag it's building against so we can still trust it as a proxy
    # for 'How out of date is your local bbctl binary?'
    build_date_key = "repo1.dso.mil/big-bang/apps/developer-tools/bbctl/static.buildDate"
    build_date_val = "2025-07-21 18:20:15.384 +0000 UTC"

    # To see available flags and descriptions: `go build -ldflags="-help" ./main.go`
    # -s is disable symbol table
    # -w is disable DWARF generation
    system "go", "build", *std_go_args(ldflags: "-s -w -X '#{build_date_key}=#{build_date_val}'")

    #######
    # Primary TODO:
    # make bbctl run out of the box with safe defaults
    # ... so that we can
    #  - install the completions
    #  - and a smoke test of the newly installed binary
    #  - and maybe a manpage someday

    # TODO: use cobra's manpage generator to add a `bbctl man` subcommand
    # man_page = Utils.safe_popen_read(bin/"bbctl", "man")
    # (man1/"bbctl.1").write man_page

    # TODO: fix completion generation - fails with a suspicious error
    # about not being able to find ~/.bbctl/config which actually exists
    # generate_completions_from_executable(bin/"bbctl", "completion")
  end

  test do
    # See https://rubydoc.brew.sh/Homebrew/Assertions
    assert_includes shell_output(bin/"bbctl").chomp, "Big Bang"
  end
end
