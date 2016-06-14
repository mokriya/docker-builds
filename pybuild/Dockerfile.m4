FROM altaurog/debbase:debversion
MAINTAINER Aryeh Leib Taurog "python@aryehleib.com"

RUN /bin/aptinstall build-essential \
    libncurses5-dev libncursesw5-dev libreadline6-dev \
    libdb-dev libgdbm-dev libsqlite3-dev libssl-dev \
    libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev \
    checkinstall wget

ADD buildpython /bin/
ENTRYPOINT ["/bin/buildpython"]
