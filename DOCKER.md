# Draw.io Desktop Headless docker image

[Dockerized headless][1] version of [Draw.io Desktop][2]

## What is does

Draw.io Desktop expose a command-line client to allow us to create, check or export diagrams.

Since Draw.io Desktop is an GUI application, we need an GUI environment to run it.
And this prevent us to use it for automation in non-GUI environment such as CI tools.

This [docker image][1] enable us to run the command-line client in a headless mode.

## Running

```bash
docker run -it -v $(pwd):/data rlespinasse/drawio-desktop-headless
```

Read about [docker image configuration][3]

## License

View [license information][4] for the software contained in this image.

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[1]: https://github.com/rlespinasse/docker-drawio-desktop-headless
[2]: https://github.com/jgraph/drawio-desktop
[3]: https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/v1.x/README.adoc#configuration
[4]: https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/v1.x/LICENSE
