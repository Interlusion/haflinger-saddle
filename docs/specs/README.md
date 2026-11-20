# Requirement Specifications

REQ-001 is the base spec: the personas, stories and terms, and the rules both directions follow, such as how values and codes pass between ERPNext and Haflinger's model and how problems are shown. REQ-002 and REQ-003 hold the two directions an invoice travels, as Haflinger's specs do (HAFL-ADR-004): they change at different rates, are read for different tasks, and incoming invoices, which come from anyone, carry a risk outgoing ones don't. Every spec has an intended use, user stories, its requirement rules, user requirements (URS, what is needed), product requirements (PRS, what is built, each with a Definition of Done), acceptance criteria, assumptions and open questions (kept when empty), and always shows the current state.

| Spec | Area | Status |
| :- | :- | :- |
| [REQ-001](req-001-core.md) | Core: personas, stories and terms, values and codes between ERPNext and the model, problems shown, the e-invoice kept, permissions, installing | Draft |
| REQ-002 | Outgoing invoices: a sales invoice written as XRechnung or ZUGFeRD | Planned |
| REQ-003 | Incoming invoices: an invoice received, turned into a purchase invoice draft | Planned |

Requirements on Haflinger itself go into Haflinger's specs, in its repository (HAFL-ADR-001); a spec here cites them by ID.

## Reading and writing

- **For any task, read REQ-001 first**, then the spec the map below names.
- **Mapping a field of a sales invoice:** REQ-002; **of a purchase invoice, or matching a supplier or item:** REQ-003; **a code both use, such as a unit or a VAT category:** REQ-001.
- **The map below decides** where a requirement goes, by its main subject. For a subject not yet in it: if one spec uses it, that spec; if several do, the spec where it is maintained; otherwise REQ-001. Add the new entry to the map first.

| Spec | Main subjects |
| :- | :- |
| REQ-001 Core | Values passed between ERPNext's documents and the model, their precision included; codes taken from ERPNext's records (currency, country, unit, VAT category and exemption reason); how Haflinger's refusals and findings are shown; the e-invoice file kept with its document; permissions; installing and uninstalling |
| REQ-002 Outgoing invoices | A sales invoice turned into an e-invoice: the profile chosen, the mapping of the sales invoice (the company as seller, the customer, lines, taxes, Skonto, rounding, delivery date, payment), the ZUGFeRD PDF, optional system packages such as Ghostscript and how their absence is shown, what is handed out and what is refused |
| REQ-003 Incoming invoices | An invoice received: intake by e-mail or upload, its size limit, the background job, scanning, matching the company as buyer, the supplier and the items, the purchase invoice draft and its review |

## IDs

Requirement, user story and persona IDs always carry the spec's ID: `REQ-002-PRS-F004`, `REQ-001-P1-2`, `REQ-001-P1`, never a bare `PRS-F004`. This holds in the specs, the other docs, code comments, tests and commit messages. EN 16931 business terms keep their own IDs (`BT-1`, `BG-23`), and Haflinger's IDs carry its code (`HAFL-REQ-004-PRS-F001`).

The project code is **SADL**. Outside this repository, IDs carry it: `SADL-REQ-002-PRS-F004`, or `SADL-REQ-002` for a whole spec. The code never changes, since other repositories cite it.

## Changes

A **substantive change** adds, removes or rewords a requirement, or changes a term so that a requirement covers other cases; a typo, a link, formatting or clearer wording keeps the meaning and isn't one. A spec's `Date` is the date of its last change.

- **Draft:** edited in place.
- **Baselined, until the app's 1.0.0:** still edited in place; a substantive change raises the spec's `Version`.
- **From the app's 1.0.0 on:** a substantive change is folded into the body, and a sibling `req-NNN-name.history.md` records the dated reason, most recent first; the `Version` goes up with each entry. A change that keeps the meaning is made in the body only.

From baseline on, requirement IDs are never renumbered or reused: a removed requirement's ID stays retired, as tests, code comments and commit messages cite it.
