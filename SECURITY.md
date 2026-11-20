# Security policy

Haflinger Saddle brings invoices into ERPNext and sends them out of it: incoming ones come from anyone, and what the app makes of them, and of outgoing ones, ends up in accounting. So we take reports about it seriously.

## Reporting a vulnerability

Report it privately through GitHub's private vulnerability reporting: [report a vulnerability](https://github.com/interlusion/haflinger-saddle/security/advisories/new) (the repository's Security tab). Please don't open a public issue, pull request or discussion for it.

A useful report says:

- the version of the app, or the commit for one installed from Git, and the versions of ERPNext, Frappe and Haflinger;
- what an invoice, or a user of ERPNext, makes the app do that it shouldn't, and how;
- the input that shows it, built with placeholders such as `Example GmbH`, never a real invoice: invoices hold names, addresses, bank details and amounts.

## Scope

In scope is what the app does in ERPNext, for example:

- **Outside input:** anything an incoming invoice or its attachments make ERPNext fetch, open, run or render; a file name from an invoice used as a path; an incoming invoice booked without a person's review.
- **Permissions:** a user reaching invoices, or creating or sending them, through the app beyond what ERPNext's roles allow.
- **Outgoing invoices:** an e-invoice that says something other than the ERPNext document it comes from, or a PDF handed out as ZUGFeRD that isn't PDF/A.

Out of scope:

- Haflinger, the library: how an invoice is read, validated or written, whatever ERPNext holds. Report it to [Haflinger](https://github.com/interlusion/haflinger/security/advisories/new).
- ERPNext, Frappe, Ghostscript and the other software the app runs with. Report those to their projects; tell us too where the app should guard against it.

## Supported versions

There is no release yet. Until the first, fixes go to `main`.

## What to expect

Haflinger Saddle is maintained on a best-effort basis: we answer and fix as soon as we can, without a promised time. There is no bounty. With your consent, the advisory credits you.
