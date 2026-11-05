# AGENTS.md

Guidance for AI agents working in this repository. `CLAUDE.md` is a symlink to this file, so Claude Code and other agents read the same instructions.

## About this repo

This repo is the source for the documentation for kdb+ and q, published at `code.kx.com/q`. It is built with MkDocs and the Material for MkDocs theme. Most content is Markdown in `docs/`. The rest are images, stylesheets, scripts and the site configuration.

- Content lives in `docs/`. The site structure is defined only by the `nav:` section in `mkdocs.yml`. A page that is not in `nav:` does not appear on the site.
- `mkdocs.yml` has lines marked `DO NOT ALTER` and lines marked `MAY BE COMMENTED OUT`. Follow those markers.
- Setup and the local preview are in [`CONTRIBUTING/install.md`](CONTRIBUTING/install.md). Read it before you run the site locally.

## Core principles

- Verify product facts before you write them. Check the behaviour in a q session or in the q source. Do not write q behaviour from memory or from another language.
- Find the canonical page before you add a new one. Link to it rather than repeating its content.
- Put each detail in one place. If two pages need the same detail, one of them links to the other.
- Write for the reader who is new to q. Explain abbreviations on first use.
- Existing pages do not always follow these rules. Do not copy a pattern from a page without checking it against the conventions.

## Writing and style

- Never hard-wrap prose. Write each paragraph and each list item as one long line, and let the editor or renderer wrap it. Hard-wrapped text makes diffs and reviews harder to read.
- The conventions are in [`CONTRIBUTING/`](CONTRIBUTING/index.md): [spelling and grammar](CONTRIBUTING/spelling.md) (American English), [writing style](CONTRIBUTING/style.md), [typography](CONTRIBUTING/typography.md) and [Markdown](CONTRIBUTING/markdown.md). Where they differ from other sources, these win.
- Use the revised terminology in the [q glossary](https://code.kx.com/q/basics/glossary/) and the [terminology page](https://code.kx.com/q/about/terminology/).

## Tooling

```bash
mkdocs serve --dirtyreload       # live preview from the folder that has mkdocs.yml; see CONTRIBUTING/install.md
./local.sh build                 # the build that CI runs; it needs Docker
```

`--dirtyreload` does not reflect changes to `mkdocs.yml`. Stop and restart `mkdocs serve` after you change that file.

## Before you open a PR

- [ ] The site builds with `./local.sh build`, and the pages you changed render correctly in `mkdocs serve`.
- [ ] Each new page is in `nav:` in `mkdocs.yml`.
- [ ] Code blocks are labelled with their language, as [`CONTRIBUTING/markdown.md`](CONTRIBUTING/markdown.md) requires.
- [ ] Links, including anchors, work.
- [ ] Spelling follows [`CONTRIBUTING/spelling.md`](CONTRIBUTING/spelling.md).

## Boundaries

- Do not add credentials, tokens, customer data or internal hostnames or links to any file. This repo is public.
- Do not commit the generated `site/` output, or the `local/` and `docs/local/` folders that `local.sh` creates.
- Do not open a PR, push, or change the `DO NOT ALTER` lines in `mkdocs.yml` unless the user asks.
