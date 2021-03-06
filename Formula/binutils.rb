class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.29.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.29.tar.gz"
  sha256 "172e8c89472cf52712fd23a9f14e9bca6182727fb45b0f8f482652a83d5a11b4"

  bottle do
    cellar :any if OS.linux?
    sha256 "a86ec8b9b8628f5dd5e237470e0faf5d9e3d3ebbb9fede28d0eb99f4955a44bb" => :sierra
    sha256 "bff7053d7a7730222d80939bfd56cabcb9e97c80e07cfa5adb82d940aa2ace9e" => :el_capitan
    sha256 "f220539e4ad8d0139f8dc302675cb9e8fba139e2272646e65eddb8c106cdde2d" => :yosemite
    sha256 "f46901271365421cb4fb6cdb3f1b289ee55313974f3529da3d813cfeb03a6d78" => :x86_64_linux # glibc 2.5
  end

  # No --default-names option as it interferes with Homebrew builds.
  option "with-default-names", "Do not prepend 'g' to the binary" if OS.linux?
  option "without-gold", "Do not build the gold linker" if OS.linux?

  depends_on "zlib" => :recommended unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          ("--program-prefix=g" if build.without? "default-names"),
                          ("--with-sysroot=/" if OS.linux?),
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          ("--enable-gold" if build.with? "gold"),
                          ("--enable-plugins" if OS.linux?),
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold" if build.with? "gold"

    # Reduce the size of the bottle.
    system "strip", *Dir[bin/"*", lib/"*.a"] unless OS.mac?
  end

  test do
    size = build.with?("default-names") ? "size" : "gsize"
    assert_match "text", shell_output("#{bin}/#{size} #{bin}/#{size}")
  end
end
