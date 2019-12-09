FROM docker.elastic.co/logstash/logstash:7.4.2

USER logstash
COPY logstash.conf /usr/share/logstash/config/logstash.conf
COPY logstash.yml /usr/share/logstash/config/logstash.yml

RUN ["/usr/share/logstash/bin/logstash-plugin", "install", "logstash-output-amazon_es"]
CMD ["/usr/share/logstash/bin/logstash", "-f", "/usr/share/logstash/config/logstash.conf"]