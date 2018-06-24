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

---

[cylc]: https://cylc.github.io/cylc/

Alan Christie  
June 2018
