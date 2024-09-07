# Running code-server using scripts
This folder contains all the scripts that help you run code-server on Delta and DeltaAI

## Running code-server on DeltaAI

To run the code-server on DeltaAI, you need to first login into one of the login nodes. After entering the login node, run the following script
```bash
nohup bash activate_code-server_login-node.sh > ./output.log 2> ./output.err &
```
This will start your code-server even if you close your terminal. You can change settings of the home address (currently ```~/``` and port used (current ```8080```) of code-server in ```activate_code-server.sh```. Machine-related settings like ```ACCOUNT```, ```PARTITION```, ```GPUS_PER_NODE``` (should not exceed 4), ```CPUS_PER_TASK```, ```MEMORY```, ```TIME```(should not exceed 48:00:00) in ```activate_code-server_login-node.sh```.

If the code-server runs successfully, ```output.log``` should look like:
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

After the code-server is correctly running on a remote site, you can use the code-server by connecting it from your own computer. You should check the ip address of code-server in the file ```reconnect_ip.txt``` created by the scripts (assume it is ```172.02.06.260``` for our example and assume we use port ```8080```). Run the following script on your own computer:
```bash
ssh -L 8080:172.28.80.104:8080 <your NCSA Account>@dtai-login.delta.ncsa.illinois.edu
```
Subsequently, you can use the code-server on your own computer by typing ```localhost:8080``` on your own browser.
