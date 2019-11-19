FROM docker.elastic.co/logstash/logstash:7.1.1

EXPOSE 9910

COPY logstash.conf /usr/share/logstash/config/logstash.conf
RUN echo > /usr/share/logstash/config/logstash.yml

CMD ["/usr/share/logstash/bin/logstash", "-f", "/usr/share/logstash/config/logstash.conf"]