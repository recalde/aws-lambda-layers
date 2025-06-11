FROM amazonlinux:2023

RUN dnf install -y gcc-c++ cmake make python3-devel python3-pip unzip zip ca-certificates && \
    update-ca-trust && \
    python3 -m pip install --upgrade pip setuptools wheel

ENV PYTHON_VERSION=3.11
WORKDIR /opt

RUN python3 -m pip install pyarrow -t python/lib/python${PYTHON_VERSION}/site-packages

RUN find python/lib/python${PYTHON_VERSION}/site-packages/pyarrow -name "*.so" -exec strip --strip-unneeded {} \; || true

RUN rm -rf python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/tests \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/include \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/*.pyd \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/*.cmake \
           python/lib/python${PYTHON_VERSION}/site-packages/pyarrow/__pycache__

RUN cd python && zip -r9 /pyarrow-layer.zip .
