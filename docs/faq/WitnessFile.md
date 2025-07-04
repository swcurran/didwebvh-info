# Why Have a Separate `witness.json` File in did:webvh?

Some developers new to `did:webvh` have asked: *Why not just include witness proofs directly in the `did.jsonl` log file?* After all, embedding them could eliminate the need for a second file, eliminate the second file retrieval, and simplify the witness threshold verification complexity. Instead, we keep the witness proofs in a separate `witness.json` file, and use that separation to "optimize" the file by keeping only one (or two) proofs from each witness on the assumption that a proof from witness implies approval from the witness of all previous log entries.

So in theory, we are trading off complexity in retrieval and processing to minimize the size and processing time of the witness proofs. What is impact of that tradeoff in practice? Is it worth it?  The article provides some real-world performance data to help answer that question.

Thanks to [Glenn Gore] of [Affinidi], we have a test case that simulates a 10-year enterprise `did:webvh` DID to see how the two approaches compare in practice.

[Glenn Gore]: https://www.linkedin.com/in/goreg/
[Affinidi]: https://affinidi.com

## Pros and Cons of Each Approach

| Approach | Pros | Cons |
|---------|------|------|
| **Embedding Witness Proofs in Log Entries** | - One less file to retrieve<br>- Allows "sign-as-you-go" witnessing | - Increases log file size<br>- Eliminates the ability to reduce witness proofs<br>- More proofs to validate |
| **Separate `witness.json` File** *(current approach)* | - Minimizes the number of witness proofs<br>- Smaller file size<br>- Fewer proofs to validate | - Requires a second file to be fetched<br>- Resolvers must implement more complex threshold calculation logic |

## Performance Test: Realistic 10-Year `did:webvh` DID

This is the same scenario as the [performance scenario] described in the [did:webvh Performance document], but with a focus on the impact of keeping witness proofs in a separate file.

- 120 Log Entries (~1 per month for 10 years)
- Keys rolled monthly using `nextKeyHash`
- Witness threshold of 3, from 4 witness nodes
- Witness node swapped annually
- Watcher node also rotated annually (offset by 6 months)

### With Optimized `witness.json` File

- `did.jsonl` size: **197 KB**  
- `witness.json` size: **5.9 KB**  
- Time to generate log entries: ~**50ms**  
- Time to validate the full DID history (including witness proofs): ~**28ms**

> ✅ **Total validation time: under 30ms** for 10 years of history — faster than many other high-trust DID methods.

### Keeping All Witness Proofs (Simulating Inlined Proofs)

What happens if we *don’t* optimize witness proofs — simulating the effect of embedding them in every log entry? Although this test keeps the separate `witness.json` file, we keep all proofs from each witness for every log entry. It's not good:

| Metric | With Optimization | Without Optimization | Impact |
|--------|-------------------|-----------------------|--------|
| `witness.json` size | **5.9 KB** ✅| **182 KB** | **~31× larger** |
| Reading witness proofs | **7.25ms** ✅| **104ms** | **~14× slower** |
| Proof validation time | **26.25ms** ✅| **77ms** | **~3× slower** |
| **Total validation time** | **37ms** ✅| **185ms** | **~5× slower** |

Glenn ran some additional tests with more witnesses, and the impact of the "all in the Log" solution was even more pronounced.

Note that in the timing, the cost to fetch the two files across the internet is not included. So reducing the count from 2 reads to 1 would be a win for the "all in one" solution. However, that would be offset by the size of the one file being so much larger than the two combined.

## Conclusion: Keeping `witness.json` Separate is a Win

While inlining witness proofs in `did.jsonl` might seem simpler, it comes at a steep cost in file size and performance — especially as DID histories grow and with more witnesses.

The current design, with a separate `witness.json` file:

- ✅ Enables significant optimization (95%+ smaller file)
- ✅ Dramatically improves validation speed (fewer proofs to verify)
- ✅ Keeps `did:webvh` lightweight and scalable — even over decades of updates

By decoupling witness proofs from the log entries, `did:webvh` retains the simplicity of `did:web` while adding scalable verifiability. It's a tradeoff that pays off.

[performance scenario]: ./Performance.md#scenario-an-enterprise-did-with-monthly-key-rotations
[did:webvh Performance document]: ./Performance.md#how-fast-is-didwebvh
