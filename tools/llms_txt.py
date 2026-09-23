"""Generate llms.txt as part of an MkDocs build."""

from pathlib import Path


_pages = []

def on_config(config):
    """Reset state when mkdocs serve starts another build."""
    _pages.clear()

def _markdown_url(page, config):
    """Return the public Markdown alternative for a page."""
    return f"{config.site_url.rstrip('/')}/{page.file.src_uri.lstrip('/')}"

def _escape_link_text(value):
    return (
        str(value)
        .replace("\\", "\\\\")
        .replace("[", "\\[")
        .replace("]", "\\]")
    )

def on_page_context(context, *, page, config, nav):
    """
    Collect every rendered page.

    This includes pages that exist in docs/ but are not listed in nav.
    """
    title = _escape_link_text(page.title or page.file.src_uri)

    description = str(
        page.meta.get("description", "")
    ).replace("\n", " ").strip()

    _pages.append(
        (
            page.file.src_uri,
            title,
            _markdown_url(page, config),
            description,
        )
    )

    return context

def on_post_build(config):
    """Write llms.txt into the root of the generated site."""
    lines = [
        "# kdb+ and q documentation",
        "",
        "> Documentation for kdb+ and the q programming language.",
        "",
        (
            "Each linked page is the Markdown alternative to a page "
            "on the documentation site."
        ),
        "",
        "## Documentation",
        "",
    ]

    for _, title, url, description in sorted(_pages):
        suffix = f": {description}" if description else ""
        lines.append(f"- [{title}]({url}){suffix}")

    output = Path(config.site_dir) / "llms.txt"
    output.write_text(
        "\n".join(lines) + "\n",
        encoding="utf-8",
    )
