# Note: Mutt has a large number of non-upstream patches available for
# it, some of which conflict with each other. These patches are also
# not kept up-to-date when new versions of mutt (occasionally) come
# out.
#
# To reduce Homebrew's maintenance burden, patches are not accepted
# for this formula. The NeoMutt project has a Homebrew tap for their
# patched version of Mutt: https://github.com/neomutt/homebrew-neomutt

class Mutt < Formula
  desc "Mongrel of mail user agents (part elm, pine, mush, mh, etc.)"
  homepage "http://www.mutt.org/"
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-1.8.3.tar.gz"
  mirror "ftp://ftp.mutt.org/pub/mutt/mutt-1.8.3.tar.gz"
  sha256 "9b81746d67ffeca5ea44f60893b70dc93c86d4bc10187d4dd360185e4d42ed42"

  bottle do
    sha256 "f06ca16de5f58c6d0f520f3de8a5c90592b2a49038f5467b2918232a3cc03723" => :sierra
    sha256 "7f4c787cf932e62ac869f5cd30184f77d1ed0b72d91997d20ceb2f1cba41de8e" => :el_capitan
    sha256 "c112e913e38e65f8f9aa773d1035d478d57390910844f2f376087d3692f07185" => :yosemite
    sha256 "c5498f4f69f9d23218fb5bd72227085aa6445c1a5422694f5ba319672ca36eb6" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://dev.mutt.org/hg/mutt#default", :using => :hg

    resource "html" do
      url "https://dev.mutt.org/doc/manual.html", :using => :nounzip
    end
  end

  option "with-debug", "Build with debug option enabled"
  option "with-s-lang", "Build against slang instead of ncurses"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on "tokyo-cabinet"
  depends_on "gettext" => :optional
  depends_on "gpgme" => :optional
  depends_on "libidn" => :optional
  depends_on "s-lang" => :optional
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
    depends_on "krb5"
    depends_on "ncurses"
  end

  conflicts_with "tin",
    :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    begin
      user_admin = Etc.getgrnam("admin").mem.include?(ENV["USER"])
    rescue
      user_admin = false
    end

    args = %W[
      --disable-dependency-tracking
      --disable-warnings
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      #{OS.mac? ? "--with-sasl" : "--with-sasl2"}
      --with-gss
      --enable-imap
      --enable-smtp
      --enable-pop
      --enable-hcache
      --with-tokyocabinet
      --enable-sidebar
    ]

    # This is just a trick to keep 'make install' from trying
    # to chgrp the mutt_dotlock file (which we can't do if
    # we're running as an unprivileged user)
    args << "--with-homespool=.mbox" unless user_admin

    args << "--disable-nls" if build.without? "gettext"
    args << "--enable-gpgme" if build.with? "gpgme"
    args << "--with-slang" if build.with? "s-lang"

    if build.with? "debug"
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./prepare", *args
    system "make"

    # This permits the `mutt_dotlock` file to be installed under a group
    # that isn't `mail`.
    # https://github.com/Homebrew/homebrew/issues/45400
    if user_admin
      inreplace "Makefile", /^DOTLOCK_GROUP =.*$/, "DOTLOCK_GROUP = admin"
    end

    system "make", "install"
    doc.install resource("html") if build.head?
  end

  test do
    system bin/"mutt", "-D"
  end
end
