##!/usr/bin/env bash
#
## ========= Required Env Vars =========
## HF_TOKEN
## HF_HUB_CACHE
## MODEL
## PORT
## TP
## CONC
## MAX_MODEL_LEN
#

cat > config.yaml << EOF
compilation-config: '{"cudagraph_mode": "FULL_AND_PIECEWISE"}'
cuda-graph-sizes: 8192
EOF

sleep 5
cat config.yaml

export VLLM_USE_AITER_UNIFIED_ATTENTION=1
export VLLM_ROCM_USE_AITER_MHA=0
export VLLM_ROCM_USE_AITER_FUSED_MOE_A16W4=1
#amd/gpt-oss120b-w-mxfp4-a-fp8
#export VLLM_ROCM_USE_AITER_FUSED_MOE_A16W4=0

set -x
vllm serve $MODEL --port $PORT \
--tensor-parallel-size=$TP \
--gpu-memory-utilization 0.95 \
--max-model-len $MAX_MODEL_LEN \
--max-seq-len-to-capture $MAX_MODEL_LEN \
--config config.yaml \
--block-size=64 \
--no-enable-prefix-caching \
--disable-log-requests \
--async-scheduling
