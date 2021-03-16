// title: Configuration for Arithmatex extension with MathJax 3
// date: March 2021
// source: 'https://squidfunk.github.io/mkdocs-material/reference/mathjax/'
window.MathJax = {
  tex: {
    inlineMath: [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    processEscapes: true,
    processEnvironments: true
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex"
  }
};
