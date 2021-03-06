class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz"
  sha256 "317484352271d18cbbcfac3868eab798d67fff1b8402e740baa6ff41d588a9d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd8699f3944eb87b76fc89e4ca69f19df5d66aa8a4c89d636660d299e807f5b0" => :sierra
    sha256 "cd8699f3944eb87b76fc89e4ca69f19df5d66aa8a4c89d636660d299e807f5b0" => :el_capitan
    sha256 "cd8699f3944eb87b76fc89e4ca69f19df5d66aa8a4c89d636660d299e807f5b0" => :yosemite
    sha256 "05712571f085c9c1f4624dacc8a0c1d98aa2b5ba8db0d61640b41ca3198cee06" => :x86_64_linux
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/default-icon-theme.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-silent-rules]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    File.exist? share/"icons/hicolor/index.theme"
  end
end
