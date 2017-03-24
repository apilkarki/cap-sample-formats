
FROM nginx:alpine

MAINTAINER Apil Karki <apilkarki@gmial.com>


 #Clone our private GitHub Repository

   #RUN apk —-update add git openssh && \
    #rm -rf /var/lib/apt/lists/* && \
    #rm /var/cache/apk/*

RUN apk update  && \
    apk add --no-cache git openssh


RUN git clone https://github.com/younginnovations/internship-challenges.git /app/
RUN mkdir -p /home/app/ && \
cp -R /app/devops/docker-me/site/*  /home/app/
RUN chown root:root -R /home/app/


# Setup Nginx

#RUN apk update && apk add nginx
#ENV HOME /usr 

RUN mkdir -p /usr/share/nginx/html/site/
RUN chown root:root -R /usr/share/nginx/html/site/

RUN cp -r home/app/*  /usr/share/nginx/html/site/


EXPOSE 9000
CMD ["nginx", "-g", "daemon off;"]

