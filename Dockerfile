FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends streamripper && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/streamripper streamripper
RUN mkdir /home/streamripper/SST
USER streamripper
WORKDIR /home/streamripper

# expose relay port
EXPOSE 8000

ADD run.sh /run.sh
ADD cleanstreamripper.sh /home/streamripper/cleanstreamripper.sh
ADD zyx.txt /home/streamripper/zyx.txt
ENTRYPOINT ["/run.sh"]
VOLUME /home/streamripper
