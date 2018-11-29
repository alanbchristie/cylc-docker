# Packer and Docker images for Cylc
Docker and Centos images for [Cylc].

Cylc is a workflow engine for running suites of inter-dependent jobs.
I'm still learning/evaluating Cylc so hopefully this container image helps
you get started with Cylc.

There's also nice introductory Cylc online [tutorial] from the guys behind
[Rose].

Before continuing, make sure you've installed Python 3 or setup a Python 3
virtual environment (from which you can run this stuff) and then install
the requirements: -

    pip install -r requirements.txt
     
## Docker Image
The `docker` directory produces a very basic container image for Cylc.

### Building the image
You should find an image on Docker Hub or you can use `docker` or
`docker-compose` to build the image. Navigate to the `cylc` directory
and run: -

    docker-compose build
     
This should create the image.

>   I'm using OSX (10.14.1) and docker-compose (1.23.1)

You can change the image basename and the Cylc version without editing the
files by using the following environment variables (refer to the
`docker-compose.yml` for details): -

    CYLC_DOCKER_V
    CYLC_DOCKER_OWNER

### Running the image
To spin the image up, you can run the following to get to the `cylc` user's
bash shell: -

    docker run -it --rm alanbchristie/cylc:7.8.0

### Running with the GUI (OSX)
Thanks to Nils De Moor's [article] it's relatively straightforward to get
the Cylc GUI running from a container instance in OSX. You will need to have
installed a couple of tools (using `brew`): -

    brew install socat
    brew cask install xquartz

Then, after a one-time reboot, you should be able to enable the windows system
on your Mac using its IP address by following the instructions in the article.
Namely: -

By default XQuartz will listen on a UNIX socket, which is private and only
exists on local our filesystem. This means Docker won't be able to access it.
Install and run `socat` to create a tunnel from an open X11 port (6000) through
to the local UNIX socket where XQuartz is listening for connections: -

    socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"

(this will block)

Open a new terminal session and start the X-windows system (Quartz).
Make sure the X11 preferences `Allow connections from network client`
option is checked (the article explains all of this, but basically run: -

    open -a Xquartz
     
and (for the first time) go to `XQuartz -> Preferences... -> Security`.

Obtain your host's IP address and use the IP address to define the
`DISPLAY` environment variable while starting the Cylc container. i.e. run: -

    ADDR=$(ifconfig en0 | grep inet | cut -f 2 -d ' ')
    docker run -it --rm -e DISPLAY=$ADDR:0 alanbchristie/cylc:7.8.0

With that done you should be able to run `gcylc &` from the shell in
your container image and the GUI will appear, managed by your host.

## Yacker (Scaleway)
You can built the base images for Scaleway using [Yacker] (a [Packer] wrapper).
Assuming you've satisfied the project's `requirements.txt` then,
from the `packer/scaleway` directory, run the following: -

    yacker build -var-file=variables.yaml template.yaml

This builds a CentOS 7 image containing Cylc and a `cylc` user.

>   In order to SSH to the cylc user account, unless you have the private key
    file for the public key in `packer/files/authorized_keys` you'll need to
    provide your own `authorized_keys` file for the Packer/Yacker image.

## Creating cylc.zip
It's a stripped-down copy of the 7.8.0 source: -

    export CYLC_V=7.8.0
    cd ~/Downloads
    git clone https://github.com/cylc/cylc.git
    cd cylc
    git checkout tags/$CYLC_V
    rm -rf .git
    rm -rf tests
    rm -rf doc
    echo $CYLC_V > VERSION
    cd ..
    zip -r cylc.zip cylc
    
## SSH keys
You need to generate an SSH key pair to allow the docker and cyle images
to communicate remotely. These keys are not committed to revision control.

Here's an example that creates an SSH key pair for thew build
that has no pass phrase: -

    cd docker/ssh
    ssh-keygen -t ecdsa -b 521 -f id_ecdsa -N ''
    
---

[article]: https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc
[cylc]: https://cylc.github.io/cylc/
[packer]: https://www.packer.io
[rose]: https://metomi.github.io/rose/doc/html/index.html
[tutorial]: https://metomi.github.io/rose/doc/html/tutorial/cylc/index.html
[yacker]: https://pypi.org/project/matildapeak-yacker/

Alan Christie  
November 2018
