#!/usr/bin/env bash
# GridGuard — one-time environment setup
# Run from the gridguard/ directory:  bash setup_env.sh
set -e

GRIDGUARD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$GRIDGUARD_DIR"

echo "── GridGuard environment setup ──────────────────────────"
echo "   Directory: $GRIDGUARD_DIR"
echo ""

# 1. Create venv inheriting system PyTorch (ROCm)
if [ ! -d ".venv" ]; then
  echo "Creating .venv with system site packages (inherits PyTorch ROCm)..."
  uv venv --python /usr/bin/python3 --system-site-packages .venv
else
  echo "✓ .venv already exists"
fi

# 2. Verify torch is inherited
TORCH_VER=$(.venv/bin/python3 -c "import torch; print(torch.__version__)" 2>/dev/null || echo "MISSING")
if [[ "$TORCH_VER" == "MISSING" ]]; then
  echo "ERROR: PyTorch not found in .venv — system Python may have changed"
  exit 1
fi
GPU=$(.venv/bin/python3 -c "import torch; print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU only')" 2>/dev/null)
echo "✓ PyTorch $TORCH_VER  GPU: $GPU"

# 3. Install notebook extras
echo "Installing notebook packages..."
uv pip install --python .venv/bin/python3 \
  pandas pyarrow seaborn matplotlib joblib requests ipykernel 2>&1 | tail -3

# 4. Register Jupyter kernel
echo "Registering Jupyter kernel..."
.venv/bin/python3 -m ipykernel install --user \
  --name gridguard \
  --display-name "GridGuard — Python 3.13 (ROCm)"

# 5. Frontend deps
if [ -f "package.json" ]; then
  echo "Installing npm dependencies..."
  npm install --silent
  echo "✓ npm deps installed"
fi

echo ""
echo "── Setup complete ────────────────────────────────────────"
echo "  Jupyter kernel: GridGuard — Python 3.13 (ROCm)"
echo "  Activate venv:  source .venv/bin/activate"
echo "  Run notebook:   jupyter lab notebooks/train_and_serve.ipynb"
echo "  Dev server:     npm run dev"
