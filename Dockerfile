#Build Ubuntu EDGE image
FROM bioedge/edge-covid19:latest
MAINTAINER chienchi@lanl.gov

ENV EDGE_VER 2.4.0
ENV container docker
ENV EDGE_BUILD "20220404"
ENV EDGE_HOME "/home/edge/edge"
ENV PATH "$EDGE_HOME/bin:$EDGE_HOME/scripts:$EDGE_HOME/thirdParty/Anaconda2/bin:$EDGE_HOME/JBrowse/bin:${PATH}"
ENV PERL5LIB "$EDGE_HOME/lib:$EDGE_HOME/lib/perl5/x86_64-linux-thread-multi:$EDGE_HOME/lib/perl5"

LABEL version="${EDGE_VER}"
LABEL software="EDGE COVID19"
LABEL description="EDGE COVID-19: A Web Platform to generate submission-ready genomes for SARS-CoV-2 sequencing efforts."
LABEL website="https://edge-covid19.edgebioinformatics.org/"
LABEL tags="bioinformatics"
LABEL release-date="${EDGE_BUILD}"


ADD configs /edge_configs
# SystemCtl stop signal

STOPSIGNAL SIGRTMIN+3

# Entry Point and Ports

EXPOSE 80 8080 3306

# Unset proxy if any when build
ENV HTTPS_PROXY ""
ENV HTTP_RPOXY ""
ENV https_proxy ""
ENV http_proxy ""

# workdir

WORKDIR /home/edge

# Systemd needs this VG

VOLUME ["/sys/fs/cgroup"]

# Run Init by default - this starts systemd for us

CMD ["/start.sh"]



