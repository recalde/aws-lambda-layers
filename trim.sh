#!/bin/bash
# trim.sh: Remove unnecessary files from a Python Lambda layer to reduce size
# Usage: ./trim.sh <site-packages-dir>

set -e

SITE_PACKAGES="$1"

if [ -z "$SITE_PACKAGES" ]; then
  echo "Usage: $0 <site-packages-dir>"
  exit 1
fi

# Remove test, doc, and cache folders
find "$SITE_PACKAGES" -type d \( -name tests -o -name test -o -name __pycache__ -o -name doc -o -name docs -o -name examples -o -name benchmarks -o -name data -o -name datasets \) -prune -exec rm -rf {} +

# Remove dist-info and egg-info
find "$SITE_PACKAGES" -type d \( -name '*.dist-info' -o -name '*.egg-info' \) -prune -exec rm -rf {} +

# Remove source, config, and build files
find "$SITE_PACKAGES" -type f \( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' -o -name '*.pyx' -o -name '*.pxd' -o -name '*.pxi' -o -name '*.md' -o -name '*.rst' -o -name '*.txt' -o -name '*.yml' -o -name '*.yaml' -o -name '*.ini' -o -name '*.toml' -o -name '*.cfg' \) -delete

# Remove large BLAS/LAPACK and unused binaries
find "$SITE_PACKAGES" -type f \( -name 'libopenblasp*.so*' -o -name 'liblapack*.so*' -o -name 'libblas*.so*' -o -name 'libgfortran*.so*' -o -name 'libquadmath*.so*' -o -name '*.a' -o -name '*.dylib' -o -name '*.dll' \) -delete

# Remove unused data files
find "$SITE_PACKAGES" -type f \( -name '*.dat' -o -name '*.csv' -o -name '*.json' -o -name '*.pickle' -o -name '*.h5' -o -name '*.hdf5' -o -name '*.mat' -o -name '*.sav' -o -name '*.sas7bdat' -o -name '*.xpt' -o -name '*.arff' -o -name '*.pkl' -o -name '*.npz' -o -name '*.npy' \) -delete

# Strip shared object files
find "$SITE_PACKAGES" -name '*.so' -exec strip --strip-unneeded {} + 2>/dev/null || true

echo "Trim complete for $SITE_PACKAGES"
