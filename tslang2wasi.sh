#!/usr/bin/env bash
# TypeScript Native Compiler to wasm32-wasip1 using WASI-SDK
# guest271314 11-14-2026
# https://github.com/guest271314/native-messaging-tslang
set -e

TS_DIR="$HOME/bin/TypeScriptCompiler"
TS_DEFAULT_WASM_LIB_DIR="$TS_DIR/defaultlib/lib/wasm32/unknown/unknown/unknown/release/none"
WASI_CLANGXX="$HOME/bin/wasi-sdk/bin/clang++"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <input.ts> [-o <output.wasm>]"
    exit 1
fi

INPUT_TS="$1"
shift
BASE_NAME=$(basename "$INPUT_TS" .ts)
OUTPUT_WASM="${BASE_NAME}.wasm"

while getopts "o:" opt; do
    case "$opt" in
        o) OUTPUT_WASM="$OPTARG" ;;
        *) echo "Usage: $0 <input.ts> [-o <output.wasm>]"; exit 1 ;;
    esac
done

TMP_OBJ=$(mktemp /tmp/ts2wasi_XXXXXX.o)
trap 'rm -f "$TMP_OBJ"' EXIT

# 1. Emit optimized WebAssembly object file
tslang "$INPUT_TS" \
  --emit=obj \
  --opt \
  -mtriple=wasm32-unknown-unknown \
  -mm=none \
  -o "$TMP_OBJ"

# 2. Link against wasi-libc, wasi_core.cpp, and TypeScriptDefaultLib.a
"$WASI_CLANGXX" --target=wasm32-wasip1 \
  -fwasm-exceptions \
  "$TMP_OBJ" \
  "$PWD/wasi_core.cpp" \
  -L"$TS_DEFAULT_WASM_LIB_DIR" \
  -lTypeScriptDefaultLib \
  -lunwind \
  -Wl,--strip-all \
  -o "$OUTPUT_WASM"

echo "Built $OUTPUT_WASM ($(du -h "$OUTPUT_WASM" | cut -f1))"
