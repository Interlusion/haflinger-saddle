# ADR-001: A Frappe app in the bench, with nothing else to host

| Meta | Value |
| :- | :- |
| **Status** | Proposed |
| **Date** | 2026-11-20 |
| **Author** | loxy (drafted with Claude) |

## Context

Haflinger, the library, holds the model of the EN 16931 business terms, reads and writes the formats and validates with the official rules; it leaves to the app where the ERPNext side runs, per feature (HAFL-ADR-001). The app is meant to be easy to use, also for people other than its maintainers: on their own server, in Docker or on Frappe Cloud.

What the app needs at run time:

- **Haflinger and `saxonche`**, from PyPI. `saxonche` is a native wheel of about 105 MB, for glibc, not musl; Haflinger runs it in a worker process of its own, so a crash of Saxon doesn't take the caller's process down (HAFL-ADR-010).
- **Ghostscript, for the ZUGFeRD PDF only.** ERPNext writes no PDF/A, and `embed` takes only PDF/A; Ghostscript converts ERPNext's PDF ([ITEM-001](../../backlog/item-001-invoices-in-erpnext.md#pdfa-from-erpnext)). It is a system package, not on PyPI, under AGPL-3.0.

Where a bench gets a system package:

- **Own server**: `apt install ghostscript`.
- **Docker**: the image `frappe/erpnext` holds no Ghostscript; a setup that wants the PDF builds its own image.
- **Frappe Cloud**: an app declares the system packages it needs in its `pyproject.toml`, and Frappe Cloud installs them when it builds the bench's image ([Installing App APT Dependencies](https://docs.frappe.io/cloud/faq/installing-app-apt-dependencies), read on 2026-11-20). The page doesn't say whether this holds for apps from the Frappe Cloud Marketplace.

```toml
[tool.frappe-cloud]
apt-dependencies = ["ghostscript"]
```

## Decision

- **A Frappe app, `haflinger_saddle`**, installed into the bench like any other app (`bench get-app`, or Frappe Cloud). It calls Haflinger in its own Python environment; Saxon runs in Haflinger's worker process.
- **Nothing else to host**: no service of the app's own, no second container.
- **XML works everywhere**: XRechnung and ZUGFeRD's XML need only what pip installs.
- **The ZUGFeRD PDF when Ghostscript is there.** The app declares it for Frappe Cloud as above, and the install guide names it for the other setups. Where it is missing, the app sends the invoice as XML, which is the e-invoice, and says why; it never hands out a PDF that isn't PDF/A.
- **Per feature, later**: should a host be unable to run one feature, such as the PDF/A conversion, a new ADR may move that feature alone out of the bench.

## Alternatives Considered

### Alternative 1: A separate service

A small web service in its own container, holding Haflinger, Saxon and Ghostscript, which ERPNext calls over HTTP.

**Rejected because**: every user would host, secure and update a second service, and invoices, with the customers' data in them, would cross the network. The app would still be needed for the buttons, the fields and the mapping of ERPNext's documents, so the service splits the app in two rather than replacing it. It would solve only Ghostscript, which Frappe Cloud installs anyway.

### Alternative 2: Tools of another system

Haflinger run from an automation tool or a script outside ERPNext, which talks to ERPNext through its REST API, for example a mailbox watcher that creates purchase invoice drafts.

**Rejected because**: it fits incoming invoices only. An outgoing invoice starts in ERPNext, where a person submits it, and it would need a second system that each user sets up.

### Alternative 3: PDF/A with WeasyPrint, which pip installs

Frappe 16 keeps WeasyPrint as a legacy renderer, and it writes PDF/A-3b itself.

**Rejected because**: `embed` refuses its PDFs, whose `id` attributes become named destinations, and its layout differs from ERPNext's preview ([ITEM-001](../../backlog/item-001-invoices-in-erpnext.md#pdfa-from-erpnext)).

## Consequences

### Positive

- One install, the way ERPNext's users already install apps; nothing to run beside the bench.
- Invoices stay inside ERPNext.
- Works on Frappe Cloud, Ghostscript included.

### Negative

- Every bench carries Saxon, about 105 MB, and no bench on musl can run it.
- A Docker setup builds its own image for the ZUGFeRD PDF.
- The app's tests need a bench with ERPNext, heavier in CI than the library's.

## Reconsideration Triggers

1. Frappe Cloud doesn't install the `apt-dependencies` of a Marketplace app.
2. `saxonche` fails in Frappe's web or background workers under load ([backlog](../../backlog/backlog.md)).
3. ERPNext writes PDF/A itself, or a renderer installed with pip writes a PDF/A that `embed` takes.
4. The answer on `saxonche`'s licence beside the GPL-3.0 app needs Saxon out of the bench ([ITEM-002](../../backlog/item-002-saxonche-licence.md)).

## Compliance

- The app SHALL install into a bench, on Frappe Cloud too, without a service of its own.
- A feature that needs more than pip installs SHALL be optional, and the app SHALL say where it is missing.
- The app SHALL NOT hand out a ZUGFeRD PDF that isn't PDF/A.

## References

- [ITEM-001](../../backlog/item-001-invoices-in-erpnext.md), [ITEM-002](../../backlog/item-002-saxonche-licence.md)
- HAFL-ADR-001, HAFL-ADR-010, among [Haflinger's ADRs](https://github.com/Interlusion/haflinger/blob/main/docs/arc42/adr/README.md)
- [Frappe Cloud: Installing App APT Dependencies](https://docs.frappe.io/cloud/faq/installing-app-apt-dependencies)
