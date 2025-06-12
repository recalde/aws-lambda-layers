# 🧱 AWS Lambda Layers: PyArrow, Pandas, and Protobuf

This project builds three AWS Lambda layers using Docker and GitHub Actions:

## 📦 Built Layers

| Layer Name       | Included Packages         | Notes |
|------------------|----------------------------|-------|
| `pyarrow-layer`  | `pyarrow`                  | For Apache Arrow and Parquet workloads |
| `pandas-layer`   | `pandas`, `numpy`          | For DataFrame operations and analysis |
| `protobuf-layer` | `protobuf`                 | For working with protocol buffers |
| `common-layer`   | `pandas`, `pyarrow`, `protobuf`, `googleapis-common-protos` | All-in-one, aggressively trimmed for Lambda |

Each layer is zipped in a Lambda-compatible format under `python/lib/python3.12/site-packages`.

---

## 🧹 Layer Trimming

All layers are aggressively trimmed to remove tests, docs, examples, and unused submodules (especially for `pyarrow` and `pandas`). This keeps the ZIP files as small as possible for AWS Lambda deployment.

---

## 🚀 How to Use

### 🛠 Run the GitHub Action

1. Go to the **Actions** tab in GitHub.
2. Select the **"Build Lambda Layers"** workflow.
3. Click **"Run workflow"** (or push to `main` branch).
4. Wait for the job to finish and download the `.zip` files from the **Artifacts** section.

---

### 🧬 Upload Layers to AWS

After downloading the ZIP files:

```bash
aws lambda publish-layer-version \
  --layer-name pyarrow \
  --zip-file fileb://pyarrow-layer.zip \
  --compatible-runtimes python3.12

aws lambda publish-layer-version \
  --layer-name pandas \
  --zip-file fileb://pandas-layer.zip \
  --compatible-runtimes python3.12

aws lambda publish-layer-version \
  --layer-name protobuf \
  --zip-file fileb://protobuf-layer.zip \
  --compatible-runtimes python3.12

aws lambda publish-layer-version \
  --layer-name common \
  --zip-file fileb://common-layer.zip \
  --compatible-runtimes python3.12
```