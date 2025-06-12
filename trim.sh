#!/bin/bash
# trim.sh: Remove unnecessary files from a Python Lambda layer to reduce size
# Usage: ./trim.sh <site-packages-dir>

set -e

SITE_PACKAGES="$1"

if [ -z "$SITE_PACKAGES" ]; then
  echo "Usage: $0 <site-packages-dir>"
  exit 1
fi

# Remove test, doc, cache, and build folders
find "$SITE_PACKAGES" -type d \( -name tests -o -name test -o -name __pycache__ -o -name doc -o -name docs -o -name Doc -o -name Docs -o -name DOC -o -name DOCS -o -name examples -o -name benchmarks -o -name data -o -name datasets -o -name build -o -name tmp -o -name temp -o -name .pytest_cache -o -name .mypy_cache -o -name .hypothesis -o -name .tox -o -name .git -o -name .github -o -name .idea -o -name .vscode \) -prune -exec rm -rf {} +

# Remove dist-info, egg-info, and metadata
find "$SITE_PACKAGES" -type d \( -name '*.dist-info' -o -name '*.egg-info' -o -name '*.pth' -o -name '*.whl' -o -name '*.metadata' -o -name '*.egg' \) -prune -exec rm -rf {} +

# Remove source, config, and build files
find "$SITE_PACKAGES" -type f \( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' -o -name '*.pyx' -o -name '*.pxd' -o -name '*.pxi' -o -name '*.md' -o -name '*.rst' -o -name '*.txt' -o -name '*.yml' -o -name '*.yaml' -o -name '*.ini' -o -name '*.toml' -o -name '*.cfg' -o -name '*.log' -o -name '*.bat' -o -name '*.sh' -o -name '*.ps1' -o -name '*.cmake' -o -name '*.am' -o -name '*.in' -o -name '*.m4' -o -name '*.pyc' -o -name '*.pyo' \) -delete

# Remove large BLAS/LAPACK and unused binaries
find "$SITE_PACKAGES" -type f \( -name 'libopenblasp*.so*' -o -name 'liblapack*.so*' -o -name 'libblas*.so*' -o -name 'libgfortran*.so*' -o -name 'libquadmath*.so*' -o -name '*.a' -o -name '*.dylib' -o -name '*.dll' \) -delete

# Remove unused data and cache files
find "$SITE_PACKAGES" -type f \( -name '*.dat' -o -name '*.csv' -o -name '*.json' -o -name '*.pickle' -o -name '*.h5' -o -name '*.hdf5' -o -name '*.mat' -o -name '*.sav' -o -name '*.sas7bdat' -o -name '*.xpt' -o -name '*.arff' -o -name '*.pkl' -o -name '*.npz' -o -name '*.npy' -o -name '*.gz' -o -name '*.bz2' -o -name '*.xz' -o -name '*.zip' -o -name '*.tar' -o -name '*.7z' -o -name '*.rar' \) -delete

# Remove static and test binaries
find "$SITE_PACKAGES" -type f \( -name '*.o' -o -name '*.obj' -o -name '*.exp' -o -name '*.lib' -o -name '*.pdb' -o -name '*.so.debug' \) -delete

# Remove documentation, HTML, and Jupyter files
find "$SITE_PACKAGES" -type f \( -name '*.html' -o -name '*.pdf' -o -name '*.ipynb' -o -name '*.svg' -o -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.gif' -o -name '*.rst' -o -name '*.docx' -o -name '*.pptx' -o -name '*.xls' -o -name '*.xlsx' \) -delete

# Remove Windows and MacOS specific files
find "$SITE_PACKAGES" -type f \( -name '*.pyd' -o -name '*.dll' -o -name '*.exe' -o -name '*.dylib' -o -name 'Thumbs.db' -o -name '.DS_Store' \) -delete

# Remove leftover empty directories
find "$SITE_PACKAGES" -type d -empty -delete

# Strip shared object files
find "$SITE_PACKAGES" -name '*.so' -exec strip --strip-unneeded {} + 2>/dev/null || true

# Remove unused parts of pyarrow
find "$SITE_PACKAGES/pyarrow" -type d \( -name 'tests' -o -name 'benchmark' -o -name 'benchmarks' -o -name 'cuda' -o -name 'csv' -o -name 'dataset' -o -name 'feather' -o -name 'flight' -o -name 'fs' -o -name 'gandiva' -o -name 'hdfs' -o -name 'json' -o -name 'orc' -o -name 'plasma' -o -name 'substrait' -o -name 'compute' -o -name 'parquet/encryption' \) -prune -exec rm -rf {} +

# Remove unused parts of numpy
find "$SITE_PACKAGES/numpy" -type d \( -name 'tests' -o -name 'testing' -o -name 'f2py' -o -name 'doc' -o -name 'docs' -o -name 'benchmarks' \) -prune -exec rm -rf {} +

# Remove numpy .c, .h, .pyx, .pxd, .pxi, .md, .rst, .txt, .yml, .yaml, .ini, .toml, .cfg, .log, .bat, .sh, .ps1, .cmake, .am, .in, .m4, .pyc, .pyo files
find "$SITE_PACKAGES/numpy" -type f \( -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' -o -name '*.pyx' -o -name '*.pxd' -o -name '*.pxi' -o -name '*.md' -o -name '*.rst' -o -name '*.txt' -o -name '*.yml' -o -name '*.yaml' -o -name '*.ini' -o -name '*.toml' -o -name '*.cfg' -o -name '*.log' -o -name '*.bat' -o -name '*.sh' -o -name '*.ps1' -o -name '*.cmake' -o -name '*.am' -o -name '*.in' -o -name '*.m4' -o -name '*.pyc' -o -name '*.pyo' \) -delete

# Remove unused parts of pandas (plotting, tests, io, and more)
find "$SITE_PACKAGES/pandas" -type d \
    \( -name 'tests' -o -name 'testing' -o -name 'plotting' -o -name 'io' -o -name 'formats' -o -name 'compat' -o -name 'tseries' -o -name 'core/arrays' -o -name 'core/reshape' -o -name 'core/algorithms' -o -name 'core/computation' -o -name 'core/groupby' -o -name 'core/window' -o -name 'core/ops' -o -name 'core/dtypes' -o -name 'core/indexes' -o -name 'core/internals' -o -name 'core/sparse' -o -name 'core/tools' -o -name 'core/util' \) \
    -prune -exec rm -rf {} +

# Remove pandas doc files
find "$SITE_PACKAGES/pandas" -type f \
    \( -name '*.md' -o -name '*.rst' -o -name '*.txt' -o -name '*.csv' -o -name '*.json' -o -name '*.html' -o -name '*.png' -o -name '*.svg' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.gif' \) -delete

# Suggestion: Remove locale and timezone data if not needed
find "$SITE_PACKAGES" -type d \( -name 'locale' -o -name 'tzdata' -o -name 'zoneinfo' \) -prune -exec rm -rf {} +

# Suggestion: Remove all .py files if you only need .so/.pyd (compiled) modules for Lambda
# Uncomment the next line if you are sure you do not need any .py files:
# find "$SITE_PACKAGES" -type f -name '*.py' -delete

echo "Trim complete for $SITE_PACKAGES"
