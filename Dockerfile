FROM ubuntu:22.04


ADD files/setup.sh /tmp/
RUN chmod +x /tmp/setup.sh && /tmp/setup.sh

ADD files/build_base.sh /tmp/
ADD files/build_openssl.sh /tmp/
RUN chmod +x /tmp/build_base.sh /tmp/build_openssl.sh && /tmp/build_openssl.sh

ADD files/build.sh /tmp/
RUN chmod +x /tmp/build.sh

ENTRYPOINT ["/tmp/build.sh"]
