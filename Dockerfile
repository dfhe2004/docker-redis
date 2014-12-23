FROM debian:wheezy
MAINTAINER somebody@somewhere.com   # just test

RUN echo "deb http://http.us.debian.org/debian unstable main contrib non-free" > /etc/apt/sources.list.d/unstable.list \
 && apt-get update \
 && apt-get install -y redis-server \
 && rm -rf /var/lib/apt/lists/* # 20141223

RUN sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf \
 && sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf \
 && sed 's/^# maxmemory /maxmemory 1024mb /' -i /etc/redis/redis.conf \
 && sed 's/^# maxmemory-policy /maxmemory-policy /' -i /etc/redis/redis.conf \
 && sed 's/^notify-keyspace-events "" /notify-keyspace-events Ex /' -i /etc/redis/redis.conf \
 && sed '/^logfile/d' -i /etc/redis/redis.conf

ADD start /start
RUN chmod 755 /start

EXPOSE 6379

VOLUME ["/var/lib/redis"]
VOLUME ["/run/redis"]
CMD ["/start"]
