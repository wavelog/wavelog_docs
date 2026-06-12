# Wavelog Docs — local checks and dev helpers.
# Everything runs in Docker, so Docker is the only dependency.
# Run `make help` for an overview, `make test` before pushing.

IMAGE      := wavelog-docs
UID        := $(shell id -u)
GID        := $(shell id -g)
# -t allocates a pseudo-TTY so the tools emit colored output.
DOCKER_RUN := docker run --rm -t --user $(UID):$(GID)

.PHONY: help check-docker image serve build lint links test clean

help:
	@echo "Available targets (all run in Docker):"
	@echo "  make serve   - run the local dev server (localhost:8000)"
	@echo "  make test    - run ALL checks (same as CI: lint, build, links)"
	@echo "  make lint    - markdown lint with auto-fix"
	@echo "  make build   - strict docs build"
	@echo "  make links   - dead link check"
	@echo "  make clean   - remove build output and the local Docker image"

check-docker:
	@command -v docker >/dev/null 2>&1 || { echo "ERROR: docker not found. Please install Docker first: https://docs.docker.com/engine/install/"; exit 1; }

# Local zensical image; the -q build is near-instant once layers are cached.
image: check-docker
	@docker build -q -t $(IMAGE) -f tests/Dockerfile . >/dev/null

serve: image
	$(DOCKER_RUN) -i -e HOME=/tmp -p 8000:8000 -v $(CURDIR):/docs $(IMAGE) zensical serve -a 0.0.0.0:8000

build: image
	$(DOCKER_RUN) -e HOME=/tmp -v $(CURDIR):/docs $(IMAGE) zensical build --strict

# Same images and arguments as the CI workflows in .github/workflows/.
lint: check-docker
	$(DOCKER_RUN) -v $(CURDIR):/workdir davidanson/markdownlint-cli2 --config tests/.markdownlint-cli2.jsonc --fix "docs/**/*.md"

links: check-docker
	$(DOCKER_RUN) -w /input -v $(CURDIR):/input lycheeverse/lychee --cache --max-retries 5 --retry-wait-time 5 --max-cache-age 30d docs/

# Pretty runner: executes lint, build and links with a Cypress-style summary.
test: check-docker
	@bash tests/run.sh

clean:
	rm -rf site .venv
	-docker rmi $(IMAGE) 2>/dev/null
