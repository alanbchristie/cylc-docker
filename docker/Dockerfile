# The MIT License (MIT)
# 
# Copyright (c) 2016 Bruno P. Kinoshita
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM ubuntu:18.04

ARG cylc_docker_owner=alanbchristie
ARG cylc_docker_v=7.8.0

LABEL maintainer=${cylc_docker_owner}
LABEL version=${cylc_docker_v}

# A docker container with cylc installed based on Bruno P. Kinoshita work.
# With additional contributions from Alan Christie (alanbchritie): -
# - Non-root container user
# - Use of Ubuntu 18.04
# - Installation of sudo and at/atd

RUN apt-get -y update && \
	apt-get -y upgrade

# Set the timezone.
# First encountered for imagemagick installtion
RUN apt-get -y install tzdata
RUN echo "UTC" | tee /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install dependent packages
# TeX is big and you're likely to get 'no space left on device'
# so this package has ben left out for now.
RUN apt-get -y install \
        git \
        python python-dev python-pip \
        pkg-config \
        graphviz graphviz-dev libgraphviz-dev \
        sqlite \
        python-gtk2-dev \
        python-pygraphviz \
        imagemagick php-imagick \
        at \
        sudo \
        systemd \
        vim

WORKDIR /opt
RUN git clone https://github.com/cylc/cylc.git && \
    cd cylc && \
    git checkout tags/${cylc_docker_v} 2> /dev/null

# Containers should NOT run as root
# (as good practice)
# And add the user to the daemon group (so it can run daemons like atd)
# and the sudo group
ENV USER_NAME cylc
ENV USER_ROOT /home/${USER_NAME}
ENV USER_ID 6000
RUN useradd --shell /bin/bash --uid ${USER_ID} --gid root --home-dir ${USER_ROOT} ${USER_NAME} && \
    usermod -a -G daemon ${USER_NAME} && \
    usermod -a -G sudo ${USER_NAME}

WORKDIR ${USER_ROOT}
COPY requirements.txt ${USER_ROOT}/
COPY docker-entrypoint.sh ${USER_ROOT}/
# Copy the examples in
COPY examples examples/

# Install the Python stuff we need
RUN pip install -r requirements.txt

# SSH Dir
RUN mkdir ${USER_ROOT}/.ssh

# Change ownerships...
# and permissions, sudoers etc...
RUN chown -R ${USER_NAME} ${USER_ROOT} && \
    chown -R ${USER_NAME} /tmp && \
    chown -R ${USER_NAME} /opt/cylc && \
    chmod +x docker-entrypoint.sh && \
    chmod 0700 ${USER_ROOT}/.ssh && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME}

# All delicate stuff done
# we can now switch to our non-root user...
USER ${USER_ID}

ENV PATH="/opt/cylc/bin:${PATH}"
ENV HOME ${USER_ROOT}
ENV PYTHONHTTPSVERIFY 0
ENV PYTHONWARNINGS ignore
ENV PATH="/opt/cylc/bin:${PATH}"
RUN cylc check-software 2> /dev/null && \
	cylc version

CMD ./docker-entrypoint.sh
