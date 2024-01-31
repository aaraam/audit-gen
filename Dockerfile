FROM ubuntu:18.04

WORKDIR /usr/src/app

RUN apt get update && apt-get install software-properties-common -y && add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install python3.9 -y && apt-get install python3-pip -y

COPY package*.json ./
RUN npm install

COPY . .