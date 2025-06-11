# AWS Lambda Layers: PyArrow & Utility Layer

This repo builds two AWS Lambda Layers using GitHub Actions:

1. `pyarrow-layer.zip`: Contains `pyarrow`
2. `utils-layer.zip`: Contains `boto3`, `protobuf`, and `pandas`

## 🛠 Usage

- Go to the **Actions tab**
- Run the **Build Lambda Layers** workflow
- Download artifacts: `pyarrow-layer.zip` and `utils-layer.zip`

## 🚀 Deploy Example

```bash
aws lambda publish-layer-version \
  --layer-name pyarrow \
  --zip-file fileb://pyarrow-layer.zip \
  --compatible-runtimes python3.11

aws lambda publish-layer-version \
  --layer-name lambda-utils \
  --zip-file fileb://utils-layer.zip \
  --compatible-runtimes python3.11