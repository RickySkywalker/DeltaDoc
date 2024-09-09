# Running code-server using sbatch on Delta and DeltaAI

This folder contains scripts that helps you run code-server on Delta and DeltaAI using ```sbatch``` command. 
**Note you should use this script as much as you can, since ```srun``` in ```DeltaDoc/code-server_scripts``` costs more**

## Basic setting
Set the notification e-mail in ```run_code_server.sh```. If you are using Delta, set ```partition``` to ```gpuA40x4``` or ```gpuA100x4```, if you are using DeltaAI, set it to ```ghx4```. You can also change other basic settings in ```run_code_server.sh```. The port and working directory of the code-server can be changed to ```activate_code-server.sh```.

## Running code-server on remote host
To run the code server on Delta or DeltaAI using the following script 
```bash
bash run_code_server.sh
```
It will automatically create a ```./log/``` folder in the current directory to save all the log, when the code-server is running correctly, the log file should look like
```bash
reconnect ip address is: 172.28.80.104
[2024-09-07T17:24:08.845Z] info  code-server 4.92.2 de65bfc9477f61bc22d0b1a23085d1f18bb25202
[2024-09-07T17:24:08.846Z] info  Using user-data-dir /u/rwang18/.local/share/code-server
[2024-09-07T17:24:08.860Z] info  Using config file /u/rwang18/.config/code-server/config.yaml
[2024-09-07T17:24:08.860Z] info  HTTP server listening on http://172.28.80.104:1453/
[2024-09-07T17:24:08.860Z] info    - Authentication is enabled
[2024-09-07T17:24:08.860Z] info      - Using password from /u/rwang18/.config/code-server/config.yaml
[2024-09-07T17:24:08.860Z] info    - Not serving HTTPS
[2024-09-07T17:24:08.860Z] info  Session server listening on /u/rwang18/.local/share/code-server/code-server-ipc.sock
[12:24:47]
```

After the code-server is correctly running on a remote site, you can use the code-server by connecting it from your own computer. You should check the ip address of code-server in the file reconnect_ip.txt created by the scripts (assume it is 172.02.06.260 for our example and assume we use port 8080). Run the following script on your own computer:
```
ssh -L 8080:172.28.80.104:8080 <your NCSA Account>@dtai-login.delta.ncsa.illinois.edu
```
Subsequently, you can use the code-server on your own computer by typing localhost:8080 on your own browser.
