# Wavelog Documentation

This is the source code for the official Wavelog Documentation, built with Zensical.
The documentation is available at https://docs.wavelog.org/

For contributing to the documentation, please refer to https://docs.wavelog.org/project/contributing/#documentation-guidelines

## Dependencies

Python with venv Module

## Local Development

```bash
cd wavelog_docs
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# build the sources
zensical build

# or directly run the dev server
zensical serve

## Runs on locahost:8000 
```

>[!IMPORTANT]
> Make sure you run all tests before pushing your changes. You can run the tests with the following command. Nodejs is required to run the tests.

```bash
lychee --cache -v --max-cache-age 2h docs/
zensical build --strict
npx markdownlint-cli2 --fix "docs/**/*.md"
```

Cheers