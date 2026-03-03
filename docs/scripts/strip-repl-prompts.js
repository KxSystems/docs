// When a user clicks a code copy button, copy the code but remove
// leading REPL prompts (q), >>>, Python continuation (...), and In [n]:.
//
// Save this file as: docs/scripts/strip-repl-prompts.js
//
// In mkdocs.yml, add under extra_javascript:
//   - scripts/strip-repl-prompts.js
//
// Ensure it loads after any other custom scripts.

(function () {
  'use strict';

  // Selectors covering Material for MkDocs copy button variations
  const COPY_BUTTON_SELECTORS = [
    '.md-code .md-clipboard',
    'button.md-code__copy',
    'button.md-clipboard',
    '.md-code__copy-button',
    '.md-clipboard__button'
  ].join(',');

  // Match leading REPL prompts at start of line:
  //   q)
  //   >>>
  //   ...
  //   In [n]:
  const REPL_PROMPT_RE = /^\s*(?:q\)|>>>|\.\.\.|In\s*\[\d+\]:)\s?/;

  function closest(el, selector) {
    while (el) {
      if (el.matches && el.matches(selector)) return el;
      el = el.parentElement;
    }
    return null;
  }

  function stripReplPrompts(text) {
    if (!text) return text;
    return text
      .split('\n')
      .map(line => line.replace(REPL_PROMPT_RE, ''))
      .join('\n');
  }

  function getCodeTextFromBlock(container) {
    if (!container) return '';
    const codeElem =
      container.querySelector('pre > code') ||
      container.querySelector('code');
    if (!codeElem) return '';
    return codeElem.textContent || '';
  }

  function writeToClipboard(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(text);
    }

    return new Promise((resolve, reject) => {
      try {
        const ta = document.createElement('textarea');
        ta.value = text;
        ta.style.position = 'fixed';
        ta.style.left = '-9999px';
        document.body.appendChild(ta);
        ta.focus();
        ta.select();
        const ok = document.execCommand('copy');
        document.body.removeChild(ta);
        if (ok) resolve();
        else reject(new Error('execCommand copy failed'));
      } catch (err) {
        reject(err);
      }
    });
  }

  function wireCopyButtons() {
    document.querySelectorAll(COPY_BUTTON_SELECTORS).forEach(btn => {
      if (btn.__replPromptBound) return;
      btn.__replPromptBound = true;

      btn.addEventListener('click', function (ev) {
        try {
          const codeContainer =
            closest(btn, '.md-code') ||
            closest(btn, 'pre') ||
            closest(btn, 'code') ||
            btn.parentElement;

          const raw = getCodeTextFromBlock(codeContainer);
          if (!raw) return;

          const cleaned = stripReplPrompts(raw);
          if (cleaned === raw) return;

          ev.preventDefault();
          ev.stopPropagation();

          writeToClipboard(cleaned).then(() => {
            btn.dispatchEvent(
              new CustomEvent('repl-copy-success', { bubbles: true })
            );
          }).catch(() => {
            // allow fallback behavior
          });

        } catch (err) {
          return;
        }

      }, { capture: true });
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    wireCopyButtons();

    const observer = new MutationObserver(() => {
      wireCopyButtons();
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true
    });
  });

})();
