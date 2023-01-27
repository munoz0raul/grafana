# Final stage
FROM grafana/grafana:8.5.3


USER grafana
ENTRYPOINT [ "/run.sh" ]
USER root
RUN apk add --no-cache vim git
USER 1000

COPY public /usr/share/grafana/public

#RUN git clone -b master https://github.com/munoz0raul/grafana.git
COPY grafana.db /var/lib/grafana/grafana.db
COPY grafana.ini /etc/grafana/grafana.ini
COPY foundries.png /usr/share/grafana/public/img/
COPY grafana.png /usr/share/grafana/public/img/ 
COPY nodered.png /usr/share/grafana/public/img/
COPY influxdb.png /usr/share/grafana/public/img/

