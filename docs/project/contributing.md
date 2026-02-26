# Contributing to Wavelog

Thank you for considering a contribution to Wavelog. The project is developed by radio amateurs for radio amateurs, and every contribution — whether a bug report, a pull request or improved documentation — makes a difference.

## Ways to Contribute

### Report a Bug

If you found a bug in Wavelog, please open an issue on GitHub:

- **Application bugs** → [wavelog/wavelog Issues](https://github.com/wavelog/wavelog/issues)
- **Documentation errors** → [wavelog/wavelog-documentation Issues](https://github.com/wavelog/wavelog-documentation/issues)

Before opening a new issue, search existing ones to avoid duplicates. Include as much detail as possible: Wavelog version, PHP version, browser and steps to reproduce.

### Suggest a Feature

Feature requests are welcome. Open an discussion on [GitHub](https://github.com/wavelog/wavelog/discussions) and describe the use case. The more concrete and focused the request, the easier it is to evaluate.

### Improve the Documentation

Documentation lives in a separate repository and is always a good entry point for first-time contributors. Fix typos, clarify instructions, or add missing examples. See [Local Documentation Preview](#local-documentation-preview) below.

### Submit a Pull Request

1. Fork the repository on GitHub.
2. Create a feature branch from `dev`:
   ```
   git checkout -b describe-your-change
   ```
3. Make your changes and commit with a descriptive message.
4. Push your branch and open a pull request against `dev`.
5. Describe what you changed and why in the PR description.

A maintainer will review your PR. Please be patient — all contributors work on Wavelog in their spare time.

## Code Guidelines

- Wavelog is built on **CodeIgniter 3**, **Bootstrap** and **jQuery**.
- Follow existing code style — __consistency matters more than personal preference__.
- Keep changes focused. One PR per logical change.
- Do not include unrelated formatting or whitespace changes.
- Test your changes locally before submitting.
- Have a deep look into the code before adding new (sub-)functions to avoid redundancies. Re-use is highly appreciated.
- When adding code, keep in mind: it has to be safe, scaleable and must run on minimal-ressources as well as in huge environments
- External Tools are highly appreciated, but please discuss/ask for new API-Endpoints before adding them for your tool. This saves effort on both sides
- When using AI/CodePilot which supports you during development, please be able to understand what you and your AI contributes. Be prepared for questions.
- Pure AI Pull-Requests will be rejected.

See the [Style Guide](../developer/style-guide.md) for frontend conventions.

## Documentation Guidelines

- Write in clear, plain English. Avoid jargon where possible.
- Use admonition blocks (`!!! note`, `!!! tip`, `!!! warning`) for important callouts. See examples here in the [Zensical Docs](https://zensical.org/docs/authoring/admonitions/#supported-types)
- Screenshots are welcome but must be kept up to date — prefer text instructions where practical.
- Relative links between pages, not absolute URLs. 
  Examples:
  ```html
  <a href="../project/contributing#local-documentation-preview">Local Documentation Preview</a>
  ```
  instead of
  ```html
  <a href="https://docs.wavelog.org/project/contributing#local-documentation-preview">Local Documentation Preview</a>
  ```
  Please use `target="_blank" rel="noopener noreferrer"` for external links.
  ```html
  <a href="https://example.com" target="_blank" rel="noopener noreferrer">External Link</a>
  ```

## Local Documentation Preview

The documentation uses [Zensical](https://zensical.org). To preview changes locally:

```bash
# Install dependencies in a venv (Python 3.x required)
pip install -r requirements.txt

# Start the live-reloading development server
zensical serve
```

The documentation will be available at `http://127.0.0.1:8000`.

## Translations

How to help translating is described here in the [Translations Guide](../developer/translations.md).

## Questions?

Open a [GitHub Discussion](https://github.com/wavelog/wavelog/discussions).

73 de the Wavelog Team
