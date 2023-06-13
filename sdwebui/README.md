# Lambda Labs Launch Info

Launch an instance using your cloud instance dashboard.

SSH into machine:

```
ssh -L:7860:localhost:7860 ubuntu@<machine IP>
```

Start a tmux

```
tmux
```

Configure nvidia docker runtime per https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#daemon-configuration-file

```
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Pull and run image

```
sudo docker run --rm -it --init --runtime=nvidia --gpus=all --ipc=host --name sdwebui -p 7860:7860 --volume $PWD:/data symbionconjurer/sdwebui:latest --listen 
```

If you want to run in full precision use this instead:

```
sudo docker run --rm -it --init --runtime=nvidia --gpus=all --ipc=host --name sdwebui -p 7860:7860 --volume $PWD:/data symbionconjurer/sdwebui:latest --listen --no-half --no-half-vae --precision=full
```