# 🧱 AWS Lambda Layers: PyArrow, Pandas, and Protobuf

This project builds three AWS Lambda layers using Docker and GitHub Actions:

## 📦 Built Layers

| Layer Name       | Included Packages         | Notes |
|------------------|----------------------------|-------|
| `pyarrow-layer`  | `pyarrow`                  | For Apache Arrow and Parquet workloads |
| `pandas-layer`   | `pandas`                   | For DataFrame operations and analysis |
| `protobuf-layer` | `protobuf`                 | For working with protocol buffers |
| `common-layer`   | `pandas`, `pyarrow`, `protobuf`, `googleapis-common-protos` | All-in-one layer |

Each layer is built using a single Dockerfile and a different requirements file, zipped in a Lambda-compatible format under `python/lib/python3.12/site-packages`.

---

## 🚀 How to Use

### 🛠 Build a Layer

Build a layer by specifying the requirements file as a build argument:

```bash
DOCKER_BUILDKIT=1 docker build --build-arg REQUIREMENTS=requirements.pandas.txt -t pandas-layer .
DOCKER_BUILDKIT=1 docker build --build-arg REQUIREMENTS=requirements.pyarrow.txt -t pyarrow-layer .
DOCKER_BUILDKIT=1 docker build --build-arg REQUIREMENTS=requirements.protobuf.txt -t protobuf-layer .
DOCKER_BUILDKIT=1 docker build --build-arg REQUIREMENTS=requirements.common.txt -t common-layer .
```

The resulting `/layer.zip` file will be your Lambda layer.

---

### 🧬 Upload Layers to AWS

After downloading the ZIP files:

```bash
aws lambda publish-layer-version \
  --layer-name <layer-name> \
  --zip-file fileb://layer.zip \
  --compatible-runtimes python3.12
```

Replace `<layer-name>` with the appropriate name (e.g., `pandas`, `pyarrow`, `protobuf`, or `common`).