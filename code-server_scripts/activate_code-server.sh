#!/bin/bash

# Script to star a code-server from interactive shell with GPU
# Start of the interactive shell can use the following command in the login node
# srun --account=bckr-dtai-gh --partition=ghx4-interactive   --nodes=1 --gpus-per-node=4 --tasks=1 --tasks-per-node=1   --cpus-per-task=16 --mem=128g --time=3:00:00   --pty bash

local_ip_addr=$(hostname -i | awk '{print $1}')
echo $local_ip_addr > reconnect_ip.txt
echo "reconnect ip address is: ${local_ip_addr}"

code-server --bind-addr $local_ip_addr:1453 ~/nvme/TheoremLlama-NG/
