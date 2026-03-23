# Draw.io Desktop Headless Docker Image

[Dockerized headless][1] version of [Draw.io Desktop][2]

## Overview

Draw.io Desktop exposes a command-line client to allow us to create, check, or export diagrams.

Since Draw.io Desktop is a GUI application, we need a GUI environment to run it.
And this prevents us from using it for automation in a non-GUI environment, such as CI tools.

This [Docker Image][1] enables us to run the command-line client in a headless mode.

## Image Variants

- **`latest`** (full) — Includes Western, CJK, and broad Unicode fonts
- **`minimal`** — Western fonts only, significantly smaller image

## Running

```bash
docker run -it -v $(pwd):/data rlespinasse/drawio-desktop-headless
```

Read about [Docker Image Configuration][3]

## License

View [license information][4] for the software contained in this image.

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[1]: https://github.com/rlespinasse/docker-drawio-desktop-headless
[2]: https://github.com/jgraph/drawio-desktop
[3]: https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/v1.x/README.adoc#configuration
[4]: https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/v1.x/LICENSE
