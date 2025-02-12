# Implementing a `did:webvh` Resolver

This article summarizes the process that a `did:webvh` resolver might use in a processing a `did:webvh` DID. The process covers both the [DID Log File](https://identity.foundation/didwebvh/#the-did-log-file) processing, as well as the processing of the [DID Witness Proofs file](https://identity.foundation/didwebvh/#the-witness-proofs-file) (if applicable). This article is not a specification, and there is no requirement for a `did:webvh` to follow this approach. It is provided to help those beginning a registrar/resolver implementation to navigate the specification (links into the specification are embedded in the algorithm) using the experience of those that have gone before. Updates to the algorithm are welcome (via [Issues](https://github.com/decentralized-identity/didwebvh-info/issues) or [PRs](https://github.com/decentralized-identity/didwebvh-info/pulls)) from implementers wanting to make life easier for those who will follow.

This approach draws heavily from the [`did:webvh` Python implementation at DIF](https://github.com/decentralized-identity/didwebvh-py).

The verification passes below may be interleaved. In particular, the `did:webvh` Python implementation collects log entry proofs and verifies them in a thread pool in the background while doing the primary verification. Witness log retrieval could be performed when the first `witness` rule is seen in the DID Log.

## Primary verification

- Fetch `did.jsonl` ([Spec Ref](https://identity.foundation/didwebvh/#the-did-to-https-transformation)). If not found, abort (`error=notFound`).
- For each entry in the history log:
  - Perform preliminary checks:
    - Check the entry is a valid JSON object with only the required properties. ([Spec Ref](https://identity.foundation/didwebvh/#the-did-log-file))
    - If it is the first entry, check the SCID derivation. ([Spec Ref](https://identity.foundation/didwebvh/#scid-generation-and-verification))
    - Check the derivation of the entry hash and the sequencing of the version number. ([Spec Ref](https://identity.foundation/didwebvh/#entry-hash-generation-and-verification))
    - Verify the DIDDoc ID contains the SCID.
    - Verify the type, value, and validity (allowed or not) of the parameters in the Log Entry. ([Spec Ref](https://identity.foundation/didwebvh/#didwebvh-did-method-parameters))
  - If preliminary checks fail:
    - Set `INVALID=true`.
    - Move to the next verification phase.
  - If a specific `versionId` is specified:
    - If the requested `versionId` equals the current entry's `versionId`:
      - If a specific `versionTime` is requested and is less than the entry's `versionTime`, abort (`error=notFound`) - cannot reconcile `versionId` and `versionTime`.
      - Set `FOUND` to the current entry.
  - If a specific `versionTime` is requested and a specific `versionId` is not requested:
    - If the current entry's `versionTime` <= `versionTime`:
      - Set `FOUND` to the current entry.
  - If the current entry updates the parameters ([Spec Ref](https://identity.foundation/didwebvh/#did-method-processes)) `updateKeys`, `nextKeyHashes`, or `witness`:
    - Add the entry to `AUTH_ENTRIES`.
  - If the `witness` parameter is non-null and the `threshold` is non-zero ([Spec Ref](https://identity.foundation/didwebvh/#did-witnesses)):
    - Add `(versionNumber, witness)` to `WITNESS_CHECKS`.
  - If the previous value of `witness` was non-null and different from `witness`:
    - Add `(versionNumber, prevWitness)` to `WITNESS_CHECKS`.
  - Add the current entry's `versionId` to `CHECKED`.
  - Set `LATEST` to the current entry.

## Proof verification

- If `LATEST` is not set, abort (`error=invalidDid`) - no entries.
- If `FOUND` is not set:
  - If `INVALID`, abort (`error=invalidDid`) - latest version is needed, but verification short-circuited.
  - If a specific `versionId` or `versionTime` is requested, abort (`error=notFound`).
  - Set `FOUND=LATEST`.
- Add `FOUND` to `AUTH_ENTRIES`.
- For each entry in `AUTH_ENTRIES`:
  - Check the associated entry proof(s). There must be at least one valid proof from an active update key. (Define active keys) ([Spec Ref](https://identity.foundation/didwebvh/#authorized-keys))
  - If no valid proof is found, abort (`error=invalidDid`).

## Witness verification

- If `WITNESS_CHECKS` is not set, then skip to next verification phase.
- Fetch `did-witness.json`. If not found, abort (`error=invalidDid`). ([Spec Ref](https://identity.foundation/didwebvh/#the-witness-proofs-file))
- For each proof in the log:
  - Check the `versionId` is set and is in `CHECKED`, otherwise skip.
  - Check the validity of the proof, otherwise skip.
  - Extract the version number from the `versionId`.
  - Add `(versionNumber, witnessId)` to `WITNESS_VALID`.
- For each `(versionNumber, rule)` in `WITNESS_CHECKS`:
  - Check the witness rule against `WITNESS_VALID`. Each entry with a later `versionNumber` and one of the requested witness IDs may add to the weight. (Don't count multiple proofs from the same witness ID.)
  - If the threshold of a rule is met, remove it from `WITNESS_CHECKS`. ([Spec Ref](https://identity.foundation/didwebvh/#the-witness-parameter))
- If any values remain in `WITNESS_CHECKS`, abort `(error=invalidDid)`.

## Final checks

- For the resolved entry `FOUND`, check that the ID of the document matches the resolution target.
  - If not, abort (`error=notFound`).
- Add implicit services (`#files` / `#whois`) to the DID document as needed. ([Spec Ref Files](https://identity.foundation/didwebvh/#did-url-path-resolution-service)), ([Spec Ref Whois](https://identity.foundation/didwebvh/#whois-linkedvp-service))
- Perform dereferencing if necessary.
- If `INVALID` is set, add (TBD) to the resolution metadata. Adjust the internal TTL to the standard 'verification failure' TTL.

TODO: define caching behavior
