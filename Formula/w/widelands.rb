class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://github.com/widelands/widelands/archive/refs/tags/v1.1.tar.gz"
  sha256 "6853fcf3daec9b66005691e5bcb00326634baf0985ad89a7e6511502612f6412"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "61081d835e355e9f80be98916e0836a2c386400c6a3057a27f3d899ddb07a1d4"
    sha256 arm64_ventura:  "ee57091b74a55cbf42bb2e9c6e983ba17e0be2ba30afb573cfb59054f0dae4d5"
    sha256 arm64_monterey: "85df81a479cf0fa18b78745a8a6d5a16f5ae019e80d33dbd6db79437375368c4"
    sha256 arm64_big_sur:  "c7edcf86e8a31bb60d8e334edbb68e73b7cbbe4aa3b4cd2e6940e33ebb4a09ad"
    sha256 sonoma:         "f5d67fa0786b75e5f3b8b7e7beaa99a0c8ec5444eac3d7d82e52affacb6beebc"
    sha256 ventura:        "9de42ad9c8193ee67bd78388bc10642cfe44b1c86a309b7ad9a351bf865fe99f"
    sha256 monterey:       "a195384db2c5cfbf7fb6da9a6cbe093cd92b57c03be3e6a018dcd18a4bdc5059"
    sha256 big_sur:        "fce1361f17bf45e67e2f60100fba285364e42890b43810079cae19bc5010b3b0"
    sha256 x86_64_linux:   "510fcbb44beed3d73da985066e4b025bba843087da917716f1a4d71112de39a2"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "glew"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWL_INSTALL_BASEDIR=#{pkgshare}",
                    "-DWL_INSTALL_BINDIR=#{bin}",
                    "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                    "-DOPTION_BUILD_CODECHECK=OFF",
                    "-DOPTION_BUILD_TESTS=OFF",
                    "-DOPTION_BUILD_WEBSITE_TOOLS=OFF",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.linux?
      # Unable to start Widelands, because we were unable to add the home directory:
      # RealFSImpl::make_directory: No such file or directory: /tmp/widelands-test/.local/share/widelands
      mkdir_p ".local/share/widelands"
      mkdir_p ".config/widelands"
    end

    system bin/"widelands", "--version"
  end
end
