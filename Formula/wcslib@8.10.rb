class WcslibAT810 < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.10.tar.bz2"
  sha256 "b394d3306da9a52410f056136911496e599b5c48f1cff2f221563697077bbd8d"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/szampier/homebrew-test/releases/download/wcslib@8.10-8.10"
    sha256 cellar: :any, arm64_golden_gate: "b8f4573b0317af24eec58429854d30ea076f578a0e6833239869e198db91c384"
    sha256 cellar: :any, arm64_tahoe:       "853502d506e32e3e9c463491156fdd287e46b690a737342f357dbac730c38bb5"
    sha256 cellar: :any, arm64_sequoia:     "4e5429ecc63f355a2cc1d7def1e15dac993f399f81c15b7c7ef50e775f9923b5"
    sha256 cellar: :any, arm64_sonoma:      "07e268a3caa90ec7ec170a24bf787fe35d83867268ad04f00f838222b8703bdd"
    sha256 cellar: :any, arm64_linux:       "2340e40833f620eb87403e4dc8f0403243f83874ce5f82b4bd33ad8307b27fd8"
    sha256 cellar: :any, x86_64_linux:      "59d6c97c1dc3cc214c72160cba04f4bafa14d691389dbc4743bbf3c4db2eb11d"
  end

  depends_on "cfitsio"

  deny_network_access!

  def install
    # Remove all the revision control files which mention prior GPL license
    # to avoids accidentally compiling GPL code which would impact license.
    rm_r buildpath.glob("**/RCS/")

    system "./configure", "--disable-fortran",
                          "--with-cfitsiolib=#{formula_opt_lib("cfitsio")}",
                          "--with-cfitsioinc=#{formula_opt_include("cfitsio")}",
                          "--without-pgplot",
                          *std_configure_args
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
