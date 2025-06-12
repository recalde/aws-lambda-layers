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

The resulting `/layer.zip` file is created inside the Docker container. To extract it locally, run:

```bash
docker create --name temp-layer <image-name>
docker cp temp-layer:/layer.zip ./layer.zip
docker rm temp-layer
```

Replace `<image-name>` with the tag you used above (e.g., `pandas-layer`).

Alternatively, use the provided GitHub Actions workflow (`.github/workflows/build_layers.yml`) to automate building and uploading the layer zip files as artifacts.

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