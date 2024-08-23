<h2>Test mail applicaton</h2>
<p> Requirements <p>
  docker-compose , valid domain name and opened port 25(SMTP)
<p style="font-size: 1.5em;">This mail app is mostly used for automation test purposes, send an email and check wheter an email is received with correct headers/body and so on.
</p>
<p style="font-size: 1.5em;">Evertyhing is copy/paste from other sources plus chatgpt, feel free to edit whatever you want. <img src="https://html5-editor.net/images/smiley.png" alt="smiley" /></p>

1.Create .env file in main directory.<br>
2. Set credentials in env , do NOT change the name of the db , just host/user/pass and api_key , domain, load_ui in case you want to change the name you need to edit the python scripts> <br>
<p>
DB_HOST=mysql_db (check docker-compose)<br>
DB_USER=user<br>
DB_PASSWORD=pass<br>
MYSQL_ROOT_PASSWORD=rootpass<br>
DB_NAME=emails<br>
DB_CHARSET=utf8mb4<br>
DB_MAX_CONNECTIONS=7 ## default 5<br>
API_KEY=test<br>
LOAD_UI=True/False<br>
DOMAIN=SMTP.EXAMPLE.COM<br>
  <p>
  3. Edit  postfix/conf -> main.cf , transport , virtual and in flask_app/templated index.html (change domain). or if you want other properties.<br
4. Use replece.sh script to edit/change domain in all the needed files - > ./replace.sh (will read DOMAIN from .env file).and change the {{domain}} placeholder in all files (above).<br
5. Install docker/docker-compose or podman(not tested with podman).<br
6. Run docker-compose up -d<br>
    <p>
CONTAINER ID   IMAGE                          COMMAND                  CREATED        STATUS        PORTS                                                  NAMES<br>
96f51d2552f5   docker_postfix     "/usr/bin/supervisor…"   22 hours ago   Up 22 hours   0.0.0.0:25->25/tcp, :::25->25/tcp                      postfix <br>
d6f57b114a94   docker_flask_app   "/usr/bin/supervisor…"   22 hours ago   Up 22 hours   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp              flask_app<br>
1d5d3f2b57ef   mysql:5.7                      "docker-entrypoint.s…"   22 hours ago   Up 22 hours   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql_db<br>
      <p>
7.Send email to anything@domain.com<br>
8.If LOAD_UI=True - open http://domain:5000<br>


![UI](https://github.com/user-attachments/assets/dfe43e47-68a8-492e-8e27-47c588c90b71)

 <p>
9. Check API<br>

 

http://domain:5000/emails?to_email=name@domain.com&api_key=test
<p>
<code>
  {
    "count": 2,
    "limit": 1,
    "offset": 0,
    "emails": [
        {
            "email": {
                "id": 2,
                "received_time": "2024-08-19T14:23:42",
                "subject": "testmail app in docker",
                "from_email": "noreply@anonymousemail.me",
                "from_name": "Anonymousemail",
                "reply_to_email": null,
                "reply_to_name": null,
                "to_email": "test@example.com",
                "to_name": "",
                "cc_email": null,
                "cc_name": null,
                "raw_headers": {
                    "return_path": "<noreply@anonymousemail.me>",
                    "x_original_to": "test@example.com",
"received": [
                        "from s9.inboxpress.eu (s9.inboxpress.eu [5.45.184.142])  by ums.kibik.org (Postfix) with ESMTP id 2AA7FA9A3D2  for <test@ums.kibik.org>; Mon, 19 Aug 2024 14:23>
                        "from authenticated-user (s9.inboxpress.eu [5.45.184.142])  (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)   key-exchange X25519 server-signat>
                    ],
                    "dkim_signature": "v=1; a=rsa-sha256; c=relaxed/simple; d=s9.inboxpress.eu;  s=mail; t=1724077422;  bh=bIIR7euJ8iLyMj0vjeYrFyK037DUj72NB8SxHUxVcEs=;  h=Date:To:From>
                    "date": "Mon, 19 Aug 2024 14:23:42 +0000",
                    "to": "test@ums.kibik.org",
                    "from": "Anonymousemail <noreply@anonymousemail.me>",
                    "subject": "testmail app in docker",
                    "message_id": "<e543dc60e85e17526a72240221f7a878@anonymousemail.me>",
                    "list_unsubscribe": "<https://anonymousemail.me/unsubscribe.php?uid=VVRYejQrYkJVOHdOQzJYSkdvZ05UQ2xFL3ozSFI0VVdxUGI5TWFLTlVzRT0=>",
                    "mime_version": "1.0",
                    "content_type": "multipart/alternative;  boundary=b1=_sgrDGwRqy8bBZWE9O7KVvcN68vqTYBSzJy4rSdH1E",
                    "content_transfer_encoding": "8bit"
                },
                "encoding": "utf-8",
                "created_at": "2024-08-19T14:23:43"
            },
            "parts": [
                {
                    "id": 3,
                    "email_id": 2,
                    "headers": {
                        "content_type": "text/plain; charset=us-ascii"
                    },
                    "content_type": "text/plain",
                    "content": "This is test email"
                },
                {
                    "id": 4,
                    "email_id": 2,
                    "headers": {
                        "content_type": "text/html; charset=us-ascii"
                    },
                    "content_type": "text/html",
                    "content": "<span style=\"color:#c0392b\">Powered by <strong>Anonymousemail</strong>\u00a0\u2192 </span><a href=\"https://anonymousemail.me/premium.php?source=em>"
                }
            ],
            "attachments": []
        }
    ]
}
</code>                     
<p>
API Documentation<p>
Authentication<br>
All endpoints require an api_key parameter to be passed in the URL.

Endpoints

Get Emails<br>
URL: /emails
Method: GET
Parameters:
to_email (required): The email address to filter emails by.
sort (optional): Sort order (ASC or DESC). Default is DESC.
limit (optional): Limit the number of emails returned.
offset (optional): Skip a number of emails.
api_key (required): Your secret API key.
Response:
count: Number of emails that matched the query.
limit: Number of emails returned in this request.
offset: Number of emails skipped.
emails: List of emails.<br>
Example:
curl "http://localhost:5000/emails?to_email=test@example.com&api_key=YourSecretApiKey"

Delete an Email<br>
URL: /emails/<int:email_id>
Method: DELETE
Parameters:
api_key (required): Your secret API key.
Response: Message indicating the success of the operation.<br>
Example:
curl -X DELETE "http://localhost:5000/emails/1?api_key=YourSecretApiKey"

Delete All Emails<br>
URL: /emails
Method: DELETE
Parameters:
api_key (required): Your secret API key.
Response: Message indicating the success of the operation.<br>
Example:
curl -X DELETE "http://localhost:5000/emails?api_key=YourSecretApiKey"

Get Email Stats<br>
URL: /emails/stats
Method: GET
Parameters:
api_key (required): Your secret API key.
Response:
total_email_count: Total number of emails in the database.
database_size_mb: Size of the database in MB.<br>
Example:
curl "http://localhost:5000/emails/stats?api_key=YourSecretApiKey"

Security
To secure the API:

Use a strong, unique API_KEY.
Implement HTTPS to encrypt data between clients and the server.
Restrict access to the API by IP address if possible.

TO DO
Avoid using it on prod, API KEY in URL is far away from best practise , better to be in header. UI has no restrictions also use nginx as reverse proxy for examle but not open port 5000 outside.
