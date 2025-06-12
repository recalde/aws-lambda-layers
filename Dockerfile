# Dockerfile
# Debian-based Lambda layer builder with lambda-trim
# Compatible with AWS Lambda Python 3.12

FROM python:3.12-slim as builder

ARG REQUIREMENTS=requirements.txt
ENV LAYER_DIR=/opt/layer
ENV PYTHON_VERSION=3.12

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    unzip \
    zip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Prepare Lambda layer folder structure
WORKDIR ${LAYER_DIR}
RUN mkdir -p python

# Copy requirements file into container
COPY ${REQUIREMENTS} ./requirements.txt

# Install Python packages to /python
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt -t python/

# Install lambda-trim and use it to shrink the packages
RUN pip install lambda-trim && \
    lambda-trim python/

# Ensure google namespace init (common for pyarrow)
RUN touch python/google/__init__.py || true

# Zip the contents in Lambda-compatible layout
RUN zip -r9 /layer.zip python

# Output the final zip file
CMD cp /layer.zip /out/layer.zip