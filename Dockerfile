# Builds a Lambda-compatible layer from a passed-in requirements file
FROM public.ecr.aws/lambda/python:3.12 as builder

# Inputs (from build args)
ARG REQUIREMENTS=requirements.txt

# Install system packages for building wheels
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc g++ make cmake unzip zip git python3-dev && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m ensurepip && python3 -m pip install --upgrade pip setuptools wheel

WORKDIR /layer
RUN mkdir -p python

# Copy in requirements file and install
COPY ${REQUIREMENTS} ./requirements.txt
RUN pip install -r requirements.txt -t python/

# Install lambda-trim and trim the layer
RUN pip install lambda-trim && lambda-trim python/

# Fix namespace package issues (e.g., google/)
RUN touch python/google/__init__.py || true

# Zip up into Lambda-compatible structure
RUN zip -r9 /layer.zip python

CMD cp /layer.zip /out/layer.zip