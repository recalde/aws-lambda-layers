# PyArrow Lambda Layer

This repo builds an AWS Lambda Layer with `pyarrow` using GitHub Actions and Docker.

## 📦 Usage

- Clone the repo and push to GitHub
- Go to the **Actions tab**
- Run the `Build PyArrow Lambda Layer` workflow
- After completion, download `pyarrow-layer.zip` from the workflow artifacts

## 🚀 Deploy to AWS Lambda

```bash
aws lambda publish-layer-version \
  --layer-name pyarrow \
  --zip-file fileb://pyarrow-layer.zip \
  --compatible-runtimes python3.11
```
