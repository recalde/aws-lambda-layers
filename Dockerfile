# Dockerfile

FROM amazonlinux:2023

# --- Install system dependencies (excluding python3-pip to avoid rpm conflict) ---
RUN dnf install -y gcc-c++ cmake make python3-devel unzip zip curl ca-certificates && \
    update-ca-trust

# --- Install pip cleanly from source to avoid RPM-managed conflicts ---
RUN curl -sSLO https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# --- Upgrade setuptools and wheel ---
RUN pip install --upgrade setuptools wheel

# --- Define Python version for directory layout ---
ENV PYTHON_VERSION=3.11
WORKDIR /opt

# --- Install pyarrow to Lambda-compatible path ---
RUN pip install pyarrow -t python/lib/python${PYTHON_VERSION}/site-packages

# --- Strip shared libraries to reduce ZIP size ---
RUN find python/lib/python${PYTHON_VERSION}/site-packages/pyarrow -name "*.so" -exec strip --strip-unneeded {} \; || true

# --- Clean up unnecessary files to reduce ZIP size ---
RUN rm -rf python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/tests \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/include \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/*.pyd \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/*.cmake \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/__pycache__

# --- Create the Lambda layer ZIP ---
RUN cd python && zip -r9 /pyarrow-layer.zip .