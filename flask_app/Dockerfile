FROM milenmit/testmailapp-flaskapp:latest

# Set the working directory in the container
WORKDIR /opt/app

# Copy the current directory contents into the container at /opt/app
RUN mkdir -p templates
COPY templates/index.html /opt/app
COPY requirements.txt /opt/app/
COPY app.py /opt/app/

#Install python libs/dependencies
RUN  pip install --no-cache-dir -r requirements.txt

# Command to start the Flask app
CMD ["python3", "app.py"]
