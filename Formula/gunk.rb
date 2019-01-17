$pkg     = "github.com/gunk/gunk"
$ver     = "v0.0.1"
$hash    = ""

$tags    = %w()
$ldflags = "-s -w -X #{$pkg}.version=#{$ver}"

class Gunk < Formula
  desc     "gunk - the modern frontend for protocol buffers"
  homepage "https://#{$pkg}"
  head     "https://#{$pkg}.git"
  url      "https://#{$pkg}/archive/#{$ver}.tar.gz"
  sha256   $hash

  depends_on "go" => :build

  def install
    (buildpath/"src/#{$pkg}").install buildpath.children

    cd "src/#{$pkg}" do
      system "go", "mod", "download"
      system "go", "build",
        "-tags",    $tags.join(" "),
        "-ldflags", $ldflags,
        "-o",       bin/"gunk"
    end
  end

  test do
    output = shell_output("#{bin}/gunk --version")
    assert_match "gunk #{$ver}", output
  end
end
