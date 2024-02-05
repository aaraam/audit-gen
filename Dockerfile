FROM ubuntu:18.04

WORKDIR /usr/src/app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common *
    
RUN apt-get install -y curl
    
RUN apt-get install -y nodejs npm

RUN echo "tzdata tzdata/Areas select America" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/America select New_York" | debconf-set-selections

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update -y 

RUN apt-get install python3.9 -y 

RUN apt-get install -y pip 
RUN pip3 install --upgrade pip && pip3 install solc-select && pip3 install mythril && pip3 install slither

COPY package*.json ./
RUN npm install

COPY . .

CMD ["npm", "start"]