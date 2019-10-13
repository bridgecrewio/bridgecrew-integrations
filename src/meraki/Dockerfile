FROM docker.elastic.co/logstash/logstash:7.1.1

COPY logstash.conf /usr/share/logstash/config/logstash.conf
COPY patterns.d /usr/share/logstash/config/patterns.d

RUN echo > /usr/share/logstash/config/logstash.yml

CMD ["/usr/share/logstash/bin/logstash", "-f", "/usr/share/logstash/config/logstash.conf"]