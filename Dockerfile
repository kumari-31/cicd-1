FROM python:3
RUN pip install django

COPY . .

RUN rm -f db.sqlite3

RUN python manage.py migrate
EXPOSE 8000
CMD ["python","manage.py","runserver","0.0.0.0:8000"]


