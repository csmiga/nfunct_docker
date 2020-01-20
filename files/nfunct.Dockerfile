FROM %%from_repository%%:%%from_tag%%

MAINTAINER %%author%%

LABEL tag="%%tag%%"
LABEL build="%%build%%"
LABEL description="%%description%%"

################################################################################
# SET ENVIRONMENT VARIABLES
# It is better to use ARG during the build process since this only sets the
# environment during build time (See moby/moby#4032).
ARG DEBIAN_FRONTEND=noninteractive
#ENV HOME /home/nfunct
ENV LANG C.UTF-8
ENV TERM xterm-256color

################################################################################
# USING A SINGLE DOCKER "RUN" COMMAND REDUCES LAYERS
RUN set +xe \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: WRITING CONTAINER RELEASE INFORMATION TO /etc/container-release" \
    && echo "################################################################################" \
    && echo "Tag: %%tag%%" > /etc/container-release \
    && echo "Build: %%build%%" >> /etc/container-release \
    && echo "Description: %%description%%" >> /etc/container-release \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: UPDATING PACKAGE LIST" \
    && echo "################################################################################" \
    && apt-get update --yes --fix-missing \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: UPGRADING CURRENT SOFTWARE PACKAGES" \
    && echo "################################################################################" \
    && apt-get upgrade --yes --no-install-recommends \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: INSTALLING APT-UTILS PACKAGE" \
    && echo "INFO: REMEDY FOR THE FOLLOWING 'debconf' MESSAGE" \
    && echo "INFO: debconf: delaying package configuration, since apt-utils is not installed" \
    && echo "################################################################################" \
    && apt-get install --yes --no-install-recommends \
        apt-utils \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: INSTALLING ADDITIONAL SOFTWARE PACKAGES" \
    && echo "################################################################################" \
    && apt-get install --yes --no-install-recommends \
        bash \
        ca-certificates \
        cpustat \
        ctop \
        curl \
        dnsutils \
        g++ \
        git \
        htop \
        ifstat \
        iftop \
        itop \
        libzmq3-dev \
        libzmq5 \
        net-tools \
        openssh-client \
        openssl \
        python3 \
        python3-pip \
        sntop \
        tcpdump \
        virtualenv \
        vim \
    && apt-get autoremove \
    && apt-get purge \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: INSTALLING PYTHON VIRTUAL ENVIRONMENT" \
    && echo "################################################################################" \
    && virtualenv --python=/usr/bin/python3 /opt/venv \
    && . /opt/venv/bin/activate \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: INSTALLING PYTHON PACKAGES" \
    && echo "################################################################################" \
    && pip install \
        cryptography==2.8  \
        idna==2.8 \
        ipaddress==1.0.23 \
        locustio==0.12.2 \
        ndg-httpsclient==0.4.2 \
        paramiko==2.6.0 \
        pyasn1==0.4.7 \
        pycparser==2.19 \
        pyOpenSSL==19.0.0 \
        setuptools==41.5.1 \
        sshtunnel==0.1.5 \
    && echo "" \
    && echo "################################################################################" \
    && echo "INFO: CREATING NEW USER" \
    && echo "################################################################################" \
    && useradd --create-home --shell /bin/bash nfunct

USER nfunct

EXPOSE 8089 5557 5558
