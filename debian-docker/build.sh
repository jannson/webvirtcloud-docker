#!/bin/bash

#docker buildx build --platform linux/amd64 -t linkease/webvirtcloud:0.8.1 .
#docker buildx build --platform linux/amd64 -t linkease/webvirtcloud:0.8.5 -f DockerfileTest .
#docker buildx build --platform linux/amd64 -t linkease/webvirtcloud:latest -f DockerfileTest .

docker build -t linkease/webvirtcloud:0.8.6 -f DockerfileTest .

