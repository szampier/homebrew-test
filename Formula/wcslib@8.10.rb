class WcslibAT810 < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-8.10.tar.bz2"
  sha256 "447ecb7be9b43798f4d7f10855f3f39f826ad550bc9b330ced4736960fc65289"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
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
