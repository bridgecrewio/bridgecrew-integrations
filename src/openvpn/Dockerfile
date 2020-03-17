FROM docker.elastic.co/logstash/logstash:7.1.1

## DEV ONLY ##
##USER 0
##RUN yum install -y openssh-server; yum clean all
##RUN mkdir /root/.ssh
##RUN touch /root/.ssh/authorized_keys
##RUN chmod 700 /root/.ssh
##RUN chmod 644 /root/.ssh/authorized_keys
##RUN mkdir /var/run/sshd
##
##RUN echo "<My-Public-Key>"  >> /root/.ssh/authorized_keys
##RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
##
##COPY tmp-docker-entrypoint /usr/local/bin/docker-entrypoint
##RUN chmod 0755 /usr/local/bin/docker-entrypoint
##
##RUN sed -i -e 's/error/debug/g' /usr/share/logstash/config/log4j2.properties
###############

EXPOSE 9910/udp
EXPOSE 9910/tcp

COPY logstash.conf /usr/share/logstash/config/logstash.conf

RUN echo > /usr/share/logstash/config/logstash.yml

CMD ["/usr/share/logstash/bin/logstash", "-f", "/usr/share/logstash/config/logstash.conf"]
