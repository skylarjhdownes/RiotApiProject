FROM redis
RUN apt-get update && apt-get install -y git && apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get update && apt-get install -y nodejs
RUN git clone https://github.com/skylarjhdownes/RiotApiProject.git /riotApp


EXPOSE 4000

CMD ["node", "/riotApp/server.js"]
