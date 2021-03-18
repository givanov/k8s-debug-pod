FROM ubuntu:groovy-20200812

RUN apt update && \
    apt install -y curl wget dnsutils git \ 
    make net-tools postgresql-client mysql-client \
    vim

ENTRYPOINT ["/bin/bash"]
