FROM datadog/agent:latest

# RUN apt update && \
#     apt install -y libbpfcc && \
#     apt clean

RUN DEBIAN_FRONTEND=noninteractive apt update
RUN rm /etc/ssl/openssl.cnf  # If the `DEBIAN_FRONTEND=noninteractive` parameter wasn’t broken, the hack of this line could be removed
RUN DEBIAN_FRONTEND=noninteractive apt install -y git cmake g++ llvm libelf-dev libclang-dev bison flex
RUN git clone --depth=1 https://github.com/iovisor/bcc.git /usr/src/bcc
RUN mkdir /usr/src/bcc/build && \
        cd /usr/src/bcc/build && \
        cmake .. && \
        make -j $(nproc) && \
        make install

RUN /opt/datadog-agent/embedded/bin/pip install requests-unixsocket
