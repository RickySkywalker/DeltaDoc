# Code-server documentation

This is the documentation for code-server on Delta and DeltaAI.

**Note: you should do all the work on your terminal that is NOT in VS code, VS code terminal may have some problem**

## Running code-server scripts on DeltaAI

There are scripts that can directly help you setup everything on DeltaAI Login nodes, please check [this link](https://github.com/RickySkywalker/DeltaDoc/tree/main/code-server_scripts).

## Start code-server on login node
You can try to firstly init the code-server on login node to test if it works correctly

### Download and install code-server
Download code-server on [code-server-release](https://github.com/coder/code-server/releases). e.g.:
```bash
wget https://github.com/coder/code-server/releases/download/v4.92.2/code-server-4.92.2-linux-arm64.tar.gz
```
note that Delta is x86 (amd64) and DeltaAi is aarch64 (arm64).

It is off-the-shelf. Thus, you can unpack and directly use it. To use code-server add it to ```$PATH```
```bash
export PATH=/path/to/code-server/code-server-4.92.2-linux-arm64/bin:$PATH
```

### Start the code-server

Pick a port you like, start the code-server by
```bash
code-server --bind-addr 127.0.0.1:1453 /home/of/code-server
```
There is a code that you may need to login to code-server, it typically in ```~/.config/code-server/```


## Start code-server on DeltaAI interactive shell

Firstly, start the interactive shell with command
```bash
srun --account=bckr-dtai-gh --partition=ghx4-interactive   --nodes=1 --gpus-per-node=4 --tasks=1 --tasks-per-node=1   --cpus-per-task=16 --mem=128g --time=3:00:00   --pty bash
```
Then, get the home address by typing ```hostname -i```, you may see multiple address, note down any of them for later use e.g.:
```bash
(base) rwang18@gh048:~> hostname -i
172.28.80.255 172.28.80.252 172.28.80.253 172.28.80.254
```
Subsequently, start the code server by:
```bash
code-server --bind-addr <your-picked-addr(a1)>:<your-picked-prot(p1)> /home/of/code-server
```


## Use code-server on your own device
After started the code-server remotely, you can use the code-server on your own computer as long as it can access Delta or DeltaAI. This can be done by bind your computer's port with the remote port by running the following command:

```bash
ssh -L <port-on-your-computer(p2)>:<a1>:<p1> <NCSA-ID>@<login-node-addr>
```

e.g.:
```bash
ssh -L 1453:172.28.80.255:1453 rwang18@gh-login01.delta.ncsa.illinois.edu
```

Then, you can use the code-server on your own browser by typing ```loaclhost:<p2>```.
