class ArtifactoryCliGo < Formula
  desc "Provides a command-line interface for Artifactory."
  homepage "https://github.com/JFrogDev/artifactory-cli-go"
  url "https://github.com/JFrogDev/artifactory-cli-go/archive/1.3.0.tar.gz"
  sha256 "29ba6b4cc46456caad300500050548fc0ad157fde102059e0778f0d68a35f4ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "00bed2e51bcbd00b4cc5267013ad99648ddd9b6093fd5405670a77fc9c424e37" => :sierra
    sha256 "de6ce27454f9a6568bd850a17c3522dafbb61023a926baa8e7dc5dc7524ebb7a" => :el_capitan
    sha256 "fdf4ca022e79f5c185a5e446ae0b3eadd010b269164ab62e3be253745d2bd696" => :yosemite
    sha256 "c2c517183bf08206441c3a76acdf64b061b61ee5b131597fca5aaa62cd60e634" => :mavericks
    sha256 "2d654d4b4d2483ea291222ccc403a5d6cf9d6a845db130a0e9f92f31c750079b" => :x86_64_linux # glibc 2.19
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JFrogDev/artifactory-cli-go/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/art", "-v", "github.com/JFrogDev/artifactory-cli-go/art/"
  end

  test do
    actual = pipe_output("#{bin}/art upload")
    expected = "The --url option is mandatory\n"
    assert_equal expected, actual
  end
end
