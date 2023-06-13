# Use a base image with Git and SSH installed
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

# Install junk
RUN apt-get update && apt-get install -y git openssh-client wget 

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y python3-opencv

# Copy the SSH script to the app directory
COPY launch.sh /scripts/launch.sh
RUN chmod +x /scripts/launch.sh

# Automatic1111 won't run as root so we create
# a user to run the app. 
# username: sdwebui
# password: sdwebui
RUN useradd -m -s /bin/bash sdwebui
RUN su sdwebui
RUN echo 'sdwebui:sdwebui' | chpasswd
USER sdwebui

WORKDIR /data

ENTRYPOINT [ "../scripts/launch.sh" ]