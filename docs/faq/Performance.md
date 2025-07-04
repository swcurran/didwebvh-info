# How Fast is did:webvh?

Performance is an important aspect of any DID method, especially for those that are designed to handle large-scale data and frequent updates. Since did:webvh requires processing the entire DID Log file to verify a DID during resolution, it is crucial to understand how this impacts performance in real-world scenarios. This document provides some insights into the performance characteristics of did:webvh. We plan to add more detailed benchmarks in the future.

## Scenario: An Enterprise DID With Monthly Key Rotations

> The following example was submitted by [Glenn Gore] of [Affinidi], and is based on the Affinidi did:webvh Rust implementation, listed on the [implementations] page. The test code will soon be available -- we'll add a link here when it is.

[Glenn Gore]: https://www.linkedin.com/in/goreg/
[Affinidi]: https://affinidi.com
[implementations]: ../implementations/README.md

### Test Parameters

- Enterprise has used did:webvh for 10 years
- They use pre-authorised keys for LogEntries
- They roll the keys every month, min 2 nextKeyHash
- They randomly swap a witness node every 12 months
  - Witness threshold: 3
  - Number of witnesses maintained @ 4 Nodes
- They randomly swap a watcher node every 12 months (offset by 6 months from the Witness Swap)

The above is trying to simulate a realistic enterprise production deployment of did:webvh with security constraints.

## Key results

- did.jsonl = 197kb in size (120 LogEntries)
- did-witness.json = 5.9KB in size (optimised)
- Generating 120 LogEntries and creating proofs etc: Average ~50ms
- Validating full did:webvh Log of 120 entries including full validation of Witness Proofs: Average ~28ms

## Conclusion

This is a very good performance result compared to other high-trust traceable DIDs. One can validate ~10 years of did:webvh history in under 30ms.
