# Running code-server using sbatch on Delta and DeltaAI

This folder contains scripts that helps you run code-server on Delta and DeltaAI using ```sbatch``` command. 
**Note you should use this script as much as you can, since ```srun``` in ```DeltaDoc/code-server_scripts``` costs more**

## Basic setting
Set the notification e-mail in ```run_code_server.sh```. If you are using Delta, set ```partition``` to ```gpuA40x4``` or ```gpuA100x4```, if you are using DeltaAI, set it to ```ghx4```. You can also change other basic settings in ```run_code_server.sh```. The port and working directory of the code-server can be changed to ```activate_code-server.sh```.
