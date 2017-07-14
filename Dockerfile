FROM python:2
LABEL maintainer "nshadov <ns@ravencloud.net>"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl wget

RUN apt-get autoremove --purge -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install pip --upgrade
RUN pip install -U oletools pdfparse pypdfparse
RUN pip install yara

RUN useradd -m malware && \
  adduser malware sudo && \
  echo "malware:malware" | chpasswd

WORKDIR /home/malware
USER malware
ENV HOME /home/malware

CMD [ "/bin/bash" ]
