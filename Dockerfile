FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends streamripper && \
    apt-get install -y --no-install-recommends sudo && \
    apt-get install -y --no-install-recommends cron && \
    apt-get install -y --no-install-recommends vim && \
    rm -rf /var/lib/apt/lists/*

#USER root
#RUN chown default:root /var/run
#USER default
# Add crontab file
#COPY --chmod=644 crontab /etc/cron.d/crontab
#COPY mycrontabfile /etc/cron.d/mycrontabfile
RUN echo "*/1 * * * * date >> /var/log/cron.log\n" >> /etc/cron.d/mycrontabfile
# Give execution rights on the cron job
RUN chmod 644 /etc/cron.d/mycrontabfile
#RUN crontab mycrontabfile
# Create the log file to be able to run tail
RUN touch /var/log/cron.log
RUN chmod 777 /var/log/cron.log

RUN useradd -m -d /home/streamripper streamripper && echo "streamripper:streamripper" | chpasswd && adduser streamripper sudo
USER streamripper

COPY run.sh /run.sh
COPY cleanstreamripper.sh /cleanstreamripper.sh
#COPY --chmod=0755 cleanstreamripper.sh /home/streamripper/cleanstreamripper.sh
#COPY --chmod=0755 zyx.txt /home/streamripper/zyx.txt
#COPY --chmod=0755 autorequest.sh /autorequest.sh
RUN mkdir -p /home/streamripper/destination

# expose relay port
EXPOSE 8000

WORKDIR /home/streamripper
ENTRYPOINT ["/run.sh"]
VOLUME /home/streamripper
