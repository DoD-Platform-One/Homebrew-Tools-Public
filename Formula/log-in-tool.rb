# This tool establishes a secure network tunnel to an AWS EKS cluster by leveraging AWS Systems Manager (SSM), a bastion instance, and sshuttle. It simplifies connecting to private endpoints inside a VPC without requiring VPN infrastructure or direct SSH access.
class LogInTool < Formula
  desc "EKS Bastion Tunnel Tool using AWS SSM"
  homepage "https://repo1.dso.mil/big-bang/apps/developer-tools/log-in-tool"

  url "https://repo1.dso.mil/big-bang/apps/developer-tools/log-in-tool",
      using:    :git,
      tag:      "v0.1.10",
      revision: "0356b80bc1c979e8a2c7d22f799d0cfc20bd0f78"

  license "Apache-2.0"
  head "https://repo1.dso.mil/big-bang/apps/developer-tools/log-in-tool.git", branch: "main"

  depends_on "go" => :build

  def install
    # CGO is not needed by log-in-tool and was causing issues on some linuxbrew installs
    ENV["CGO_ENABLED"] = "0"

    # To see available flags and descriptions: `go build -ldflags="-help" ./main.go`
    # -s is disable symbol table
    # -w is disable DWARF generation
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=0.1.10'")
  end

  test do
    want_return_code = 2
    got_result_text = shell_output("#{bin}/log-in-tool --help", want_return_code).chomp

    # See https://rubydoc.brew.sh/Homebrew/Assertions
    want_result_text = "pflag: help requested"
    assert_includes(got_result_text, want_result_text)
  end
end
