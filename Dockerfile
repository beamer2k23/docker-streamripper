FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends streamripper && \
    apt-get install -y --no-install-recommends cron && \
    rm -rf /var/lib/apt/lists/*

# Add crontab file
COPY --chmod=0644 crontab /etc/cron.d/crontab
# Give execution rights on the cron job
#RUN chmod 0644 /etc/cron.d/crontab
# Create the log file to be able to run tail
RUN touch /var/log/cron.log


#RUN useradd -m -d /home/streamripper streamripper
#USER streamripper
WORKDIR /home/streamripper

# expose relay port
EXPOSE 8000

ADD run.sh /run.sh
ADD cleanstreamripper.sh /cleanstreamripper.sh
COPY cleanstreamripper.sh /home/streamripper/cleanstreamripper.sh
ADD zyx.txt /zyx.txt

ENTRYPOINT ["/run.sh"]
VOLUME /home/streamripper
