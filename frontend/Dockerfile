FROM python:3.8-slim-buster

WORKDIR /app
COPY . .
RUN pip install requests
ENV FLASK_APP /app/main.py
RUN pip3 install -r requirements.txt

CMD [ "python", "-m" , "flask", "run", "--host=0.0.0.0"]