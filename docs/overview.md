The emergence of [Decentralized Identifiers](https://www.w3.org/TR/did-core/)
(DIDs) and with them the evolution of [DID
Methods](https://decentralized-id.com/web-standards/w3c/decentralized-identifier/did-methods/)
continues to be a dynamic area of development in the quest for trusted, secure
and private digital identity management where the users are in control of their
own data.

The [`did:web` method](https://w3c-ccg.github.io/did-method-web/) leverages the
Domain Name System (DNS) to perform the DID operations. This approach is praised
for its simplicity and ease of deployment, including DID-to-HTTPS transformation
and addressing some aspects of trust by allowing for DIDs to be associated with
a domain's reputation or published on platforms such as GitHub. However, it is
not without its challenges-- from trust layers inherited from the web and the
absence of a verifiable history for the DID.

Tackling these concerns, the proposed `did:tdw` (Trust DID Web)
method aims to enhance `did:web` by introducing features such
as a self-certifying identifiers (SCIDs), update key(s)
and a verifiable history, akin to what is available with ledger-based DIDs,
but without relying on a ledger.

This approach not only maintains backward compatibility with `did:web` but also offers an
additional layer of assurance for those requiring more robust verification
processes. By publishing the resulting DID as both `did:web` and `did:tdw`, it
caters to a broader range of trust requirements, from those who are comfortable
with the existing `did:web` infrastructure to those seeking greater security
assurances provided by `did:tdw`. This innovative step represents a significant
stride towards a more trusted and secure web, where the integrity of
cryptographic key publishing is paramount.

The key differences between `did:web` and `did:tdw` revolve around the core
issues of decentralization and security. `did:web` is recognized for its
simplicity and cost-effectiveness, allowing for easy establishment of a
credential ecosystem. However, it is not inherently decentralized as it relies
on DNS domain names, which require centralized registries. Furthermore, it lacks a
cryptographically verifiable, tamper-resistant, and persistently stored DID
document. In contrast, `did:tdw` is proposed as an enhancement
to `did:web`, aiming to address these limitations by adding a verifiable history
to the DID without the need for a ledger. This method seeks to provide a more
decentralized approach by ensuring that the security of the embedded
SCID does not depend on DNS. Additionally, `did:tdw` is
capable of resolving a cryptographically verifiable trust registry and status
lists, using DID-Linked Resources, which `did:web` lacks. These features are
designed to build a trusted web, offering a higher level of assurance for
cryptographic key publishing and management.

For backwards compatibility, and for verifiers that "trust" `did:web`, a
`did:tdw` can be trivially modified and published in parallel to a `did:web`
DID. For resolvers that want more assurance, `did:tdw` provides a way to "trust
did:web" (or to enable a "trusted web" if you say it fast) enabled by the
features listed in the [introduction](./README.md).

The following is a `tl;dr` summary of how `did:tdw` works:

1. `did:tdw` uses the same DID-to-HTTPS transformation as `did:web`, so
   `did:tdw`'s  `did.jsonl` (JSON Lines) file is found in the same
   location as `did:web`'s `did.json` file, and supports an easy transition
   from `did:web` to gain the added benefits of `did:tdw`.
2. The `did.jsonl` is a list of JSON DID log entries, one per line,
   whitespace removed (per JSON Lines). Each entry contains the
   information needed to derive a version of the DIDDoc from its preceding
   version. The `did.jsonl` is also referred to as the DID Log.
3. Each DID log entry is a JSON object containing the following properties:
    1. `versionId` -- a value that combines the version number
       (starting at `1` and incremented by one per version), a literal dash
       `-`, and a hash of the entry. The entry hash calculation links each entry
       to its predecessor in a ledger-like chain.
    2. `versionTime` -- as asserted by the DID Controller.
    3. `parameters` -- a set of parameters that impact the processing of the current and
      future log entries.
        - Example parameters are the version of the `did:tdw` specification and
        hash algorithm being used as well as the SCID and update key(s).
    4. `state` -- the new version of the DIDDoc.
    5. A Data Integrity (DI) proof across the entry, signed by a [[ref:
      DID Controller authorized key to update the DIDDoc, and optionally,
      a set of witnesses that monitor the actions of the DID Controller.
4. In generating the first version of the DIDDoc, the DID
  Controller calculates the SCID for the DID from the first [[ref:
  log entry (which includes the DIDDoc) by using the string
  `"{SCID}"` everywhere the actual SCID is to be placed. The DID
  Controller then replaces the placeholders with the calculated SCID,
  including it as a `parameter` in the first log entry, and inserting
  it where needed in the initial (and all subsequent) DIDDocs. The SCID
  enables an optional portability capability, allowing a DID's web
  location to be moved, while retaining the DID and version history of the DID.
1. A DID Controller generates and publishes the new/updated DID Log file by making it
  available at the appropriate location on the web, based on the identifier of the
  DID.
1. Given a `did:tdw` DID, a resolver converts the DID to an HTTPS URL,
  retrieves, and processes the DID Log `did.jsonl`, generating and verifying
  each log entry as per the requirements outlined in this specification.
    - In the process, the resolver collects all the DIDDoc versions and public
      keys used by the DID currently, or in the past. This enables
      resolving both current and past versions of the DID.
1. `did:tdw` DID URLs with paths and `/whois` are resolved to documents
  published by the DID Controller that are by default in the web location relative to the
  `did.jsonl` file. See [did/whois](./whois.md) for more about the
   powerful use cases enabled by the `/whois` DID URL path.
1. Optionally, a DID Controller can easily generate and publish a `did:web` DIDDoc
  from the latest `did:tdw` DIDDoc in parallel with the `did:tdw` DID Log.

  ::: warning
    A resolver settling for just the `did:web` version of the DID does not get the
    verifiability of the `did:tdw` log.
  :::

An example of a `did:tdw` evolving through a series of versions can be seen in
the [did:tdw Examples](./example.md) included on this site.

The specification was developed in parallel with the development of two
proof of concept implementations. The specification/implementation interplay
helped immensely in defining a practical, intuitive, straightforward, DID
method. The existing proof of concept implementations of the `did:tdw` DID
Method are listed in the [Implementers Guide](./implementers-guide/README.md). The current
implementations range from around 1500 to 2000 lines of code.
