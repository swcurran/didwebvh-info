# What Are A DID's Valid Keys?

## Problem Statement

We want the following all to be supported by DIDs in general, and `did:Webvh` DIDs in particular.

- DIDs to last a long time (decades).
- To be able to verify signatures on old documents.
- To be able to flag/prevent the use of known compromised keys for verification.
- Regularly rotate to new signing keys.

What is the best way to indicate in `did:webvh` that a key is _valid_ for use in verifying signature, even if it is no longer being used to create new signatures? Related, what is the best way to indicate that a key is _invalid_ and **SHOULD NOT** be used for verifying a signature, and that a document containing a signature signed by that key should be discarded?

Given that in `did:webvh`, it is easy to get the full history of the DIDs, and all the keys that have been in all versions of the DIDDoc, do we need to have all the valid keys in the current DIDDoc?

This article explores these questions.

## Best Practices: Current state of DID Document represents all valid keys

The current state of the DID Document **MUST** reflect all valid keys.

Keys that are no longer valid **MUST** be promptly removed from the DID Document.

The DID Controller determines when keys are considered valid.

The DID Controller **SHOULD** establish policies that outline key rotation and expiration, according to best practices outlined by organizations like [OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html#27-secret-lifecycle).

The DID Controller **SHOULD** establish policies outlining key retention. Several factors influence key retention. The DID Controller should consider the following:

- Keys used to sign credentials (i.e. [Verification Methods referenced or declared in the Assertion Method Verification Relationship](https://www.w3.org/TR/did-core/#assertion)) directly impact the validity of those credentials; if the key is not found in the Issuer's DID Document, the credential will fail verification. The frequency of key rotation and expiration may limit holder's ability to use these credentials.
- Keys used for other purposes ([Authentication](https://www.w3.org/TR/did-core/#authentication), [Key Agreement](https://www.w3.org/TR/did-core/#key-agreement), [Capability Invocation](https://www.w3.org/TR/did-core/#capability-invocation), [Capability Delegation](https://www.w3.org/TR/did-core/#capability-delegation)) may be rotated more frequently without negatively impacting holders of credentials issued by the DID Controller.

Key rotation, expiration, and retention policies are opaque to entities resolving the DID Document; all changes are enacted using standard CRUD operations by the DID Controller and the final state reflects the set of currently valid keys. Out-of-band key revocation checks **MUST NOT** be required.

## Example

Consider a DID Controller that has a key rotation policy dictating that keys used for signing credentials are rotated annually and rotated keys are retained for a minimum of 5 years unless compromised. The current state of the DID Document's `assertionMethod` verification relationship would typically include 5 keys:

- the current key to be used for issuance,
- as well as the keys used for the previous 4 years,
- excepting any that had been compromised and removed before expiration.

The DID Controller also has a key rotation policy dictating that keys used for authentication are rotated every 90 days and are expired immediately upon rotation. The current state of the DID Document's `authentication` verification relationship would include only the current key.

## Reasoning

`did:webvh` (along with other DID Methods with a verifiable history) has the ability to resolve the state of a DID Document at a point in the past. It is tempting to use this ability to provide point-in-time key references when signing credentials, enabling a credential signed by that key to be valid indefinitely while also not needing to worry about keeping that key in the current state of the DID Document. However, this point-in-time resolution provides no data about whether the validity of the key has changed since that point in time. The DID Controller would have to rewrite the history of the DID Document to annotate the key as revoked or provide some alternate, out-of-band mechanism for checking for revoked keys.

This point-in-time key reference creates a false positive by default during credential verification; a naive verifier would resolve the key material and "successfully" verify the credential without realizing that the key is potentially in the hands of an impersonator or is otherwise unfit for use. This places the burden of checking for up-to-date information on the verifier while also introducing additional complexity for both the issuer and the verifier.

!!! note
    It is possible that `did:webvh` specification **could** specify that a key defined in an earlier DID version is revoked, requiring that any attempt to resolve that key (by `versionId` and `#fragment`) return a suitable error (e.g., `KEY-REVOKED`). The burden is still on the resolver to check for revocation, and only non-compliant resolvers would be a problem.

Using the current state of the DID Document to reflect all valid keys, by contrast, creates a false negative by default; a naive verifier cannot verify a credential that does not have key material present in the current state of the DID Document. This false negative by default is the safer approach, effectively eliminating the possibility that the verifier may have used compromised key material to verify a credential. This places the burden of providing up to date information on the issuer, which is the most suitable party to be responsible for it.

!!! note
    The impact of this requirement is that despite having the full history of the DID, we have to repeat the (growing) list of valid keys in each DID version, making the DID Log much larger. The DID Log would be smaller if we had a method of defining the key once and revoking it when necessary. At this time, we don't have that mechanism. The discussion [below](#potential-future-optimization) of using JSON Patch could mitigate the DID Log size issue.

However, the verifier still has the ability to incorporate historical data; upon finding that the credential failed to verify with the current set of keys, a sophisticated verifier can look up the state of the DID Document at the point-in-time at which the credential was issued (or some other relevant time frame). The verifier can use this additional information to make more nuanced decisions about the result of the presentation and how to act on it.

## Potential Future Optimization

Previous versions of the `did:webvh` used JSON Patch to construct a DID Document by layering changes. The intent was to keep the size of the history down. It was later decided that this was an unneeded optimization. Several examples of DID Documents were examined and it was found that just using the full state of the DID Document rather than using JSON Patches was often smaller.

While taking into account the need for key rotation and the practices outlined here, we may find need to optimize for size again in the future by reintroducing JSON Patch.
