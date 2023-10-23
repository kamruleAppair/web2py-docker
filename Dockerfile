# Use an official Python runtime as a parent image
FROM python:3.8

# Install necessary packages
RUN apt-get update && apt-get install -y git openssl

# Set the working directory to /web2py
WORKDIR /web2py

# Clone the web2py source code from GitHub and initialize submodules
RUN git clone https://github.com/web2py/web2py.git /web2py && \
    cd /web2py && git submodule update --init --recursive

# Generate a self-signed SSL certificate for HTTPS
RUN openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj '/CN=localhost'

# Expose the port for HTTP
EXPOSE 8000

# Start web2py using the built-in web server
CMD python web2py.py -a '12345' -i 0.0.0.0 -p 8000 -k key.pem -c cert.pem

