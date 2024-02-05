FROM ubuntu:18.04

WORKDIR /usr/src/app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common
    
RUN apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - 
    
RUN apt-get install -y nodejs

RUN echo "tzdata tzdata/Areas select America" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/America select New_York" | debconf-set-selections

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update -y 

RUN apt-get install python3.10 -y 

RUN apt-get install -y python3-pip 
RUN pip3 install --upgrade pip && pip3 install solc-select && pip3 install mythril && pip3 install slither

COPY package*.json ./
RUN npm install

COPY . .

CMD ["npm", "start"]