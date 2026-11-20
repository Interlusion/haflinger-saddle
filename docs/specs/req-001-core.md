# REQ-001: Haflinger Saddle Core — Requirement Specification

| Meta | Value |
| :- | :- |
| **Status** | Draft |
| **Version** | 0.1 |
| **Date** | 2026-11-20 |
| **Author** | loxy (drafted with Claude) |

## Intended Use

Haflinger Saddle is a Frappe app that brings e-invoicing into ERPNext: it turns sales invoices into XRechnung or ZUGFeRD e-invoices and incoming e-invoices into purchase invoice drafts, through the model of Haflinger, the library that holds the formats and the official rules.

This base spec holds what both directions share: the personas, stories and terms, how values and codes pass between ERPNext and the model, how Haflinger's refusals and findings are shown, how the e-invoice is kept, permissions and installing. Outgoing invoices (REQ-002) and incoming invoices (REQ-003) build on it; the [specs index](README.md) says what goes where.

Out of scope: the formats, the official rules and the ZUGFeRD PDF's embedding (Haflinger, HAFL-ADR-001); sending and receiving through Peppol (a certified provider); bookkeeping decisions, which a person makes in ERPNext.

Key constraints: a Frappe app in the bench with nothing else to host ([ADR-001](../arc42/adr/ADR-001-a-frappe-app.md)); ERPNext 16 and Frappe 16, Haflinger's public interface only, the mapping in plain Python ([ADR-002](../arc42/adr/ADR-002-toolchain.md)); GPL-3.0 (HAFL-ADR-009).

## Personas

### REQ-001-P1. The operator

- **Role**: Runs a company's books in ERPNext: sends invoices to customers, enters invoices from suppliers.
- **Expectations**: E-invoices from the documents as they stand in ERPNext, without leaving it.
- **Pain points**: Messages in the language of the formats (`BR-CO-15`, `BT-112`) that don't say which field in ERPNext to fix.
- **Underlying fear**: An amount, party or date changed on the way, so that the e-invoice says something the books don't.

### REQ-001-P2. The administrator

- **Role**: Installs and updates the bench, sets up users and their rights.
- **Expectations**: One app to install like any other, rights as ERPNext already grants them.
- **Pain points**: An app that needs a service of its own, or leaves ERPNext broken when it is removed.
- **Underlying fear**: Invoices, with the customers' data in them, open to users who couldn't see the invoice itself.

### REQ-001-P3. The maintainer

- **Role**: Keeps the app current with ERPNext and Haflinger. Usually an agent, reviewed by a person.
- **Expectations**: Each value in an e-invoice traceable to the field it came from.
- **Pain points**: Codes and rules buried in code, which only a reading of the code finds.
- **Underlying fear**: A value the app made up, which no test notices because it looks plausible.

## User Stories

- REQ-001-P1-1. As the operator, I need the e-invoice to carry exactly the values of the ERPNext document, so that it says what my books say.
- REQ-001-P1-2. As the operator, I need each problem shown on the document with the field it concerns, so that I can fix it without knowing the formats.
- REQ-001-P1-3. As the operator, I need the e-invoice sent or received kept with its document, unchanged, so that I can show it to a tax auditor.
- REQ-001-P2-1. As the administrator, I need the app to install and uninstall like any other app, and to follow the rights ERPNext grants, so that it adds no work and no exposure.
- REQ-001-P3-1. As the maintainer, I need codes set up in ERPNext's records rather than in the code, and every value's source known, so that a wrong value leads to the field it came from.

## Requirement Rules

- SHALL = mandatory · SHOULD = recommended · MAY = optional
- Every SHALL verifiable (test / benchmark / inspection / analysis)
- One requirement = one idea
- The requirements of this spec apply to every spec listed in the [index](README.md); another spec may tighten them, never loosen them. An exception is made only here, by naming it and the spec it applies to.

## Terms

General vocabulary (EN 16931, CIUS, XRechnung, ZUGFeRD, Leitweg-ID …): Haflinger's [E-Invoicing 101](https://github.com/Interlusion/haflinger/blob/main/docs/guides/e-invoicing-101.md). Business term, model and finding are used as HAFL-REQ-001 defines them.

- **E-invoice**: the invoice as XML (CII), or as a ZUGFeRD PDF with the XML embedded, that the app hands out for a sales invoice or receives for a purchase invoice. The readable PDF ERPNext prints is not one.
- **Stored value**: a value ERPNext has saved, on the document or on a record it links to (company, customer, supplier, address, item, tax template, unit of measure). A value the app computes is not one.
- **Refusal**: an error with a reason, given instead of a result, by Haflinger (as HAFL-REQ-001 defines it) or by the app.
- **Mapping**: the app's rules that fill the model's business terms from stored values, and stored values from the model.
- **Precision**: the number of decimal places ERPNext keeps for a field, from its own setting or the system's settings for currency and other numbers.

## URS — Functional

#### REQ-001-URS-F001: Values from what ERPNext stores

**Description**: The mapping SHALL fill a business term only from a stored value, or by a derivation the spec that owns the term names; a term with neither SHALL be left empty, never filled with a default or a guess.

**Related User Stories**: REQ-001-P1-1, REQ-001-P3-1 | **Rationale**: Quality goal 1, correctness ([arc42 §1](../arc42/README.md#1-introduction-and-goals)); whether an empty term is acceptable is for Haflinger's official rules to say.

#### REQ-001-URS-F002: Codes from ERPNext's records

**Description**: The codes an e-invoice carries for currency, country, unit and VAT category SHALL come from ERPNext's records or from what the operator assigned to them, and SHALL NOT be inferred from other values.

**Related User Stories**: REQ-001-P3-1 | **Rationale**: A VAT rate of 0 % may be zero-rated, exempt, reverse charge, intra-community or an export; only the operator knows which.

#### REQ-001-URS-F003: Problems shown in ERPNext's terms

**Description**: The app SHALL show each refusal, Haflinger's and its own, and each of Haflinger's findings to the operator on the ERPNext document it concerns, with the ERPNext field it concerns where the mapping knows one.

**Related User Stories**: REQ-001-P1-2

#### REQ-001-URS-F004: The e-invoice kept with its document

**Description**: The app SHALL keep every e-invoice it hands out or receives with its ERPNext document, unchanged.

**Related User Stories**: REQ-001-P1-3 | **Rationale**: GoBD requires the original of an e-invoice, the XML, to be kept unchanged and readable for the retention period.

## URS — Non-Functional

#### REQ-001-URS-NF001: Exact numbers

**Description**: A number SHALL pass between ERPNext and the model with the value and decimal places ERPNext keeps for it, neither rounded nor extended on the way, and a value ERPNext can't keep as it is SHALL be reported.

**Related User Stories**: REQ-001-P1-1 | **Rationale**: ERPNext hands numbers to Python as floats; `0.1` as a float is not `0.1` as a decimal.

#### REQ-001-URS-NF002: ERPNext's permissions

**Description**: The app SHALL let a user do with an e-invoice only what ERPNext lets that user do with its document.

**Related User Stories**: REQ-001-P2-1

#### REQ-001-URS-NF003: Installed like any app

**Description**: The app SHALL install into and uninstall from an ERPNext site like any other Frappe app, and uninstalling SHALL leave ERPNext's documents working.

**Related User Stories**: REQ-001-P2-1 | **Rationale**: [ADR-001](../arc42/adr/ADR-001-a-frappe-app.md).

## PRS — Functional

#### REQ-001-PRS-F001: Stored values only

**Description**: Each business term the mapping fills SHALL come from a stored value, unchanged apart from REQ-001-PRS-F002 and REQ-001-PRS-NF001, or from a derivation the spec that owns the term names with its inputs. A term with neither SHALL be left empty. The same holds the other way: a stored value the mapping sets from the model SHALL come from a business term or a derivation so named.

**Related URS**: REQ-001-URS-F001

**Definition of Done**:

- For each business term the mapping fills, a test sets its stored value or the inputs of its derivation and finds them in the model; with the stored value empty, the term is empty (tests, in REQ-002 and REQ-003 for their terms).
- No business term is filled from a constant, apart from codes a spec names as fixed for the app, such as BT-24's profile (inspection).

#### REQ-001-PRS-F002: Codes

**Description**: The mapping SHALL take these codes from these records, in both directions:

| Code | Business terms | Taken from |
| :- | :- | :- |
| Currency, ISO 4217 | BT-5, BT-6 | The currency's name in ERPNext, which is its ISO code |
| Country, ISO 3166-1 alpha-2 | BT-40, BT-55, BT-69, BT-80, BT-159 | The country's code in ERPNext, in capital letters |
| Unit, UN/ECE Recommendation 20 or 21 | BT-130, BT-150 | The code assigned to the unit of measure in ERPNext |
| VAT category, UNTDID 5305 | BT-95, BT-102, BT-118, BT-151 | REQ-001-PRS-F003 |

A record without its code SHALL stop the mapping with a refusal naming the record (unit of measure "Box" has no unit code). Where a code from the model has no record, or several, the mapping SHALL report it, naming the code; what follows is the owning spec's.

**Related URS**: REQ-001-URS-F002

**Definition of Done**: tests map each code both ways for a record that has it; a unit of measure without a code gets the refusal naming it; a unit code that two units of measure carry, and one that none carries, are reported with the code (tests).

#### REQ-001-PRS-F003: VAT category from the tax setup

**Description**: The operator SHALL be able to assign a VAT category code to each sales and purchase taxes and charges template and each item tax template, and an exemption reason (BT-120, BT-121) to those whose category requires one. A line's VAT category (BT-151) SHALL come from its item tax template where it has one, else from the invoice's taxes and charges template; the VAT breakdown's (BT-118) and an allowance's or charge's (BT-95, BT-102) from the same setup. A template without a category SHALL stop the mapping with a refusal naming the template. The rate SHALL NOT decide the category.

**Related URS**: REQ-001-URS-F002

**Definition of Done**: tests with templates for categories `S`, `Z`, `E`, `AE` and `K` map each line to its template's category, with the exemption reason where one is assigned; two templates of 0 % with different categories give different categories; a template without a category gets the refusal naming it (tests).

#### REQ-001-PRS-F004: Problems on the document

**Description**: The app SHALL show each refusal, Haflinger's and its own, and each of Haflinger's findings on the form of the ERPNext document concerned, as a message that holds the rule ID or business term, Haflinger's text, and the label of the ERPNext field and, for a line, the row number, where the mapping knows them. It SHALL NOT show a traceback in its place. The operator SHALL be able to see the messages of the last attempt until the next one.

**Related URS**: REQ-001-URS-F003

**Definition of Done**: a test maps a sales invoice whose total doesn't match its lines and finds `BR-CO-15` and Haflinger's text in the message; a test with a missing unit code on the second line finds the field's label and row 2; a refusal from Haflinger without a field the mapping knows is shown with Haflinger's text alone; the messages are still shown after the form is reloaded, and a new attempt replaces them (tests in a bench).

#### REQ-001-PRS-F005: The e-invoice kept

**Description**: The app SHALL attach every e-invoice it hands out, and every e-invoice it receives, to its ERPNext document as a private file, byte for byte as handed out or received. It SHALL NOT overwrite or change a kept e-invoice; a new e-invoice for the same document is a new file.

**Related URS**: REQ-001-URS-F004

**Definition of Done**: tests compare the SHA-256 of the file attached with the bytes handed out, and with the bytes received; the file is private; a second e-invoice for the same sales invoice leaves the first one's file and bytes as they were (tests in a bench).

#### REQ-001-PRS-F006: The kept e-invoice protected

**Description**: Once its document is submitted, a kept e-invoice (REQ-001-PRS-F005) SHALL NOT be deletable, and once the document is cancelled, only by users who may delete the document. The app SHALL do this with Frappe's "Protect Attached Files", switched on for Sales Invoice and Purchase Invoice, which protects every attachment of a submitted invoice in this way. An administrator who switches the setting off in Customize Form takes the protection away; the app doesn't prevent it.

**Related URS**: REQ-001-URS-F004 | **Rationale**: Neither ERPNext 16 nor European e-Invoice protects an invoice's attachments (read on 2026-11-20); a document that belongs to a booked invoice stays with it. What no app can stop, access to the server or the database, the company's process documentation under GoBD covers.

**Definition of Done**: deleting the kept e-invoice of a submitted sales invoice and of a submitted purchase invoice is refused, for the Administrator too; once the sales invoice is cancelled, a user without delete permission on it is refused and one with it may delete the file (tests in a bench).

## PRS — Non-Functional

#### REQ-001-PRS-NF001: Numbers with ERPNext's precision

**Description**: A number SHALL reach the model as a `Decimal` with the value ERPNext keeps for it, at the field's precision (`19.99` as `Decimal("19.99")`, not the float's binary expansion). A number from the model SHALL be stored only when the field's precision keeps it as it is; one with more decimal places than the field keeps SHALL be reported, naming the business term and the field, and SHALL NOT be stored rounded without it.

**Related URS**: REQ-001-URS-NF001

**Definition of Done**: tests map amounts such as `0.1`, `19.99` and `1234567.89` and a quantity of `2.5` to the model and compare them as strings; a unit price of `1.2345` in the model, for a rate field that keeps two places, is reported with its business term and field (tests).

#### REQ-001-PRS-NF002: Permissions

**Description**: Every action the app offers on a document, such as creating, downloading or receiving an e-invoice, SHALL check the user's ERPNext permission on that document first and SHALL refuse it without that permission: reading the document to download its e-invoice, submitting a sales invoice to create one, creating a purchase invoice to receive one. The kept e-invoice is readable only through the document's permissions (REQ-001-PRS-F005).

**Related URS**: REQ-001-URS-NF002

**Definition of Done**: for each action, a test with a user without the permission gets a permission error and no e-invoice; Frappe's semgrep rules in CI report no whitelisted method without a permission check (tests in a bench; CI report).

#### REQ-001-PRS-NF003: Install and uninstall

**Description**: Installing the app on a site with ERPNext SHALL change no existing document, and SHALL switch on the protection of attachments REQ-001-PRS-F006 names; that it needs nothing beside the bench is [ADR-001](../arc42/adr/ADR-001-a-frappe-app.md)'s. Uninstalling it SHALL leave ERPNext's sales and purchase invoices working, and the kept e-invoices attached (REQ-001-PRS-F005), and SHALL restore ERPNext's setting for the protection of attachments.

**Related URS**: REQ-001-URS-NF003

**Definition of Done**: in CI, the app is installed into a new site with ERPNext, a sales invoice is created and submitted, the app is uninstalled, and the sales invoice opens and a new one is submitted, with the kept e-invoice still attached; "Protect Attached Files" is on for Sales Invoice and Purchase Invoice while the app is installed and back to ERPNext's setting after it is uninstalled (test in a bench).

## Acceptance Criteria

- Every business term comes from a stored value or a derivation a spec names; none from a guess or a default.
- Currency, country, unit and VAT category codes come from ERPNext's records and the operator's assignments; a VAT category never from the rate.
- Numbers pass with ERPNext's precision, neither rounded nor extended; what ERPNext can't keep is reported.
- Every refusal and finding, Haflinger's and the app's, is shown on its document, with the field and row where the mapping knows them.
- Every e-invoice handed out or received is attached to its document, private and byte for byte, never overwritten, and not deletable once the invoice is submitted.
- No user gets or creates an e-invoice for a document ERPNext doesn't let them use so.
- The app installs and uninstalls like any app, and ERPNext's invoices work after it is removed.

## Assumptions

- ERPNext 16's unit of measure can hold a UN/ECE code (its Common Code field); to be checked against ERPNext 16 before REQ-001-PRS-F002 is built.
- Assigning VAT categories to templates covers the companies the app serves; a company whose VAT category depends on the customer rather than the template chooses the template by ERPNext's tax category, as it already does for the rates.
- The checks of an invoice's content under German VAT law that the official rules leave to XRechnung (§14(4) UStG), such as the time of supply (BT-72, BG-14), come from Haflinger, as an optional check the caller runs on incoming and outgoing invoices; it is requested there as HAFL-ITEM-010, where whether it runs KoSIT's German rules on the XML or rules of Haflinger's own on the model, and so what its findings look like, is still open. The values it checks come from the mapping (REQ-002, REQ-003), and what a finding means is REQ-002's for an outgoing invoice and REQ-003's for an incoming one.
- Haflinger hands out no code lists: the operator enters the codes of REQ-001-PRS-F002 and REQ-001-PRS-F003 as text, and the official rules check them when Haflinger writes or validates the invoice, so that a wrong code reaches the operator as a finding (REQ-001-PRS-F004). Should Haflinger later hand out the official lists, the app may offer only valid codes.

## Open Questions

None at present.
