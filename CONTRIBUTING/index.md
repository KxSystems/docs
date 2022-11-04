Contributing to code.kx.com
===========================



It is simple to get started and contribute to the new documentation on code.kx.com.


Minor corrections
-----------------

Simply fork the repository, or click edit button on GitHub, which will automatically fork the repository to your account. Make a change and create a pull request for the main repository.

One of the admins will review your change and provide feedback on possible improvements – or just merge it in.


White papers
------------

Contributions to the series of [Kx Technical White Papers](../docs/wp/index.md) should be drafted in Markdown and follow the conventions in this guide. 
Image files should be ≤800px wide. 

Use the source files for published papers as models.

Send the draft as a single Markdown file with any accompanying image files to librarian@kx.com. 


Larger changes
-------------- 

Establish a local development setup before creating your pull request. Many users rely on code.kx.com for their daily work.
You would not want to see some half-baked pages merged in.

You can either:

-   [Install and run MkDocs locally](install.md)
-   Run a prebuilt Docker container with all the development dependencies already installed


Conventions
-----------

The site conventions govern 

-   [spelling and grammar](spelling.md)
-   [terminology: use the [revised terminology](https://code.kx.com/q/about/terminology/) 
-   [typography](typography.md)
-   [use of Markdown](markdown.md)
-   [writing style](style.md)

They apply to everything published on code.kx.com.

The object of the conventions is to remove ambiguity. 
They rarely do.
In most instances of potential ambiguity the author’s intent can be deduced by an intelligent reader. 

But sometimes the conventions have important work to do. 
For example:

> For unary values the keyword `over` is preferred over the iterator Over, e.g. for unary `f`, write `f over` rather than `f/`.

Consistent observation of the conventions relieves the reader of the cognitive load of resolving ambiguities, and raises the value of the documentation. 


