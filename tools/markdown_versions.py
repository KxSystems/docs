from pathlib import Path
import html
import re


_markdown_pages = {}


HTML_COMMENT_RE = re.compile(r"<!--.*?-->", re.DOTALL)

SCRIPT_STYLE_RE = re.compile(
    r"<(script|style)\b[^>]*>.*?</\1\s*>",
    re.IGNORECASE | re.DOTALL,
)

BLOCK_HTML_RE = re.compile(
    r"</?(?:div|span|section|article|aside|nav|header|footer|main)"
    r"\b[^>]*>",
    re.IGNORECASE,
)

BR_RE = re.compile(r"<br\s*/?>", re.IGNORECASE)

ADMONITION_RE = re.compile(
    r'^(?P<indent>[ \t]*)!!![ \t]+'
    r'(?P<type>[\w-]+)'
    r'(?:[ \t]+"(?P<title>[^"]*)")?[ \t]*$'
)


def _strip_front_matter(markdown):
    """Remove YAML front matter from the published Markdown."""
    lines = markdown.splitlines()

    if not lines or lines[0].strip() != "---":
        return markdown

    for index in range(1, len(lines)):
        if lines[index].strip() == "---":
            return "\n".join(lines[index + 1:])

    return markdown


def _convert_admonitions(markdown):
    """Convert MkDocs admonitions into ordinary Markdown blockquotes."""
    lines = markdown.splitlines()
    output = []
    index = 0

    while index < len(lines):
        match = ADMONITION_RE.match(lines[index])

        if not match:
            output.append(lines[index])
            index += 1
            continue

        base_indent = len(match.group("indent").expandtabs(4))
        admonition_type = match.group("type").replace("-", " ").title()
        title = match.group("title")

        if title:
            heading = f"**{admonition_type} — {title}**"
        else:
            heading = f"**{admonition_type}**"

        output.append(f"> {heading}")
        output.append(">")

        index += 1

        while index < len(lines):
            line = lines[index]

            if not line.strip():
                output.append(">")
                index += 1
                continue

            expanded = line.expandtabs(4)
            indent = len(expanded) - len(expanded.lstrip(" "))

            if indent <= base_indent:
                break

            # MkDocs admonition bodies normally use four extra spaces.
            content = expanded[min(base_indent + 4, len(expanded)):]
            output.append(f"> {content}" if content else ">")
            index += 1

    return "\n".join(output)


def _clean_html_outside_code_fences(markdown):
    """
    Remove selected presentation-only HTML without modifying fenced code.

    This intentionally does not remove every HTML tag. Tags such as <table>,
    <details>, <img>, <a> and embedded media may contain useful information
    and should be reviewed separately.
    """
    output = []
    text_buffer = []
    in_fence = False
    fence_marker = None

    def flush_text():
        if not text_buffer:
            return

        text = "\n".join(text_buffer)
        text = HTML_COMMENT_RE.sub("", text)
        text = SCRIPT_STYLE_RE.sub("", text)
        text = BR_RE.sub("\n", text)
        text = BLOCK_HTML_RE.sub("", text)
        text = html.unescape(text)

        output.extend(text.splitlines())
        text_buffer.clear()

    for line in markdown.splitlines():
        stripped = line.lstrip()

        if stripped.startswith("```") or stripped.startswith("~~~"):
            marker = stripped[:3]

            if not in_fence:
                flush_text()
                in_fence = True
                fence_marker = marker
                output.append(line)
            elif marker == fence_marker:
                output.append(line)
                in_fence = False
                fence_marker = None
            else:
                output.append(line)

            continue

        if in_fence:
            output.append(line)
        else:
            text_buffer.append(line)

    flush_text()
    return "\n".join(output)


def _normalise_blank_lines(markdown):
    """Reduce excessive blank lines while preserving readable Markdown."""
    markdown = re.sub(r"\n{4,}", "\n\n\n", markdown)
    return markdown.strip() + "\n"


def _sanitise_markdown(markdown):
    markdown = _strip_front_matter(markdown)
    markdown = _convert_admonitions(markdown)
    markdown = _clean_html_outside_code_fences(markdown)
    markdown = _normalise_blank_lines(markdown)
    return markdown


def on_page_markdown(markdown, *, page, config, files, **kwargs):
    """
    Capture the Markdown associated with each generated page.

    Returning the original value ensures the normal HTML build is unchanged.
    """
    _markdown_pages[page.url] = _sanitise_markdown(markdown)
    return markdown


def on_post_build(*, config, **kwargs):
    """Write cleaned Markdown alongside the generated HTML site."""
    site_dir = Path(config["site_dir"])

    for page_url, markdown in _markdown_pages.items():
        url = page_url.rstrip("/")

        if url.endswith(".html"):
            url = url[:-5]

        if url:
            target = site_dir / f"{url}.md"
        else:
            target = site_dir / "index.md"

        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(markdown, encoding="utf-8")
