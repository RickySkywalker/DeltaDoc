# DeltaDoc
This is the DeltaAI server setup guide

**Address for Delta AI login: dtai-login.delta.ncsa.illinois.edu**

## File system
We are in the group ```bckr```, so every folder, we should find the ```bckr``` to look for the folder we are in
|File system | Path | Quota | Remarks |
|----|----|----|---|
| HOME | ```/u/your_id``` | **90GB** | Your home dir, most of envs should be in it |
| PROJECTS | ```/projects/bdjz/your_id``` | **500GB** | most of codes and checkpoints in it |
| WORK-HDD | ```/work/hdd/bdjz/your_id``` | **(by official doc) 1000GB (in real 100GB)** | Can be increased to 100T at most by request |
| ```/tmp``` | ```/tmp``` | **~4T** | If there is a large amount of tmp files, set the tmp folder to here, after each process, it will be deleted |
| ```/work/nvme/bdjz``` | **10T** | This is a large folder that


## Running jobs using DeltaAI
We recommend installing the environment in the home folder, use ```wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh``` to get the miniconda3. Then run ```bash Miniconda3-latest-Linux-aarch64.sh``` to install miniconda3. 

### Running in the interactive shell
```bash
srun --account=bckr-dtai-gh --partition=ghx4-interactive   --nodes=1 --gpus-per-node=4 --tasks=1 --tasks-per-node=1   --cpus-per-task=16 --mem=128g --time=3:00:00   --pty bash
```

### Run your code in the interactive shell in NGC container

Firstly, activate your env through ```conda activate xxx```

Then, execute the program in the NGC container
```bash
singularity exec -B /projects:/projects -B /work/nvme:/work/nvme /sw/user/NGC_containers/pytorch_24.07-py3.sif python main.py
```
The ```-B``` means we mount the ```/projects``` directory (where most of the files and model ckpts belongs) to the working directory of the container. Otherwise, the container cannot read anything in the directory

### Run Code-server on vllm
You can also achieves interactive development of your code on GPUs by installing code-server for DeltaAI following [https://github.com/RickySkywalker/DeltaDoc/blob/main/Code-server-doc.md](https://github.com/RickySkywalker/DeltaDoc/blob/main/Code-server-doc.md)

## Setup envs

### Run your Python code in DeltaAI torch-cuda version of python

The DeltaAI provided its own version of PyTorch that can interact correctly with GPUs. You can use it through below commands
```bash
module load python/miniforge3_pytorch
python main.py
```

### Setup vllm on DeltaAI
Since DeltaAI uses some strange settings of CPU and GPUs, it is hard for the server to install vllm, you should follow the below steps to install. Thanks to [Jiarui Yao](https://maxwelljryao.github.io/) for providing major parts of this section.

#### Allocate one GPU from DeltaAI
Start a job with at least one GPU in DeltaAI
1. Note the memory should be **512g**, as 128g will encounter an OOM error when building `flash-attn` from the source.
2. The network speed on delta AI is much slower than delta, so one could first download files to the path `/work/nvme`, then move them to the destination like `$HOME` on delta AI.
3. Please make sure that you allocate at least **6 hours** to finish all the installs.

#### Update `cmake` version

```bash
# check available cmake modules
module avail 

module load cmake/3.30.2
cmake --version
# cmake version 3.30.2
```

#### Install torch
```bash
pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cu124
```

We recommend you to check whether torch can use GPU by running `torch.cuda.is_avaliable()` in the Python interactive mode. If not, we recommend you directly copy (yep!) the DeltaAI provided envs to your conda envs folder by running:
```bash
cp -r /sw/user/python/miniforge3-pytorch-2.5.0> ~/miniconda3/envs
```

#### Install `bitsandbytes` from source

```bash
git clone https://github.com/bitsandbytes-foundation/bitsandbytes.git && cd bitsandbytes/

# update gcc, cuda version
module load gcc/11.4.0
module load cuda/12.4.0

# or one could add the following into ~/.bashrc
alias gcc='gcc-12'
alias g++='g++-12'
export CC=gcc-12
export CXX=g++-12
export BNB_CUDA_VERSION=124

source ~/.bashrc

echo $CUDA_HOME
# /sw/user/cudatoolkits/installs/cuda-12.4.0

cmake -DCOMPUTE_BACKEND=cuda -S .
make
pip install -e .   # `-e` for "editable" install, when developing BNB (otherwise leave that out)

# fix a bug in bnb
# modify bitsandbytes/bitsandbytes/cuda_specs.py line 26 to below
# return list(map(int, torch.version.cuda.split(".")[0:2]))
```

#### Install `flash-attn` from source
**Note: This step may be VERY SLOW, cost you as much as 4 hours is possible!!!**
```bash
git clone https://github.com/Dao-AILab/flash-attention.git
cd flash-attention
CXX=g++-12 CC=gcc-12 LD=g++-12 MAX_JOBS=16 python setup.py install
```

#### Install `triton` from source
```bash
conda install -c conda-forge libstdcxx-ng=12
git clone https://github.com/triton-lang/triton.git
cd triton/python
python setup.py install
```

You may encounter the following error:

```bash
(torch_env_module_1) rwang18@gh025:~/nvme/triton/python> conda install -c conda-forge libstdcxx-ng=12
Error while loading conda entry point: conda-libmamba-solver (No module named 'libmambapy.bindings')
Error while loading conda entry point: conda-libmamba-solver (No module named 'libmambapy.bindings')
/u/rwang18/nvme/Miniconda_DeltaAI/miniconda3/envs/torch_env_module_1/lib/python3.10/site-packages/conda_package_streaming/package_streaming.py:25: UserWarning: zstandard could not be imported. Running without .conda support.
  warnings.warn("zstandard could not be imported. Running without .conda support.")
/u/rwang18/nvme/Miniconda_DeltaAI/miniconda3/envs/torch_env_module_1/lib/python3.10/site-packages/conda_package_handling/api.py:29: UserWarning: Install zstandard Python bindings for .conda support
  _warnings.warn("Install zstandard Python bindings for .conda support")

CondaValueError: You have chosen a non-default solver backend (libmamba) but it was not recognized. Choose one of: classic
```

Try to solve it by running the following:

```bash
conda config --set solver classic
conda install -c conda-forge libstdcxx-ng=12
# ... rest are the same
```

#### Install `vllm`

**In this step, you may face OOM problem. If you have already increased the memory to 512 and the problem still exists. It may be you have allocated too many CPUs, change`\#SBATCH --cpus-per-task=64` to solve the problem**

```bash
conda install ccache
git clone https://github.com/vllm-project/vllm.git
cd vllm
git checkout v0.7.3
python use_existing_torch.py
pip install -r requirements-build.txt
CCACHE_NOHASHDIR="true" pip install -e . --no-build-isolation
```
