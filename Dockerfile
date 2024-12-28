FROM debian:trixie-slim

#ENV TZ=Europe/Berlin

RUN apt-get update && \
    apt-get install -y --no-install-recommends streamripper && \
    apt-get install -y --no-install-recommends sudo && \
    apt-get install -y --no-install-recommends cron && \
    apt-get install -y --no-install-recommends vim && \
    rm -rf /var/lib/apt/lists/*

RUN touch /var/log/cron.log
RUN chmod 777 /var/log/cron.log

RUN useradd -m -d /home/streamripper streamripper && echo "streamripper:streamripper" | chpasswd -e && adduser streamripper sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER streamripper

COPY --chmod=755 run.sh /run.sh
COPY --chmod=755 cleanstreamripper.sh /cleanstreamripper.sh
RUN mkdir -p /home/streamripper/destination

#RUN (crontab -l 2>/dev/null; echo "*/1 * * * * date >> /home/streamripper/destination/crontest.txt") | crontab -
RUN (crontab -l 2>/dev/null; echo "42 * * * * /cleanstreamripper.sh") | crontab -

# expose relay port
EXPOSE 8000

WORKDIR /home/streamripper
ENTRYPOINT ["/run.sh"]
VOLUME /home/streamripper
