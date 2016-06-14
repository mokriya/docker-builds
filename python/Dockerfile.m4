FROM altaurog/debbase:debversion
MAINTAINER Aryeh Leib Taurog "python@aryehleib.com"

ADD pythondeb /tmp/
RUN dpkg -i /tmp/pythondeb && rm /tmp/pythondeb
RUN pyvenv /venv
ENV PATH /venv/bin:$PATH
RUN /venv/bin/pip install --upgrade pip
