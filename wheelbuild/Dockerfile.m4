FROM altaurog/pybuild:debversion
MAINTAINER Aryeh Leib Taurog "python@aryehleib.com"

m4_include(`python/install')
RUN /bin/aptinstall libpq-dev
RUN /venv/bin/pip install wheel

ENTRYPOINT ["/venv/bin/pip"]
