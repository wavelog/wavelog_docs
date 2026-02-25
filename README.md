# Wavelog Documentation

> [!IMPORTANT]
> This is just a test/preparation and not the official Wavelog Documentation. Check out the current one here https://github.com/wavelog/wavelog/wiki

## Dependencies

Python with venv Module

## Local Development

```bash
cd testdocs
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# build the sources
zensical build

# or directly run the dev server
zensical serve

## Runs on locahost:8000 
```

Cheers