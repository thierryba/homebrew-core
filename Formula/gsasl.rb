class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-1.8.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-1.8.0.tar.gz"
  sha256 "310262d1ded082d1ceefc52d6dad265c1decae8d84e12b5947d9b1dd193191e5"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f37b1e2171acd1ed587c75827854750f2be04302147fb3fc05672c3e3cfe42f0" => :sierra
    sha256 "8dbca0c2938ab3b5077fe7ed572437a0f724e479a7f102d9c40f959b1483f09d" => :el_capitan
    sha256 "afc44c1161ffa2ae09bee4a82c25e626562d950ae092356fba204789e4b4752e" => :yosemite
    sha256 "df498ac7247b3f54bdc9720249fa4a1cee72bf8c5011d06889d8ecdebaff1aaa" => :mavericks
    sha256 "5585b8bddf849b2b4b3f67da253c97556bfa526b8345006595cdefddf3385dd5" => :mountain_lion
    sha256 "efb441d35f31009dec66cfece15834e5fd1be441b62d914e3632f33c7631c5e1" => :x86_64_linux # glibc 2.19
  end

  depends_on "libntlm" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gsasl")
  end
end
