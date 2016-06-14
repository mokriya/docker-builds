FROM debian:debversion
MAINTAINER Aryeh Leib Taurog "python@aryehleib.com"

ADD aptinstall /bin/
RUN /bin/aptinstall \
    libncurses5 libncursesw5 libreadline6 \
    libdb5.3 libgdbm3 libsqlite3-0 libssl1.0.0 \
    libbz2-1.0 libexpat1 liblzma5 zlib1g
