FROM httpd:2.4-alpine

# Jenkins checks out sample-site into ./site
COPY site/ /usr/local/apache2/htdocs/

EXPOSE 80
