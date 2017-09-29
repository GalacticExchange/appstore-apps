FROM zoomdata/quickstart


#RUN /bin/bash -c 'sudo yum install wget && wget http://www.freedesktop.org/software/systemd/systemd-216.tar.xz'
RUN /bin/bash -c 'sudo mkdir -p /opt/gex && sudo mkdir -p /opt/gex/provision && sudo mkdir -p /opt/gex/config'

COPY files/bootstrap /etc
RUN sudo chown -R zoomdata:zoomdata /etc/bootstrap
RUN chmod +x  /etc/bootstrap


# RUN ln /lib/systemd/systemd /etc/bootstrap

WORKDIR /opt/gex/

COPY files/config.json .
COPY files/configure.sh .

#ENTRYPOINT ["/lib/systemd/systemd"]
ENTRYPOINT ["/etc/bootstrap"]
