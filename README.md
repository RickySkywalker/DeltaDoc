# DeltaDoc
This is the Delta server setup guide

**Address for Delta AI login: dtai-login.delta.ncsa.illinois.edu**

## File system
We are in the group ```bckr```, so every folder, we should find the ```bckr``` to look for the folder we are in
|File system | Path | Quota | Remarks |
|----|----|----|---|
| HOME | ```/u/your_id``` | **90GB** | Your home dir, most of envs should be in it |
| PROJECTS | ```/projects/bckr/your_id``` | **500GB** | most of codes and checkpoints in it |
| WORK-HDD | ```/work/hdd/bckr/your_id``` | **(by official doc) 1000GB (in real 100GB)** | Can be increased to 100T at most by request |
| ```/tmp``` | ```/tmp``` | **~4T** | If there is a large amount of tmp files, set the tmp folder to here, after each process, it will be deleted |
| ```/work/nvme/bckr``` | **10T** | This is a large folder that


## Setup Envs
We recommend installing the environment in the home folder, use ```wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh``` to get the miniconda3. Then run ```bash Miniconda3-latest-Linux-aarch64.sh``` to install miniconda3. Set the 



### Running in the interactive shell
```bash
srun --account=bckr-dtai-gh --partition=ghx4-interactive   --nodes=1 --gpus-per-node=4 --tasks=1 --tasks-per-node=1   --cpus-per-task=16 --mem=128g --time=3:00:00   --pty bash
```

### Run your code in the interactive shell in NGC container

Firstly, activate your env through ```conda activate xxx```

Then, execute the program in the NGC container
```bash
singularity exec -B /projects:/projects /sw/user/NGC_containers/pytorch_24.07-py3.sif python main.py
```
The ```-B``` means we mount the ```/projects``` directory (where most of the files and model ckpts belongs) to the working directory of the container. Otherwise, the container cannot read anything in the directory


### Run your Python code in DeltaAI torch-cuda version of python

The DeltaAI provided their own version of PyTorch that can interact correctly with GPUs. You can use it through below commands
```bash
module load python/miniforge3_pytorch
python main.py
```

### Install of Flash-Attention
DeltaAI’s machines are with aarch64 architecture. For flash-attention, users need to compile from source code locally.
```bash
git clone https://github.com/Dao-AILab/flash-attention.git
cd flash-attention
mkdir -p ~/bin
ln -s /usr/bin/gcc-12 ~/bin/c++
ln -s /usr/bin/gcc-12 ~/bin/gcc
export PATH=~/bin:$PATH
# check gcc --version and c++ --version, should be 12.3
srun --account=bckr-dtai-gh --partition=ghx4-interactive   --nodes=1 --gpus-per-node=1 --tasks=1 --tasks-per-node=1   --cpus-per-task=16 --mem=256g --time=00:59:00   --pty bash
MAX_JOBS=16  python setup.py install
```
