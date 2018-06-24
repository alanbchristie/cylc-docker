# A Docker container for CYLC
Here we have a very basic container image for CYLC.
I'm still learning/evaluating CYLC so hopefully this container image works.
It contains CYLC `7.7.0` and appears to respond to basic commands (`version`
and `check-software`).

## Building the image
You can use `docker` or `docker-compose` to build the image. Navigate to
the `cylc` directory and run: -

    docker-compose build
     
This should create the image (`alanbchristie/cylc:7.7.0`).

>   I'm using OSX (10.13.5) and docker-compose (1.21.1)

## Running the image
There's no `CMD` or `ENTRYPOINT` at the moment so, to spin the image up,
you can run the following to get to the user shell: -

    docker run -it --rm alanbchristie/cylc:7.7.0 /bin/bash

---

Alan Christie
June 2018
