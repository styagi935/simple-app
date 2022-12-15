#!/bin/bash
sed "s/tagVersion/$1/g" pod.yaml > node-app-pod.yml
