---
title: Developing with kdb+ and the q language
description: Documentation, white papers and developer resources for kdb+ and the q programming language from KX
author: Stephen Taylor
---
# Developing with kdb+ and the q language

<!-- 
<div markdown="1" class="container"><div class="css-carousel">[![Kdb+ 4.0](img/carousel/kdb4.jpg){.css-img}](releases/ChangesIn4.0.md)[![KX Dashboards](img/carousel/dashboards-600.jpg){.css-img}](/dashboards/)[![AutoML](img/carousel/automl-600.png){.css-img}](ml/automl/index.md)[![AWS Lambda](img/carousel/lambda-600.jpg){.css-img}](cloud/aws-lambda/index.md)[![Parallelism](img/carousel/parallelism-600.jpg){.css-img}](kb/mt-primitives.md)[![Encryption](img/carousel/encryption-600.jpg){.css-img}](kb/dare.md)[![Optane](img/carousel/optane-memory-600.jpg){.css-img}](kb/optane.md)[![Interfaces](img/carousel/interfaces.png){.css-img}](interfaces/hdf5/index.md)[![Reading Room](img/carousel/reading.png){.css-img}](learn/reading/index.md)</div>
</div>

24 March 2021 | **Leverage the Microsecond Mindset in the Cloud** | 
[Register](https://firstderivatives.zoom.us/webinar/register/WN_f0Sc5dXIQK-__Gda9GXSUw?)
{: style="background-color:#FFC300;border-radius:7px;padding:.2em 1em;"}
 -->

<div style="display: flex"  flex-direction: row; flex-wrap: wrap; markdown="1">

<div style="display: inline-flex;" markdown="1">
Kdb+, from [KX](https://kx.com), is

-   a high-performance cross-platform historical time-series columnar database 
-   an in-memory compute engine
-   a real-time streaming processor
-   an expressive query and programming language called q
</div>

<style>#kx-whats-new p {white-space: nowrap}</style>
<div id="kx-whats-new" style="display: inline-flex; margin-left: 25px; width: 250px;" markdown="1">
!!! tip "New"

    :fontawesome-regular-map: [Surveillance in the Cloud](wp/surv-cloud/index.md)

    :fontawesome-brands-github: [Go interface](https://github.com/jshinonome/geek)

    :fontawesome-brands-github: [gRPC interface](https://github.com/diamondrod/qrpc)

    :fontawesome-brands-github: [COMTRADE file parser](https://github.com/diamondrod/q_comtrade)

    :fontawesome-brands-github: [IntelliJ IDEA plugin](https://github.com/kdbinsidebrains/plugin)

</div>

</div>

<div style="clear: both">&nbsp;</div>

<div id="kx-home-page-grid" markdown="1">

<style>#kx-get-started a {color: white}</style>
[Get started](learn/install.md)
{: #kx-get-started .md-button}

[<span style="font-size: 3em">:fontawesome-solid-hiking:</span><br/>
Intro tour](learn/tour/index.md "A one-page rapid tour of the q language")
{: .md-button}

[<span style="font-size: 3em">:fontawesome-solid-book-reader:</span><br/>
Learn q](learn/index.md)
{: .md-button}

[<span style="font-size: 3em">:fontawesome-solid-dollar-sign:</span><br/>
Data types](basics/datatypes.md "Datatypes in kdb+")
{: .md-button}

[<span style="font-size: 3em">:fontawesome-solid-book:</span><br/>
Q reference](ref/index.md "Reference card for the q language")
{: .md-button}

[<span style="font-size: 3em">:fontawesome-solid-database:</span><br/>
Database](database/index.md "Roughly speaking, kdb+ is what happens when q tables are persisted and then mapped back into memory for operations.")
{: .md-button}

[<span style="font-size: 3em">:fontawesome-solid-laptop-code:</span><br/>
IDE: KX Developer](/developer/ "Download and install the free IDE, KX Developer")
{: .md-button}

</div>


??? quote "How we are responding to the pandemic"

    ![Seamus Keating](img/seamus-keating.jpg)
    {: style="float:right; margin:0 0 0 1em; width:150px;"}

    As we face these challenging times brought on by the coronavirus pandemic, I wanted to share how we are addressing the situation for our employees and customers.
    We understand this is a stressful time, especially for anyone who is affected directly by the coronavirus, or has family members or friends impacted.

    From early on, we set up a global committee of cross-functional leaders meeting daily to review the information coming from governments, the medical community and our employees in the field.
    This committee developed a multi-level plan covering a range of recommendations and has been communicating with our employees multiple times per week to keep everyone up to date.

    The safety and well-being of our team, customers and partners has been our priority and we are taking all pragmatic measures to ensure that continues in an ever-evolving situation.
    These measures include staff working from home as they continue delivering services and support to clients across the globe.
    We are also leveraging virtual and digital communication methods as much as possible to keep the lines open and teamwork internally and externally going forward.

    We recognize that many of our customers are at the front line of maintaining confidence in the global economy and we are supporting them with their business continuity plans to ensure mission-critical work continues to get done.

    I am personally proud of the speed, agility and commitment demonstrated by our team despite the disruptions to our lives and work routines.
    We value the confidence our customers have put in us and are committed to working together to deliver for you throughout this unprecedented situation – and in better times ahead.


    **Seamus Keating**
    <br>
    CEO, FD technologies plc

:fontawesome-solid-globe:
[Careers at KX and FD Technologies](http://www.firstderivatives.com/careers/)

---
:fontawesome-solid-download:
[Download](https://code.kx.com/download/q.zip "60MB") a copy of this site you can run from an isolated webserver

The source code for this site is on GitHub at
:fontawesome-brands-github:
[KxSystems/docs](https://github.com/kxsystems/docs/)

