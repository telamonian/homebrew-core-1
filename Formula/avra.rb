class Avra < Formula
  desc "Assember for the Atmel AVR microcontroller family"
  homepage "https://avra.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avra/1.3.0/avra-1.3.0.tar.bz2"
  sha256 "a62cbf8662caf9cc4e75da6c634efce402778639202a65eb2d149002c1049712"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2fd31c2a27b2ef237a6c9e33d7b378682dcba6b79131717f6c97264999b85658" => :sierra
    sha256 "a53990c229653465948d9d66fc972e695591cddf6529c25ad834fed7fbd7267d" => :el_capitan
    sha256 "1fd6d746309dbdf2811ba8d461188ec63e93363a34546a3af7ad9b4f47c75ffc" => :yosemite
    sha256 "003cb0324d01616cdc62c13c0384587bd4a8f82e7eedff2f26b5c17841eae75f" => :x86_64_linux
  end

  # Crashes with 'abort trap 6' unless this fix is applied.
  # See: https://sourceforge.net/p/avra/patches/16/
  patch do
    url "https://gist.githubusercontent.com/adammck/7e4a14f7dd4cc58eea8afa99d1ad9f5d/raw/5cdbfe5ac310a12cae6671502697737d56827b05/avra-fix-osx.patch"
    sha256 "03493058c351cfce0764a8c2e63c2a7b691601dd836c760048fe47ddb9e91682"
  end if OS.mac?

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # build fails if these don't exist
    touch "NEWS"
    touch "ChangeLog"
    cd "src" do
      inreplace "bootstrap", "/bin/sh", "/bin/bash"
      system "./bootstrap"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
    pkgshare.install Dir["includes/*"]
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert_match "Assembly complete with no errors.", output
    assert File.exist?("test.hex")
    assert_match "ldi r16,0x42", File.read("test.lst")
  end
end
