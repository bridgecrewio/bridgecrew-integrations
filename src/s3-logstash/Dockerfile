FROM docker.elastic.co/logstash/logstash:7.4.2

USER logstash
COPY logstash.conf /usr/share/logstash/config/logstash.conf
RUN echo > /usr/share/logstash/config/logstash.yml


CMD ["/usr/share/logstash/bin/logstash", "-f", "/usr/share/logstash/config/logstash.conf"]