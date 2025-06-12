# Dockerfile for AWS Lambda Layer: generic (ARG-based requirements)
FROM amazonlinux:2023

ARG REQUIREMENTS=requirements.txt

# Install system dependencies
RUN dnf install -y --allowerasing gcc-c++ cmake make python3-devel unzip zip curl ca-certificates \
    && update-ca-trust \
    && dnf clean all

# Install pip from source
RUN curl -sSLO https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py

# Upgrade setuptools and wheel
RUN pip install --upgrade setuptools wheel

# Set Python version
ENV PYTHON_VERSION=3.12
WORKDIR /opt

# Copy requirements file and install dependencies
COPY ${REQUIREMENTS} ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt -t python/lib/python${PYTHON_VERSION}/site-packages \
    && pip uninstall -y pip setuptools wheel

# Ensure google/__init__.py exists for Lambda compatibility (for protobuf layer)
RUN mkdir -p python/lib/python${PYTHON_VERSION}/site-packages/google \
    && touch python/lib/python${PYTHON_VERSION}/site-packages/google/__init__.py

# Print uncompressed size of the layer
RUN du -sh python/lib/python${PYTHON_VERSION}/site-packages

# Create ZIP for Lambda layer with maximum compression
RUN cd python && zip -r -9 /layer.zip .
