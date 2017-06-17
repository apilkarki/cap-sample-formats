
 #Download base image Alpine linux with Nginx Server

 FROM nginx:alpine

 MAINTAINER <apilkarki@gmail.com>


 #Install Git

 RUN apk update && apk add git openssh

 #Clone the GitHub Repository 

 RUN git clone https://github.com/younginnovations/internship-challenges.git /app/

 RUN mkdir -p /home/app/ && \
     cp -R /app/devops/docker-me/site/*  /home/app/

 RUN chown root:root -R /home/app/


 #Copying contents of Internship-challenges/devops/docker-me/site/ folder to Nginx document root folder

 RUN mkdir -p /usr/share/nginx/html/site/
 RUN chown root:root -R /usr/share/nginx/html/site/
 RUN cp -r home/app/*  /usr/share/nginx/html/site/

 #Expose the ports for Nginx

 EXPOSE 9000
 
 #Execute the server in foreground

 CMD ["nginx", "-g", "daemon off;"]

