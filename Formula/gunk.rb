$pkg     = "github.com/gunk/gunk"
$ver     = "v0.1.0"
$hash    = "c2e60cba460d91ce8ec5f04105c51e0e5c28f9837b0853127d444c63c1fa79dc"

$tags    = %w()
$ldflags = "-s -w -X main.version=#{$ver}"

class Gunk < Formula
  desc     "gunk: the modern frontend and syntax for Protocol Buffers."
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
    output = shell_output("#{bin}/gunk version")
    assert_match "gunk #{$ver}", output
  end
end
