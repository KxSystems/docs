from pathlib import Path
import shutil


_documentation_pages = []


def on_files(files, *, config, **kwargs):
    """Capture documentation pages before MkDocs builds the site."""
    global _documentation_pages

    _documentation_pages = [
        (Path(file.abs_src_path), file.url)
        for file in files.documentation_pages()
    ]

    return files


def on_post_build(*, config, **kwargs):
    """Publish each documentation page at its corresponding .md URL."""
    site_dir = Path(config["site_dir"])

    for source, page_url in _documentation_pages:
        url = page_url.rstrip("/")

        if url.endswith(".html"):
            url = url[:-5]

        if url:
            target = site_dir / f"{url}.md"
        else:
            target = site_dir / "index.md"

        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
