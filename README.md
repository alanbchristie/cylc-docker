# A Docker image for Cylc
Here we have a very basic container image for [Cylc].
I'm still learning/evaluating Cylc so hopefully this container image works.
It contains Cylc `7.7.0` and appears to respond to basic commands (`version`
and `check-software`).

## Building the image
You should find an image on Docker Hub or you can use `docker` or
`docker-compose` to build the image. Navigate to the `cylc` directory
and run: -

    docker-compose build
     
This should create the image (`alanbchristie/cylc:7.7.0`).

>   I'm using OSX (10.13.5) and docker-compose (1.21.1)

## Running the image
To spin the image up, you can run the following to get to the `cylc` user's
bash shell: -

    docker run -it --rm alanbchristie/cylc:7.7.0

## Running the GUI (OSX)
Thanks to Nils De Moor's [article] it's relatively straightforward to get
the Cylc GUI running from a container instance in OSX. You will need to have
installed a couple of tools (using `brew`): -

    brew install socat
    brew cask install xquartz

Then, after a one-time reboot, you should be able to enable the windows system
on your Mac using its IP address by following the instructions in the article.
Namely: -

-   Make sure the X11 preferences `Allow connections from network client`
    option is checked (the article explains all of this, but basically run
    `open -a Xquartz` and see the `XQuartz -> Preferences... -> Security` panel)
-   Run `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
    (this will block)
-   Open a new terminal session and obtain your host's IP address with
    `ifconfig en0`
-   Use the IP address to define the `DISPLAY` environment variable in your
    Cylc container. i.e. run
    `docker run -it --rm -e DISPALY=<ip-addr>:6000 alanbchristie/cylc:7.7.0`

With that done you should be able to run `gcylc &` from the shell in
your container image and the GUI will appear, managed by your host.

---

[article]: https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc
[cylc]: https://cylc.github.io/cylc/

Alan Christie  
June 2018
