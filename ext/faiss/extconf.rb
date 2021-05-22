require "mkmf-rice"

abort "BLAS not found" unless have_library("blas")
abort "LAPACK not found" unless have_library("lapack")
abort "OpenMP not found" unless have_library("omp") || have_library("gomp")

numo = $LOAD_PATH.find { |v| File.exist?("#{v}/numo/numo/narray.h") }
$INCFLAGS << " -I#{numo}/numo" if numo
abort "Numo not found" unless have_header("numo/narray.h")

$CXXFLAGS << " -std=c++17 $(optflags) -DFINTEGER=int " << with_config("optflags", "-march=native")

ext = File.expand_path(".", __dir__)
vendor = File.expand_path("../../vendor/faiss", __dir__)

$srcs = Dir["{#{ext},#{vendor}/faiss,#{vendor}/faiss/{impl,invlists,utils}}/*.{cpp}"]
$objs = $srcs.map { |v| v.sub(/cpp\z/, "o") }
$INCFLAGS << " -I#{vendor}"
$VPATH << vendor

create_makefile("faiss/ext")
