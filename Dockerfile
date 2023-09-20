FROM  envoyproxy/envoy:dev-f39403afa681dfa4510b91b6e45e2b37e348bd1a

RUN apt update &&\
    apt install -y python3 git
RUN mkdir -p /opt &&\
    git clone -n https://github.com/envoyproxy/envoy.git /opt/envoy && \
    cd /opt/envoy &&\
    git checkout 3f1115d30ddb5613c0e937c846f0bf7f331768df restarter/hot-restarter.py && \
    chmod +x /opt/envoy/restarter/hot-restarter.py

COPY ./entrypoint.sh /entrypoint.sh
COPY ./start-script.sh /start-script.sh
RUN chmod +x /entrypoint.sh /start-script.sh

ENTRYPOINT ["/entrypoint.sh"]
