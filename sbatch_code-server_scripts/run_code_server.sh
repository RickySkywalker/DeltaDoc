#!/bin/bash

partition=ghx4
gpus_per_node=1
cpus_per_task=16
mem='64G'
time_s='1:00:00'
port=8080
jobname="code-server-${port}"
# jobname="jupyter-notebook"
email=youremail

# Work dir for code-server
work_dir=~/

usage() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -p ghx4|gpuA40x4|gpuA100x4    Partition to use, ghx4 is for DeltaAI, othber is for Delta"
    echo "  -g 1|2|4    Number of GPUs per node"
    echo "  -c 16|24    Number of CPU cores per task"
    echo "  -m 64g|128g Memory allocation"
    echo "  -r discrete-flowmatching jupyter project subdirectory"
    echo "  -t 08:00:00|24:00:00|48:00:00   Time duration hh:mm:ss (48 hour limit)"
    echo "  -h    Display this help message and exit"
    echo
    exit 1
}


# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
     -p|--partition) partition="$2"; shift 2;;
     -g|--gpus) gpus_per_node="$2"; shift 2;;
     -c|--cpus) cpus_per_task="$2"; shift 2;;
     -m|--mem) mem="$2"; shift 2;;
     -r|--repo) repo="$2"; shift 2;;
     -t|--time) time_s="$2"; shift 2;;
     -h|--help) usage ;;
     *) echo "Unknown option: $1"; usage ;;
  esac
done


# set account
hostname=$(hostname)
if [[ "$hostname" == *"gh"* ]]; then
    account="bckr-dtai-gh"
else
    account="bckr-delta-gpu"
fi

# Create a temporary SLURM scrpt with arguments

temp_sbatch_script=./temp_sbatch_script.sh

cat << EOT > ${temp_sbatch_script}
#!/bin/bash
#SBATCH --account=${account}
#SBATCH --job-name=${jobname}
#SBATCH --output=./logs/${jobname}.log
#SBATCH --partition=${partition}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=${gpus_per_node}
#SBATCH --gpu-bind=none 
#SBATCH --cpus-per-task=${cpus_per_task}
#SBATCH --mem=${mem}
#SBATCH --time=${time_s}
#SBATCH --mail-type=ALL
#SBATCH --mail-user=${email}


bash activate_code-server.sh -p ${port} -w ${work_dir}

EOT


# display submit and remove
echo === begin sbatch script ===
cat ${temp_sbatch_script}
echo === end sbatch script ===
sbatch ${temp_sbatch_script}
# /bin/rm ${temp_sbatch_script}

echo on
sleep 2


# Display the job status
squeue -u $USER

# # ssh_tunnel_delta gpuxxx reported below

# grep -a token logs/jupyter-notebook.log |grep gpu |sed 's/.*http...//' |sed 's/.delta.*//g'

# # copy-paste http://127.0.0.1:9033* on vscode choose this as server
# grep -a http://127.0.0.1:9033 logs/jupyter-notebook.log
