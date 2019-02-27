FROM phusion/baseimage:0.11
LABEL maintainer="rich@justcompile.it"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

WORKDIR /code

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
ENV PYTHONDONTWRITEBYTECODE true
ENV DEBIAN_FRONTEND=noninteractive

# Install base system libraries.
COPY base_dependencies.txt /code/base_dependencies.txt
COPY installer.sh /code/installer.sh

ONBUILD COPY pyenv-versions.txt /code/pyenv-versions.txt

RUN apt-get update && \
    apt-get install -y $(cat /code/base_dependencies.txt) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    git clone https://github.com/yyuu/pyenv.git /root/.pyenv && \
    cd /root/.pyenv && \
    git checkout `git describe --abbrev=0 --tags` && \
    bash /code/installer.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    # pyenv install && \
    # pyenv global $(cat .python-version)

ONBUILD RUN bash /code/installer.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
