# ITEM-001: Invoices in ERPNext

| Meta | Value |
| :- | :- |
| **Status** | CANDIDATE |
| **Type** | feature |
| **Origin** | HAFL-ITEM-003, moved here on 2026-11-20; HAFL-ADR-001; approach review of 2026-10-30 |
| **Created** | 2026-10-30 |
| **Author** | loxy (drafted with Claude) |

## Summary

Bring Haflinger into ERPNext: outgoing sales invoices written as XRechnung or ZUGFeRD, incoming invoices read and turned into purchase invoice drafts a person reviews. The app runs in the bench, with nothing else to host ([ADR-001](../arc42/adr/ADR-001-a-frappe-app.md)), and is GPL-3.0 (HAFL-ADR-009).

## Context / Motivation

What only the ERPNext side can do, and no standards body maintains (HAFL-ADR-003):

- the mapping between ERPNext documents and the model: taxes, Skonto, rounding;
- matching incoming invoices to suppliers, items and accounts, and the review flow;
- rendering the readable PDF of an outgoing invoice with ERPNext's print formats, as PDF/A, which the library then turns into a ZUGFeRD PDF; `embed` refuses a PDF that isn't PDF/A (HAFL-REQ-004-PRS-F007; [PDF/A from ERPNext](#pdfa-from-erpnext));
- completeness under German VAT law (§14(4) UStG): the seller's VAT identifier or tax number (BT-31, BT-32) and the time of supply (BT-72, BG-14). CEN's rules require one of BT-31, BT-32 or BT-63 for most VAT categories; KoSIT's German rules check the time of supply, the parties' city and post code and more, but run only on XRechnung, so a ZUGFeRD invoice between businesses gets none of them. The app fills these values from ERPNext; the check that they are there comes from Haflinger, as an optional check for both directions that runs KoSIT's German rules on any invoice the caller names (HAFL-ITEM-010; planned in HAFL-ADR-014, Proposed, not yet released). Incoming invoices need it most, as input VAT is deductible only from an invoice that meets §14 (§15 UStG). §14(4) UStG implements Article 226 of the EU VAT Directive, so Germany comes first and other countries can follow; a tax adviser reviews the checks before they are relied on;
- further German specifics, for example a note on cash-basis taxation, if it becomes required;
- archiving the original invoice unchanged (GoBD);
- safety with incoming files, where a person or a viewer meets them: virus scanning at intake (mail, upload), in the app or the infrastructure (for example ClamAV); PDFs offered as a download rather than rendered inline, or the invoice shown through KoSIT's visualisation of the XML (HAFL-ITEM-005); attachments inside the XML (BT-125, which the library hands over as bytes) treated as untrusted, scanned, with their names cleaned before saving; reading incoming invoices in a background job with a timeout, because the library doesn't bound the time of reading (HAFL-REQ-003, Assumptions); validation has its own time limit (HAFL-REQ-002-PRS-NF004), and with a `max_size` well below the default of 100 MB, for example 20 MB, because a crafted file takes many times its size in memory when it is read and validated.

ALYF's European e-Invoice app (`alyf-de/eu_einvoice`, GPL-3.0) is prior work the app may reuse, with attribution; nothing of it goes into the Apache-2.0 library:

- its ERPNext mapping: custom fields, tax rows, code lists mapped to tax categories, templates and accounts;
- its import doctype and the matching of suppliers and items;
- its Swiss specifics;
- its issue tracker, as a source of real user problems;
- its known bugs as regression tests for the app: Skonto never written, BT-114 never written, profile detection by exact string.

Its `main` branch targets Frappe/ERPNext 17-dev.

How it handles German content beyond the official rules (at commit `1385900`, 2026-10-31): by mapping, not by checks. The company's Tax ID is written as a VAT identifier (BT-31) when it is one, otherwise as a tax number (BT-32, `schemeID="FC"`); nothing checks that either is present. A delivery date (BT-72) is always written: the latest delivery date of the lines, else the end of the billing period, else the invoice date. The billing period (BG-14) comes from the invoice's from and to dates. Validation runs only the official rules, on outgoing invoices before submission and on imported ones; nothing checks German content in incoming invoices, and there is nothing on cash-basis taxation.

## PDF/A from ERPNext

Measured on 2026-11-20 with ERPNext 16.55.0 and Frappe 16.56.0 (the image `frappe/erpnext:v16.55.0`), on a sales invoice of `Example GmbH` in a throwaway site without network access:

- Frappe has no PDF/A setting. Its generators are wkhtmltopdf, Chromium (the default of a new site and of ERPNext's builder formats, such as "Sales Invoice Classic"; Frappe downloads `chrome-headless-shell` into the bench on first use), PlutoPrint (not installed), Typst and WeasyPrint. Neither wkhtmltopdf nor Chromium writes PDF/A; Typst refuses a builder format holding an HTML block or a letterhead with HTML, as "Sales Invoice Classic" does.
- Ghostscript 10.05.1 converted Chromium's PDFs of "Sales Invoice Classic" and "Standard", and wkhtmltopdf's of "Standard", to PDF/A-3b, with European e-Invoice's command (`gs -dPDFA=3 -dPDFACompatibilityPolicy=2 -sColorConversionStrategy=RGB … PDFA_def.ps`). veraPDF passed each, `embed` took each, and veraPDF passed the ZUGFeRD PDFs. A conversion took 60 ms; the text read from the PDF was unchanged, and under 0.1 % of the rendered page's pixels differed, at the edges of the glyphs.
- WeasyPrint, which Frappe 16 keeps as a legacy renderer, writes PDF/A-3b itself (`pdf_variant="pdf/a-3b"`) from the same HTML, and veraPDF passed it. But `embed` refused it: the `id` attributes of ERPNext's HTML become named destinations (`/Names /Dests`), which `factur-x` would drop. Its layout also differs from the browser's preview, which Chromium's matches.

So the app prints with ERPNext's own generator, converts the PDF with Ghostscript, as European e-Invoice does (at commit `797acf2`, 2026-11-16), and then calls `embed`. Where Ghostscript is missing or fails, European e-Invoice embeds the XML into the unconverted PDF and only logs an error; the app instead sends the invoice as XML, which is the e-invoice, and says why. The app may start with XML alone and add the ZUGFeRD PDF later.

What Ghostscript costs:

- Its licence is AGPL-3.0. The app calls it as a separate program and doesn't ship it: it names Ghostscript as a system requirement, and whoever distributes Ghostscript, for example in a Docker image, carries its obligations.
- It is a system package, missing from the image `frappe/erpnext`: a Docker setup builds its own image.
- Its interpreter has had many security holes. Here it reads only the company's own PDF, with `-dSAFER`, its default, kept on.
- Its output can change between versions: the app's tests check the result with veraPDF, and `embed` refuses a PDF that doesn't declare PDF/A.
- Not yet tried: invoices with a logo, images or several pages.

## Open Questions

- Which of its needs are requirements on the library, for HAFL-REQ-001 to HAFL-REQ-004, and which are the app's own, for its specs (HAFL-ADR-004)?
- Which profile does an ERPNext invoice get by default: XRechnung for public buyers, ZUGFeRD EN 16931 otherwise?
- The delivery date (BT-72) when ERPNext has none: write the invoice date, as European e-Invoice does (§14(4) UStG allows a delivery date equal to the invoice date, but the invoice then states a date nobody entered), or require a real one?
- Does Frappe Cloud install the system packages of an app from its Marketplace, as it does for an app on a private bench ([ADR-001](../arc42/adr/ADR-001-a-frappe-app.md))?
- May the GPL-3.0 app be published while Haflinger requires `saxonche`? To settle before publishing it ([ITEM-002](item-002-saxonche-licence.md)).
