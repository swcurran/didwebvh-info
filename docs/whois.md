# The `/whois` Use Case

This DID Method introduces what we hope will be a widely embraced convention for
all DID Methods -- the `/whois` path. This feature harkens back to the `WHOIS`
protocol that was created in the 1970s to provide a directory about people and
entities in the early days of ARPANET. In the 80's, `whois` evolved into
[RFC920](https://www.rfc-editor.org/rfc/rfc920) that has expanded into the [global
whois](https://en.wikipedia.org/wiki/WHOIS) feature we know today as
[RFC3912](https://www.rfc-editor.org/rfc/rfc3912). Submit a `whois` request about a domain name, and get
back the information published about that domain.

We propose that the `/whois` path for a DID enable a comparable, decentralized,
version of the `WHOIS` protocol for DIDs. Notably, when `<did>/whois` is
resolved (using a standard DID `service` that follows the Linked-VP
specification), a Verifiable Presentation (VP) may be returned (if
published by the DID Controller) containing Verifiable Credentials with
the DID as the `credentialSubject`, and the VP signed by the DID. Given a DID,
one can gather verifiable data about the DID Controller by resolving
`<did>/whois` and processing the returned VP. That's powerful -- an efficient,
highly decentralized, trust registry. For `did:tdw`, the approach is very simple
-- transform the DID to its HTTPS equivalent, and execute a `GET <https>/whois`.
Need to know who issued the VCs in the VP? Get the issuer DIDs from those VCs,
and resolve `<issuer did>/whois` for each. This is comparable to walking a CA
(Certificate Authority) hierarchy, but self-managed by the DID Controllers --
and the issuers that attest to them.

The following is a use case for the `/whois` capability. Consider an example of
the `did:tdw` controller being a mining company that has exported a shipment and
created a "Product Passport" Verifiable Credential with information about the
shipment. A country importing the shipment (the Importer) might want to know
more about the issuer of the VC, and hence, the details of the shipment. They
resolve the `<did>/whois` of the entity and get back a Verifiable Presentation
about that DID. It might contain:

- A verifiable credential issued by the Legal Entity Registrar for the
  jurisdiction in which the mining company is headquartered.
  - Since the Importer knows about the Legal Entity Registrar, they can automate
    this lookup to get more information about the company from the VC -- its
    legal name, when it was registered, contact information, etc.
- A verifiable credential for a "Mining Permit" issued by the mining authority
  for the jurisdiction in which the company operates.
  - Perhaps the Importer does not know about the mining authority for that
    jurisdiction. The Importer can repeat the `/whois` resolution process for
    the issuer of _that_ credential. The Importer might (for example), resolve
    and verify the `did:tdw` DID for the Authority, and then resolve the
    `/whois` DID URL to find a verifiable credential issued by the government of
    the jurisdiction. The Importer recognizes and trusts that government's
    authority, and so can decide to recognize and trust the mining permit
    authority.
- A verifiable credential about the auditing of the mining practices of the
  mining company. Again, the Importer doesn't know about the issuer of the audit
  VC, so they resolve the `/whois` for the DID of the issuer, get its VP and
  find that it is accredited to audit mining companies by the [London Metal
  Exchange](https://www.lme.com/en/) according to one of its mining standards.
  As the Importer knows about both the London Metal Exchange and the standard,
  it can make a trust decision about the original Product Passport Verifiable
  Credential.

Such checks can all be done with a handful of HTTPS requests and the processing
of the DIDs and verifiable presentations. If the system cannot automatically
make a trust decision, lots of information has been quickly collected that can
be passed to a person to make such a decision.

The result is an efficient, verifiable, credential-based, decentralized,
multi-domain trust registry, empowering individuals and organizations to verify
the authenticity and legitimacy of DIDs. The convention promotes a decentralized
trust model where trust is established through cryptographic verification rather
than reliance on centralized authorities. By enabling anyone to access and
validate the information associated with a DID, the "/whois" path contributes to
the overall security and integrity of decentralized networks.
