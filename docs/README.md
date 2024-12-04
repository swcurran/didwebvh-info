
The `did:webvh` DID Method (`did:web` + Verifiable History) was developed with the aim of enabling greater trust and security 
than `did:web` without compromising the simplicity of `did:web`.
Core features of the `did:webvh` method that complement `did:web` include:

- **DID-to-HTTPS transformation** that is the same as `did:web`.
- **A Verifiable History**: The ability to resolve the full history of the DID using a verifiable chain of
  updates to the DIDDoc from genesis to deactivation.
- **A Self-Certifying Identifier (SCID)**: The SCID, globally unique and
  embedded in the DID, is derived from the initial DID log entry. It ensures the integrity
  of the DID's history mitigating the risk of attackers creating a new object with
  the same identifier.
- **Authorized Keys**: DIDDoc updates contain a proof signed by the DID Controllers *authorized* to
  update the DID.
- **Pre-rotation Keys** (optional): The mechanism for publishing pre-rotation keys prevents the loss of
  control of a DID in cases where an active private key is compromised.
- **Witnesses** (optional): The mechanism for having witnesses enables the collaborative
  approval of updates to the DID by a DID Controller before publication.
- **DID Portability** (optional): The mechanism for enabling portability allows
  the DID's web location to be moved and the DID string to be updated, both while retaining
  a connection to the predecessor DID(s) and preserving the DID's verifiable history.

In addition, the `did:webvh` method supports:

- **A DID URL path handling** that defaults (but can be overridden) to automatically
  resolving `<did>/path/to/file` by using a comparable DID-to-HTTPS translation
  as for the DIDDoc.
- **A DID URL path `<did>/whois`** that defaults to automatically returning (if
  published by the [[ref: DID controller]]) a [[ref: Verifiable Presentation]]
  containing [[ref: Verifiable Credentials]] with the DID as the
  `credentialSubject`, signed by the DID. It draws inspiration from the
  traditional WHOIS protocol [[spec:rfc3912]], offering an easy-to-use,
  decentralized, trust registry.
- **[High Assurance DIDs with DNS] mechanism** that is the same as used for `did:web`.

[High Assurance DIDs with DNS]: https://datatracker.ietf.org/doc/draft-carter-high-assurance-dids-with-dns/

The `did:webvh` specification and based on it, the implementer's guide, were developed in parallel with the development of two
proof of concept implementations. The specification/implementation interplay
helped immensely in defining a practical, intuitive, straightforward, DID
method. The existing implementations of the `did:webvh` DID
Method are listed in the [Implementers Guide](./implementers-guide/README.md). The current
implementations range from around 1500 to 2000 lines of code.

An example of a `did:webvh` evolving through a series of versions can be seen in
the [did:webvh Examples](./example.md) included on this site.
