class LinuxHeaders < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.80.tar.gz"
  sha256 "291d844619b5e7c43bd5aa0b2c286274fc5ffe31494ba475f167a21157e88186"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9d7edb2760ec070372d6dd37f2dff85c34221cf77d124d4732092447ac2cf9f" => :x86_64_linux
  end

  def install
    system "make", "headers_install", "INSTALL_HDR_PATH=#{prefix}"
    rm Dir[prefix/"**/{.install,..install.cmd}"]
  end

  test do
    assert_match "KERNEL_VERSION", File.read(include/"linux/version.h")
  end
end
