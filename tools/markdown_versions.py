from pathlib import Path
import html
import re


# Markdown captured while MkDocs processes each page.
_markdown_pages = {}


HTML_COMMENT_RE = re.compile(
    r"<!--.*?-->",
    re.DOTALL,
)

SCRIPT_STYLE_RE = re.compile(
    r"<(script|style)\b[^>]*>.*?</\1\s*>",
    re.IGNORECASE | re.DOTALL,
)

BLOCK_HTML_RE = re.compile(
    r"</?(?:div|span|section|article|aside|nav|header|footer|main)"
    r"\b[^>]*>",
    re.IGNORECASE,
)

BR_RE = re.compile(
    r"<br\s*/?>",
    re.IGNORECASE,
)

ADMONITION_RE = re.compile(
    r'^(?P<indent>[ \t]*)'
    r'!!![ \t]+'
    r'(?P<type>[\w-]+)'
    r'(?:[ \t]+"(?P<title>[^"]*)")?'
    r"[ \t]*$"
)

FONTAWESOME_RE = re.compile(
    r":fontawesome-(?:brands|regular|solid)-([a-z0-9-]+):",
    re.IGNORECASE,
)

ATTRIBUTE_LIST_RE = re.compile(
    r"[ \t]*\{:[ \t]*[^{}\n]*\}",
)

EMPTY_LINK_PADDING_RE = re.compile(
    r"\[[ \t]+([^]]*?)\]"
)


# Icons whose meaning should be retained in plain Markdown.
# All unlisted Font Awesome icons are treated as decorative.
ICON_REPLACEMENTS = {
    "dollar-sign": "$",
    "sterling-sign": "£",
    "euro-sign": "€",
}


def on_config(config, **kwargs):
    """
    Clear saved pages at the beginning of each build.

    This matters when using `mkdocs serve`, where multiple builds can run in
    the same Python process.
    """
    _markdown_pages.clear()
    return config


def _strip_front_matter(markdown):
    """Remove YAML front matter from the published Markdown."""
    lines = markdown.splitlines()

    if not lines or lines[0].strip() != "---":
        return markdown

    for index in range(1, len(lines)):
        if lines[index].strip() == "---":
            return "\n".join(lines[index + 1:])

    # No closing delimiter was found, so leave the content unchanged.
    return markdown


def _convert_admonitions(markdown):
    """
    Convert MkDocs admonitions to ordinary Markdown blockquotes.

    For example:

        !!! warning "Important"
            Do not run this in production.

    becomes:

        > **Warning — Important**
        >
        > Do not run this in production.
    """
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
            indentation = len(expanded) - len(expanded.lstrip(" "))

            # A non-indented line marks the end of the admonition.
            if indentation <= base_indent:
                break

            # MkDocs admonition bodies normally have four additional spaces.
            content_start = min(base_indent + 4, len(expanded))
            content = expanded[content_start:]

            output.append(f"> {content}" if content else ">")
            index += 1

    return "\n".join(output)


def _replace_fontawesome(match):
    """
    Replace meaningful icons with text and discard decorative icons.
    """
    icon_name = match.group(1).lower()
    return ICON_REPLACEMENTS.get(icon_name, "")


def _clean_text_fragment(text):
    """
    Remove presentation-specific constructs from Markdown text.

    This function is only called for text outside fenced code blocks.
    """
    text = HTML_COMMENT_RE.sub("", text)
    text = SCRIPT_STYLE_RE.sub("", text)

    # Preserve the intended line break before removing container HTML.
    text = BR_RE.sub("\n", text)
    text = BLOCK_HTML_RE.sub("", text)

    # Remove MkDocs/Material presentation syntax.
    text = ATTRIBUTE_LIST_RE.sub("", text)
    text = FONTAWESOME_RE.sub(_replace_fontawesome, text)

    # Removing an icon can leave whitespace at the beginning of link text:
    #
    #   [ Download](/download/)
    #
    # Change that back to:
    #
    #   [Download](/download/)
    text = EMPTY_LINK_PADDING_RE.sub(r"[\1]", text)

    return html.unescape(text)


def _clean_html_outside_code_fences(markdown):
    """
    Clean HTML and Material syntax without modifying fenced code blocks.

    Both backtick and tilde fences are recognised.
    """
    output = []
    text_buffer = []
    in_fence = False
    fence_character = None
    fence_length = 0

    def flush_text():
        if not text_buffer:
            return

        text = "\n".join(text_buffer)
        text = _clean_text_fragment(text)

        output.extend(text.splitlines())
        text_buffer.clear()

    for line in markdown.splitlines():
        stripped = line.lstrip()
        fence_match = re.match(r"(`{3,}|~{3,})", stripped)

        if fence_match:
            marker = fence_match.group(1)
            marker_character = marker[0]

            if not in_fence:
                flush_text()
                in_fence = True
                fence_character = marker_character
                fence_length = len(marker)
                output.append(line)
                continue

            if (
                marker_character == fence_character
                and len(marker) >= fence_length
            ):
                output.append(line)
                in_fence = False
                fence_character = None
                fence_length = 0
                continue

        if in_fence:
            output.append(line)
        else:
            text_buffer.append(line)

    flush_text()
    return "\n".join(output)


def _normalise_blank_lines(markdown):
    """Remove excessive blank lines and ensure one final newline."""
    markdown = re.sub(r"\n{4,}", "\n\n\n", markdown)
    return markdown.strip() + "\n"


def _sanitise_markdown(markdown):
    """Create the clean Markdown representation of a page."""
    markdown = _strip_front_matter(markdown)
    markdown = _convert_admonitions(markdown)
    markdown = _clean_html_outside_code_fences(markdown)
    markdown = _normalise_blank_lines(markdown)
    return markdown


def on_page_markdown(markdown, *, page, config, files, **kwargs):
    """
    Capture a cleaned Markdown version of every generated page.

    The original Markdown is returned so this hook does not change the normal
    HTML output.
    """
    _markdown_pages[page.url] = _sanitise_markdown(markdown)
    return markdown


def on_post_build(*, config, **kwargs):
    """Write the cleaned Markdown files beside the generated HTML site."""
    site_dir = Path(config["site_dir"])

    for page_url, markdown in _markdown_pages.items():
        url = page_url.rstrip("/")

        # Support configurations where MkDocs produces page.html rather than
        # directory-style page/index.html URLs.
        if url.endswith(".html"):
            url = url[:-5]

        if url:
            target = site_dir / f"{url}.md"
        else:
            target = site_dir / "index.md"

        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(markdown, encoding="utf-8")
