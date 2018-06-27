# A Docker image for Cylc
Here we have a very basic container image for [Cylc].
Cylc is a workflow engine for running suites of inter-dependent jobs.
I'm still learning/evaluating Cylc so hopefully this container image helps
you get started with Cylc. It contains Cylc `7.7.1`.

There's also nice introductory Cylc online [tutorial] from the guys behind
[Rose].

## Building the image
You should find an image on Docker Hub or you can use `docker` or
`docker-compose` to build the image. Navigate to the `cylc` directory
and run: -

    docker-compose build
     
This should create the image.

>   I'm using OSX (10.13.5) and docker-compose (1.21.1)

You can change the image basename and the Cylc version without editing the
files by using the following environment variables (refer to the
`docker-compose.yml` for details): -

    CYLC_DOCKER_V
    CYLC_DOCKER_OWNER

## Running the image
To spin the image up, you can run the following to get to the `cylc` user's
bash shell: -

    docker run -it --rm alanbchristie/cylc:7.7.1

## Running with the GUI (OSX)
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
    docker run -it --rm -e DISPLAY=$ADDR:0 alanbchristie/cylc:7.7.1

With that done you should be able to run `gcylc &` from the shell in
your container image and the GUI will appear, managed by your host.

---

[article]: https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc
[cylc]: https://cylc.github.io/cylc/
[rose]: https://metomi.github.io/rose/doc/html/index.html
[tutorial]: https://metomi.github.io/rose/doc/html/tutorial/cylc/index.html

Alan Christie  
June 2018
