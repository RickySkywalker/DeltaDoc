# Code-server documentation

This is the documentation for code-server on Delta and DeltaAI

## Init code-server on login node
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
