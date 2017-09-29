# ref
https://github.com/dockerimages/docker-systemd

# build


docker build -t my_ubuntu_systemd:15.10 .


# run

docker run -d --name=temp-ubuntu-systemd --privileged=true my_ubuntu_systemd:15.10 /lib/systemd/systemd systemd.unit=emergency.service
docker run -it --privileged=true -v /sys/fs/cgroup:/sys/fs/cgroup:ro my_ubuntu_systemd:15.10 /lib/systemd/systemd systemd.unit=emergency.service


