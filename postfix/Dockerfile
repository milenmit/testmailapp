# Use an official Python runtime as a parent image
FROM milenmit/testmailapp-postfix:latest

# Set the working directory in the container
WORKDIR /opt/app

# Copy the files into the container at /opt/app
COPY email_processor.py /opt/app
COPY init_postfix.sh /opt/app
COPY requirements.txt /opt/app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /var/log/postfix && \
    chown -R nobody:nobody /var/log/postfix && \
    chmod +x /opt/app/email_processor.py
   

# Make sure your scripts are executable
RUN chmod +x /opt/app/email_processor.py #\
    && chmod +x /opt/app/init_postfix.sh

# Set the entrypoint script to update configurations and start Postfix
ENTRYPOINT ["/opt/app/init_postfix.sh"]

# Command to start Postfix in foreground mode
CMD ["postfix", "start-fg"]
