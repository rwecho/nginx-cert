FROM nginx:latest
RUN apt update && \
    apt install -y cron\
                   vim\
                   certbot\
                   python3-certbot-nginx

COPY ./etc/crontab/crontab /etc/cron.d/crontab
COPY ./etc/autocert/run.sh /etc/autocert/run.sh
RUN chmod 0644 /etc/cron.d/certbot
RUN chmod 0655 /etc/autocert/run.sh
RUN /usr/bin/crontab /etc/cron.d/crontab

EXPOSE 80
EXPOSE 443

CMD /etc/autocert/run.sh $DOMAINS $EMAIL $COUNTRY && tail -f /dev/null