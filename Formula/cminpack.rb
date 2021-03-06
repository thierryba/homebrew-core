class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.6.tar.gz"
  sha256 "3c07fd21308c96477a2c900032e21d937739c233ee273b4347a0d4a84a32d09f"
  head "https://github.com/devernay/cminpack.git"

  bottle do
    cellar :any
    sha256 "16664c7714c7e4337d453cc709dcee658662b7b61735608a278d81314557a08f" => :sierra
    sha256 "ea2b1e1a4d1323e47df94c5fff2b66a8d3ecd2800f5f1dab788994e37192c628" => :el_capitan
    sha256 "83b0004c7f4a707f51ee402f9d99f85f3c2d7f865c33f96f0a7ee85abfdb8ec1" => :yosemite
    sha256 "f0dabad706896821bdfa93060ba2d9c1794c521e17f0bfc411f857b0da459531" => :x86_64_linux # glibc 2.19
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples"

    unless OS.mac?
      lib64 = Pathname.new "#{lib}64"
      mv lib64, lib if lib64.directory?
    end
  end

  test do
    cp pkgshare/"examples/thybrdc.c", testpath
    system ENV.cc, pkgshare/"examples/thybrdc.c", "-o", "test",
                   "-I#{include}/cminpack-1", "-L#{lib}", "-lcminpack", "-lm"
    assert_match "number of function evaluations", shell_output("./test")
  end
end
