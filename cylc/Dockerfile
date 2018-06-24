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
LABEL maintainer="alanbchritsie"

# A docker container with cylc installed based on Bruno P. Kinoshita work.
# With additional contributions from Alan Christie (alanbchritie): -
# - Non-root container
# - Use of Ubuntu 18.04
# - Move to CYLC 7.7.0
ENV CYLC_V 7.7.0

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
        python-pygraphviz

RUN apt-get -y install \
        imagemagick php-imagick

RUN cd /opt && \
	git clone https://github.com/cylc/cylc.git && \
	cd cylc && \
	git checkout ${CYLC_V} 2> /dev/null

# Useful extra stuff...
RUN apt-get -y install \
        vim

# Containers should NOT run as root
# (as good practice)
ENV USER_ROOT /home/cylc
RUN useradd --shell /bin/bash --user-group --uid 6000 --home-dir ${USER_ROOT} cylc

WORKDIR ${USER_ROOT}
ENV PATH="/opt/cylc/bin:${PATH}"
COPY requirements.txt ${USER_ROOT}/
RUN pip install -r requirements.txt

# Chnage ownership of 'HOME'
RUN chown -R cylc:cylc ${USER_ROOT}

USER 6000
ENV HOME ${USER_ROOT}
ENV PATH="/opt/cylc/bin:${PATH}"
RUN cylc check-software 2> /dev/null && \
	cylc version
