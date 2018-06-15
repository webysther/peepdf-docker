FROM python:2
LABEL maintainer "Webysther Nunes <webysther@gmail.com>"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y sudo curl wget
RUN apt-get install -y nano vim zsh curl git sudo zip
RUN apt-get install -y ghostscript

RUN apt-get autoremove --purge -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install pip --upgrade
RUN pip install oletools pdfparse pypdfparse peepdf hachoir3 hachoir-core \
				hachoir-metadata hachoir-urwid hachoir-subfile

ADD tools /opt/tools

RUN useradd -m malware && \
  adduser malware sudo && \
  echo "malware:malware" | chpasswd
RUN chsh -s /bin/zsh malware

WORKDIR /home/malware

# Using the version with score
RUN git clone https://github.com/jbremer/peepdf.git && \
	cd peepdf && \
	git checkout gsoc

RUN echo 'score' >> /home/malware/peepdf/score && \
	echo '#!/bin/bash\npython /home/malware/peepdf/peepdf.py -fc -s /home/malware/peepdf/score "$@"' > /usr/bin/score && \
    chmod +x /usr/bin/score

USER malware
ENV HOME /home/malware

CMD [ "/bin/bash" ]
