FROM public.ecr.aws/lambda/python:3.12 as builder

# Install build dependencies
RUN yum install -y gcc-c++ make cmake unzip zip python3-devel git

# Install pip tools
RUN python3 -m ensurepip && \
    python3 -m pip install --upgrade pip setuptools wheel

# Layer directory layout
ENV PYTHON_VERSION=3.12
WORKDIR /layer
RUN mkdir -p python

# Accept requirements file as build argument
ARG REQUIREMENTS=requirements.txt

# Copy requirements and install
COPY ${REQUIREMENTS} ./requirements.txt
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt -t python/

# Install lambda-trim
RUN python3 -m pip install lambda-trim && \
    lambda-trim python/

# Fix google namespace if needed
RUN touch python/google/__init__.py || true

# Zip it up properly
RUN zip -r9 /layer.zip python