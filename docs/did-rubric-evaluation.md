# `did:webvh` Rubric Evaluation

**DID Method**: [`did:webvh`](https://identity.foundation/didwebvh/)  
**Specification Version**: 1.0  
**Evaluation Date**: 2025-05-15  
**Maintainers**: [didwebvh.info](https://didwebvh.info)  
**Rubric Reference**: [W3C DID Rubric](https://www.w3.org/TR/did-rubric/)

This document provides an evaluation of the `did:webvh` method against the categories in the [W3C DID Rubric](https://www.w3.org/TR/did-rubric/), to help implementers and evaluators understand its design choices and trade-offs.

## Identifier Creation

`did:webvh` identifiers are deterministic and can be created by any party that can publish static files at a known location accessible via HTTPS or equivalent. While typically hosted on a web domain, `did:webvh` DIDs can also be published on platforms that support deterministic file URLs—such as GitHub Pages, Google Cloud Storage, or other web-accessible file hosts—without requiring server-side logic or blockchain infrastructure.

While domain names do require registration from an authority (i.e., a domain registrar), the process is open and permissionless in the sense that any individual or organization can acquire a domain and publish a DID without requiring approval from a centralized identity authority. The creation of a `did:webvh` identifier is therefore permissionless in practice, as long as the entity controls a hosting location capable of serving content over HTTPS.

## Identifier Update

Updates to the DID are recorded as append-only entries in the DID Log. Each log entry is signed, includes the updated DID Document (DIDDoc), and is cryptographically linked to the previous entry via a hash chain. Only keys authorized in DID Log can produce valid updates. Versioning is explicit and verifiable.

## Identifier Deactivation

`did:webvh` supports two deactivation mechanisms:

1. **Removal-based deactivation**: The DID Controller can deactivate a DID by removing the DID Log and associated resources from the hosting location. In this case, resolution attempts will return a `notFound` error. This method fully removes the DID’s presence from the domain.

2. **Log-based deactivation**: Alternatively, the DID Controller may create a new DID Log entry that marks the DID as explicitly `"deactivated"`. This entry becomes the final entry in the verifiable log history, allowing the DID to remain resolvable in a verifiable but deactivated state. This preserves historical access and auditability while preventing further updates.

In both cases, independent Watchers may retain cached versions of the DID and its final state, allowing clients and relying parties to reference historical data even after deactivation.

## Persistence

`did:webvh` DIDs are designed for long-term use. By default, their persistence is tied to the lifetime of the hosting domain, which is often measured in decades for institutions, governments, and stable organizations.

However, persistence is significantly enhanced by the inclusion of **Watchers**—independent parties or services that monitor, cache, and verify the full DID history. Watchers enable the DID’s state to survive even if the original hosting infrastructure becomes unavailable, allowing verifiable resolution to continue long after a domain has expired or content has been removed.

In addition, features like:

- an append-only verifiable DID Log,
- cryptographic linking of updates, and
- optional portability between domains

all contribute to ensuring that a `did:webvh` identifier can outlive any single deployment environment. Watchers serve as decentralized anchors for long-lived trust and historical resolution.

## Resolution

`did:webvh` DID resolution uses a similar [DID-to-HTTPS transformation](https://identity.foundation/didwebvh/#the-did-to-https-transformation) to `did:web`. A resolver fetches the DID Log from the corresponding HTTPS location, verifies the cryptographic integrity and signatures of each entry, and constructs the current or requested version of the DID Document.

Each update to the DID is recorded in an append-only log, forming a cryptographically linked history of changes. Resolvers validate each link in the chain, ensuring the integrity of the DID over time.

## DID URL Resolution

`did:webvh` supports full DID URL path resolution using a well-defined implicit service. By default, the DID Document includes an implicit `relativeRef` service with `id: "#files"`, whose `serviceEndpoint` matches the transformed HTTPS base of the DID. This allows DID URLs like `did:webvh:<SCID>:example.com/policies/privacy.pdf` to behave analogously to `https://example.com/policies/privacy.pdf`.

Resolvers must apply this default service when no explicit `#files` service is defined. This mechanism provides a simple, web-native model for resolving documents or resources under the domain. A DID Controller may override by explicitly defining the service in the DIDDoc.

In addition, `did:webvh` defines a special `#whois` implicit service for resolving `/<did>/whois`, which returns a Verifiable Presentation—if published—containing Verifiable Credentials about the DID Controller. The mechanism is based on the [DIF](https://identity.foundation) [Linked Verifiable Presentation](https://identity.foundation/linked-vp/) specification. As with the `#files`
service, the implicit `#whois` service can also be overridden by a service explicitly defined in the DIDDoc.

## Metadata

`did:webvh` resolution returns rich metadata aligned with the DID Resolution specification. This includes:

- The version of the resolved DID Document
- Verification status of the DID Log and proofs
- Status indicators such as whether the DID is active, deactivated, or has been removed
- References to published Watchers (if included in the log)
- Timestamps and SCID references tied to the returned version

The `didResolutionMetadata` object may also include structured error details (via `problemDetails`) in case of resolution failure, helping clients distinguish between a non-existent DID, a deactivated one, or an invalid state. This clarity supports better error handling and trust decisions.

## Cryptographic Agility

Cryptographic agility is built into the design of `did:webvh`:

- Hashes use the [multihash](https://multiformats.io/multihash/) format, allowing the algorithm used to be self-describing.
- Signatures follow the [Data Integrity](https://www.w3.org/TR/vc-data-integrity/) specification, with the algorithm identified via the `cryptosuite` property.
- Verification methods use the [multikey](https://w3c-ccg.github.io/multikey/) format, enabling algorithm-independent public key representation.
- The `method` parameter in the DID Log specifies the version of the `did:webvh` specification being used.
- Each version of the `did:webvh` specification defines a fixed list of permitted cryptographic algorithms and suites.
  - Version 1 permits the use of the `eddsa-jcs-2022` cryptographic suite for signatures (using `ed25519` keys) and SHA2-256 for hashing.
- DID Controllers can migrate to newer cryptographic policies by updating the `method` field in a new log entry, referencing a newer version of the specification.
- Future versions will extend support to additional signature suites and hash algorithms, enabling continuous evolution without breaking compatibility with prior entries.

## Privacy

`did:webvh` is public by design. All resolution activity occurs over HTTPS and may be visible to the hosting server or CDN. There is no native unlinkability or correlation resistance. DID Controllers and resolvers should avoid publishing identifying information unless intended.

## Equivocation Protection

`did:webvh` provides strong protection against equivocation through a cryptographically linked, append-only DID Log. Each update includes a reference to the previous log entry, forming a tamper-evident chain. Resolvers verify the entire history of updates, ensuring consistency from genesis to the current state.

Two optional components strengthen equivocation resistance:

- **Witnesses**: A DID Controller may require that updates be co-signed by a quorum of independent witnesses. This makes it significantly harder for a malicious or compromised controller to publish conflicting updates without detection.
- **Watchers**: Independent observers can monitor DIDs over time, cache verified states, and detect re-published or rewritten logs with altered history.

These technical features enable ecosystems to layer verifiable governance on top of `did:webvh`. For example, trust frameworks or registries can define who is allowed to act as a witness, how Watchers reach consensus, or how policy violations are detected or responded to.

## Portability

`did:webvh` supports **optional portability**, allowing a DID to be moved from one domain or hosting location to another while preserving continuity. When portability is enabled in the DID Log, the Controller can publish a new log at a new HTTPS location that references the previous SCID and log chain, forming a cryptographically verifiable lineage between the old and new identifiers.

This mechanism enables both:

- **Institutional portability** — for example, moving a domain from `example.edu` to `examplefoundation.org`, while preserving all DID history and cryptographic guarantees.
- **Personal portability** — such as an individual migrating their DID from one identity platform (e.g., a wallet or hosted service) to another, while retaining control and the full audit history of their original DID.

Resolvers can follow the portability chain to verify that the current DID is a valid successor of the original, preserving trust and data associations across platforms or infrastructure changes.

In addition, `did:webvh` **Watchers** support portability by indexing DIDs by their self-certifying identifier (SCID). This allows a resolver to query a Watcher using the SCID and retrieve the DID's current or historical state—regardless of whether the DID has been moved -- or removed. This enables decentralized resolution and persistence even in cases where the original location is no longer available.

## Interoperability

`did:webvh` is fully aligned with the [DID Core specification](https://www.w3.org/TR/did-core/) and interoperates with standard Web infrastructure. It supports:

- The W3C Verifiable Credentials Data Model (VCDM)
- [Data Integrity proofs](https://www.w3.org/TR/vc-data-integrity/) for signing DID Documents
- HTTPS-based resolution and hosting
- DID URLs, including query parameters and path resolution
- The [Linked Verifiable Presentation](https://identity.foundation/linked-vp/) format for publishing assertions about the DID Controller (via resolving `<did>/whois`)

Importantly, `did:webvh` places **no constraints on the contents of the DID Document** beyond the general requirements of DID Core. This allows Controllers to structure their DIDDocs to suit a wide range of use cases, cryptographic suites, service types, and interoperability profiles—such as DIDComm, OIDC4VP, ISO mDL linkage, or custom trust registries.

To support compatibility with existing DID resolution infrastructure, DID Controllers may also publish a parallel `did:web` identifier that references the latest version of the `did:webvh` DID Document. This allows systems that only support `did:web` to continue resolving the identifier while benefiting from the extended capabilities of `did:webvh`. The `did:webvh` specification explicitly supports this dual-publication model as a transitional interoperability pattern.

This flexibility makes `did:webvh` an ideal foundation for integrating decentralized identifiers into existing platforms, without imposing new protocol or governance assumptions.

## Availability

DIDs are as available as the hosting web server. Redundancy and survivability can be extended via `did:webvh` (or independent) Watchers, which provide hosting of the data needed to resolve the DID and DID URLs. Resolvers may be configured to consult Watchers if the authoritative domain is down or unreachable.

## Cost and Complexity

Operational cost is low. No blockchain or ledger infrastructure is required. The primary implementation complexity lies in managing the DID and its associated keys. Additional, though generally lower, complexity comes from maintaining the DID Log, handling versioned documents, and coordinating optional features like Witnesses and Watchers. Overall, the method is well suited for web-native deployments and can be adopted incrementally with minimal infrastructure.

## Human-Readability

Partially human-readable. The domain portion of the DID is familiar and user-friendly. The embedded SCID (self-certifying identifier) is not human-readable but provides cryptographic integrity and uniqueness. Overall, `did:webvh` balances familiarity and security.

## Versioning

This rubric applies to version 1.0 of the `did:webvh` specification. Later versions may extend functionality (e.g., additional cryptographic suites, more flexible portability policies, or enhanced service definitions).
