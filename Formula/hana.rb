class Hana < Formula
  desc "The Boost.Hana C++14 metaprogramming library"
  homepage "https://github.com/boostorg/hana"
  url "https://github.com/boostorg/hana/archive/v1.2.0.tar.gz"
  sha256 "ebee14728839ef71803eeefecd8ee514833a784a38cf2e0ab3c214f618cd1e26"
  head "https://github.com/boostorg/hana.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c9329119dc9298abdeacc64b121eb1c96c6818ce5c0b595ac5c9c93e1b1a8a2" => :sierra
    sha256 "1c9329119dc9298abdeacc64b121eb1c96c6818ce5c0b595ac5c9c93e1b1a8a2" => :el_capitan
    sha256 "1c9329119dc9298abdeacc64b121eb1c96c6818ce5c0b595ac5c9c93e1b1a8a2" => :yosemite
    sha256 "16f92529262a20b5c32634043063991454653d89dff7f007b32f61c1f37af261" => :x86_64_linux # glibc 2.19
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <boost/hana.hpp>

      constexpr auto xs = boost::hana::make_tuple(1, '2', 3.3);
      static_assert(xs[boost::hana::size_c<0>] == 1, "");
      static_assert(xs[boost::hana::size_c<1>] == '2', "");
      static_assert(xs[boost::hana::size_c<2>] == 3.3, "");

      int main() { }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}", "-otest", *ENV.cppflags
    system "./test"
  end
end
