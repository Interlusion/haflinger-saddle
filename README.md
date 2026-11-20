# Haflinger Saddle

XRechnung and ZUGFeRD e-invoicing for ERPNext, built on [Haflinger](https://github.com/Interlusion/haflinger).

**Status:** planning. Nothing to install yet: the decisions and specs come first, then the code.

## What it is

- **An app for ERPNext.** It writes sales invoices as XRechnung or ZUGFeRD, and later turns incoming invoices into purchase invoice drafts that a person reviews.
- **Built on Haflinger.** The [Haflinger](https://github.com/Interlusion/haflinger) library holds the model of the EN 16931 business terms, reads and writes the formats, and validates with the official rules. This app maps ERPNext's documents to and from that model and holds no format knowledge of its own.
- **Easy to install.** It installs into a bench like any other app, with nothing else to host. XML works everywhere; the ZUGFeRD PDF needs Ghostscript on the system, and the app says so where it is missing.

## What it is not

- Not a Peppol access point: Peppol goes through a certified provider.
- Not affiliated with or endorsed by Frappe Technologies. ERPNext and Frappe are their trademarks.

## Documentation

Start at [docs/README.md](https://github.com/Interlusion/haflinger-saddle/blob/main/docs/README.md): the [architecture](https://github.com/Interlusion/haflinger-saddle/blob/main/docs/arc42/README.md), the [decisions](https://github.com/Interlusion/haflinger-saddle/blob/main/docs/arc42/adr/README.md) and the [backlog](https://github.com/Interlusion/haflinger-saddle/blob/main/docs/backlog/backlog.md).

## Scope

Haflinger Saddle is maintained for our own use. Contributions are welcome ([contributing](https://github.com/Interlusion/haflinger-saddle/blob/main/CONTRIBUTING.md)); support isn't promised. Report vulnerabilities privately, as the [security policy](https://github.com/Interlusion/haflinger-saddle/blob/main/SECURITY.md) describes.

## Licence

GPL-3.0, as it builds on ERPNext ([LICENSE](https://github.com/Interlusion/haflinger-saddle/blob/main/LICENSE)). Haflinger itself is Apache-2.0.
