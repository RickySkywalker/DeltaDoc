#!/bin/bash

# Script that activate a code-server from login-node
# it nohup runs a interactive shell that can still be vaild after the ssh disconnect (hope so)

ACCOUNT="bckr-dtai-gh"
PARTITION="ghx4-interactive"
NODES="1"
GPUS_PER_NODE="1"
TASKS="1"
TASKS_PER_NODE="1"
CPUS_PER_TASK="64"
MEMORY="128g"
TIME="1:00:00"

nohup srun --account=$ACCOUNT --partition=$PARTITION --nodes=$NODES --gpus-per-node=$GPUS_PER_NODE --tasks=$TASKS --tasks-per-node=$TASKS_PER_NODE --cpus-per-task=$CPUS_PER_TASK --mem=$MEMORY --time=$TIME   --pty bash activate_code-server.sh &
