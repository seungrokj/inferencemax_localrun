#!/bin/bash
TP_CONC=("1:4" "1:8" "1:16" "1:32" "1:64" "1:128" "8:4" "8:8" "8:16" "8:32" "8:64" "8:128")
TP_CONC=("1:4")
export ISL=1024
export OSL=1024
export hf_token=''
for tp_conc in ${TP_CONC[@]}
do
    export TP=$(echo $tp_conc | awk -F':' '{ print $1 }')
    export CONC=$(echo $tp_conc | awk -F':' '{ print $2 }')
    echo config $ISL, $OSL,  $TP, $CONC

    HF_TOKEN=$hf_token \
    HF_HUB_CACHE="/mnt/hf_hub_cache" \
    EXP_NAME='gptoss_1k1k' \
    MODEL='openai/gpt-oss-120b' \
    ISL=$ISL \
    OSL=$OSL \
    MAX_MODEL_LEN=2048 \
    RANDOM_RANGE_RATIO=0.8 \
    IMAGE='rocm/7.0:rocm7.0_ubuntu_22.04_vllm_0.10.1_instinct_20250927_rc1' \
    FRAMEWORK='vllm' \
    PRECISION='fp4' \
    GITHUB_WORKSPACE=$PWD \
    TP=$TP \
    CONC=$CONC \
    ./launch_mi355x-amd.sh
done
