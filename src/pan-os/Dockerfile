FROM docker.elastic.co/beats/filebeat:7.4.0
USER root
RUN filebeat modules enable panw

COPY ./filebeat.yml /usr/share/filebeat/filebeat.yml

RUN chown root:filebeat /usr/share/filebeat/filebeat.yml
USER filebeat
