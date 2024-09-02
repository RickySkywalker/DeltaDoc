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


### Run your Python code in DeltaAi torch-cuda version of python

```bash
