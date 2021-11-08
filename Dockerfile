FROM httpd:2.4
WORKDIR /usr/local/apache2/htdocs
COPY index.html .
COPY number.png .
COPY i.jpeg .
EXPOSE 8080
