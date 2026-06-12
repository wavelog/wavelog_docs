# Wavelog Documentation

This is the source code for the official Wavelog Documentation, built with Zensical.
The documentation is available at https://docs.wavelog.org/

For contributing to the documentation, please refer to https://docs.wavelog.org/project/contributing/#documentation-guidelines

## Dependencies

[Docker](https://docs.docker.com/engine/install/) and `make` — that's it. All tools (Zensical, markdownlint, lychee) run in containers.

## Local Development

All common tasks are wrapped in a Makefile:

```bash
cd wavelog_docs

# run the dev server on localhost:8000
make serve

# build the sources
make build
```

>[!IMPORTANT]
> Make sure you run all checks before pushing your changes (same checks as CI):
>
> ```bash
> make test
> ```

Run `make help` to see all available targets.

Cheers
