---
title: perl client for kdb+ – Interfaces – kdb+ and q documentation
description: How to connect a Perl program to a kdb+ server process
keywords: api, interface, kdb+, library, perl, q
---
# ![Perl](img/perl.png) Perl client for kdb+



:fontawesome-regular-hand-point-right: [cpan.org/~markpf/KX-0.039/](https://metacpan.org/release/MARKPF/KX-0.039)

!!! note "From Mark Pfeiffer"

    So far:

    - `$k->cmd()` doesn’t handle keyed tables well. Use `$k->Tget()` then `$k->val` to get the underlying value as a Perl hash.
    - Use KX-0.36: it is the most stable.

