The following covers the evolution of a `did:webvh` from inception through a second
DID log entry, showing the DID, DIDDoc, DID Log, and some of the
intermediate data structures. This example includes [witnesses] and an example `did-witnesses.json` file.

[witnesses]: https://identity.foundation/didwebvh/#did-witnesses

**The examples are aligned with Version 0.5 of the `did:webvh` specification.**

In some of the following examples the data for the DID log entries is
displayed as prettified JSON for readability. In the log itself, the JSON has
all whitespace removed, and each line ends with a `CR`, per the JSON
Lines convention.

### DID Creation Data

These examples show the important structures used in the [Create (Register)](https://identity.foundation/didwebvh/#create-register) operation for a `did:webvh` DID. The examples were generated from the `did:webvh` Python implementation. See [this folder](https://github.com/decentralized-identity/didwebvh-py/tree/main/sample-diddoc) in the Python implementation repository for the latest examples.

#### Input to the SCID Generation Process with Placeholders

The following JSON is an example of the input that the DID Controller
constructs and passes into the
[SCID Generation Process](https://identity.foundation/didwebvh/#scid-generation-and-verification). In this example, the DIDDoc is
particularly boring, containing the absolute minimum for a valid DIDDoc.

This example includes the initial "authorized keys" to sign the Data Integrity
proof (`updateKeys`), the pre-rotation commitment to the next authorization keys
(`nextKeyHashes`), and the DIDs that must witness the updates. All are in the
`parameters` property in the log entry.

```json
{
  "versionId": "{SCID}",
  "versionTime": "2025-04-01T17:39:50Z",
  "parameters": {
    "witness": {
      "threshold": 2,
      "witnesses": [
        {
          "id": "did:key:z6Mkkc51mg2vpQzKWAbWQZupeGYhowaBjYkmvcKMTqteqHB4",
          "weight": 1
        },
        {
          "id": "did:key:z6MkuDdJdKLCgwZuQuEi9xG6LVgJJ9Tebr74CXPYPSumqgJs",
          "weight": 1
        },
        {
          "id": "did:key:z6MkoSWmQyp4fTk4ZQy4KUsss9dFX51XfEUzKKKj1J1JUsrF",
          "weight": 1
        }
      ]
    },
    "updateKeys": [
      "z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr"
    ],
    "nextKeyHashes": [
      "QmZreDcjvWEpyRFznQeExWNCsvMLk5i59AcRJJuQC8UodJ"
    ],
    "method": "did:webvh:0.5",
    "scid": "{SCID}"
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:webvh:{SCID}:domain.example"
  }
}
```

#### Output of the SCID Generation Process

After the SCID is generated, the literal `{SCID}` placeholders are
replaced by the generated SCID value (see below). This JSON is the
input to the [`entryHash` generation
process](https://identity.foundation/didwebvh/#entry-hash-generation-and-verification) -- with the SCID used as the value of the 
`versionId`. Once the process has run, the version number of this first DID log entry
(`1`), a dash `-` and the resulting output hash will replace the
SCID as the `versionId` value in the published DID Log Entry.

```json
{
  "versionId": "QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE",
  "versionTime": "2025-04-01T17:39:50Z",
  "parameters": {
    "witness": {
      "threshold": 2,
      "witnesses": [
        {
          "id": "did:key:z6Mkkc51mg2vpQzKWAbWQZupeGYhowaBjYkmvcKMTqteqHB4",
          "weight": 1
        },
        {
          "id": "did:key:z6MkuDdJdKLCgwZuQuEi9xG6LVgJJ9Tebr74CXPYPSumqgJs",
          "weight": 1
        },
        {
          "id": "did:key:z6MkoSWmQyp4fTk4ZQy4KUsss9dFX51XfEUzKKKj1J1JUsrF",
          "weight": 1
        }
      ]
    },
    "updateKeys": [
      "z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr"
    ],
    "nextKeyHashes": [
      "QmZreDcjvWEpyRFznQeExWNCsvMLk5i59AcRJJuQC8UodJ"
    ],
    "method": "did:webvh:0.5",
    "scid": "QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE"
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example"
  }
}
```

#### Data Integrity Proof Generation and First Log Entry

The last step in the creation of the first log entry is the generation
of the data integrity proof. One of the keys in the `updateKeys` [[ref:
parameter **MUST** be the `verificationMethod` in the proof (in `did:key`
form) to generate the signature across the post-entryHash processed
DID log entry. The generated proof is added to the JSON Line
and the log entry JSON object becomes the first entry in the [[ref:
DID Log.

The following is the JSON prettified entry log file that is
published as the initial `did.jsonl` file. When published, all extraneous
whitespace is removed, as shown in the block below the pretty-printed instance.

```json
{
  "versionId": "1-QmQ6FJ4fk2xheSSQoEjVpTgx9AQPKhJgtR9hn1nr4EeCrZ",
  "versionTime": "2025-04-01T17:39:50Z",
  "parameters": {
    "witness": {
      "threshold": 2,
      "witnesses": [
        {
          "id": "did:key:z6Mkkc51mg2vpQzKWAbWQZupeGYhowaBjYkmvcKMTqteqHB4",
          "weight": 1
        },
        {
          "id": "did:key:z6MkuDdJdKLCgwZuQuEi9xG6LVgJJ9Tebr74CXPYPSumqgJs",
          "weight": 1
        },
        {
          "id": "did:key:z6MkoSWmQyp4fTk4ZQy4KUsss9dFX51XfEUzKKKj1J1JUsrF",
          "weight": 1
        }
      ]
    },
    "updateKeys": [
      "z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr"
    ],
    "nextKeyHashes": [
      "QmZreDcjvWEpyRFznQeExWNCsvMLk5i59AcRJJuQC8UodJ"
    ],
    "method": "did:webvh:0.5",
    "scid": "QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE"
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example"
  }
}
```

The same content "un-prettified", as it is found in the `did.jsonl` file, with the `proof` attached:

```json
{"versionId": "1-QmQ6FJ4fk2xheSSQoEjVpTgx9AQPKhJgtR9hn1nr4EeCrZ", "versionTime": "2025-04-01T17:39:50Z", "parameters": {"witness": {"threshold": 2, "witnesses": [{"id": "did:key:z6Mkkc51mg2vpQzKWAbWQZupeGYhowaBjYkmvcKMTqteqHB4", "weight": 1}, {"id": "did:key:z6MkuDdJdKLCgwZuQuEi9xG6LVgJJ9Tebr74CXPYPSumqgJs", "weight": 1}, {"id": "did:key:z6MkoSWmQyp4fTk4ZQy4KUsss9dFX51XfEUzKKKj1J1JUsrF", "weight": 1}]}, "updateKeys": ["z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr"], "nextKeyHashes": ["QmZreDcjvWEpyRFznQeExWNCsvMLk5i59AcRJJuQC8UodJ"], "method": "did:webvh:0.5", "scid": "QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE"}, "state": {"@context": ["https://www.w3.org/ns/did/v1"], "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example"}, "proof": [{"type": "DataIntegrityProof", "cryptosuite": "eddsa-jcs-2022", "verificationMethod": "did:key:z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr#z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr", "created": "2025-04-01T17:39:50Z", "proofPurpose": "authentication", "proofValue": "zQZVJizP7UGAoLzGYGvHmTUhQVs7fFByj4zNP9N1vGHARtWfyupxEp1qjLQ65iKuvHrtXhUe6UXfCNJA6WYLwvg5"}]}

```

#### `did:web` Instance of DIDDoc

As noted in the [publishing a parallel `did:web`
DID](https://identity.foundation/didwebvh/#publishing-a-parallel-didweb-did) section of this specification a `did:webvh` can be published
by replacing `did:webvh` with `did:web` in the DIDDoc, adding an `alsoKnownAs` entry for the `did:webvh`
and publishing the resulting DIDDoc at `did.json`, logically beside the `did.jsonl` file.

Here is what the `did:web` DIDDoc looks like for the `did:webvh` above.

```json
{
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:web:domain.example",
    "alsoKnownAs": ["did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example"]
}
```

### DID Log Entry 2 of the DIDDoc

Time passes, and the DID Controller of the `did:webvh` DID decides to update its
DID to a new version, `2`. In this case, the DIDDoc is substantially
updated, with a `verificationMethod` and service added to the DIDDoc. As well,
per the `did:webvh` specification when [pre-rotation] is being used, the
`updateKeys` and `nextKeyHashes` in the `parameters` are updated. The rest of
the `parameters` are unchanged, and so not included.

#### Version 2 Entry Hashing Input

To generate a new DID log entry, the DID Controller needs to
provide the updated `parameters`, and the new DIDDoc. The following
processing is done to create the new DID log entry:

- The `versionId` from the previous (first) log entry is made the value
  of the `versionId` in the new log entry.
- The `versionTime` in the new log entry is set to the current time.
- The `parameters` entry passed in is processed. In this case, since the
`updateKeys` array is updated, and pre-rotation is active, the a
verification is done to ensure that the hash of the `updateKeys` entries are
found in the `nextKeyHashes` property from DID log entry 1 of the DID. As required by the
`did:webvh` specification, a new `nextKeyHashes` is included in the new `parameters`.
- The new (but unchanged) DIDDoc is included in its entirety, as the value of the `state` property.
- The resultant JSON object is passed into the [`entryHash` generation
  process](https://identity.foundation/didwebvh/#entry-hash-generation-and-verification) which outputs the
  `entryHash` for this log entry. Once again, the `versionId` value is
  replaced by the version number (the previous version number plus `1`, so `2`
  in this case), a dash (`-`), and the new `entryHash`.
- The data integrity proof is generated added to the log
  entry, spaces are removed, a `CR` character added (per JSON Lines)
  and the entire entry is appended to the existing DID log file.

The DID log file can now be published, optionally with an update to the corresponding `did:web` DID.

The following is the JSON pretty-print log entry for the second DID log entry of our example `did:webvh`. Things to note in this example:

- Because pre-rotation of the authorized keys (`updateKeys`) is in effect (based on the presence of the `nextKeyHashes` item), the Data Integrity proof is signed by a key in the `updateKeys` item from **this** DID log entry.
  - When pre-rotation is not active, the `updateKeys` active based on the previous DID log entry would have been used. This is covered in the [Authorized Keys] section of the `did:webvh` specification.
- A new `updateKeys` property in the `parameters` has been defined, along with
  commitment to a future key (`nextKeyHashes`) that will control a subsequent update
  to the DID. Since pre-rotation was already active, the multihash of the keys in the `updateKeys` item in this DID log entry must be in the `nextKeyHashes` item of the previous DID log entry.

[Authorized Keys]: https://identity.foundation/didwebvh/#authorized-keys

```json
{
  "versionId": "2-QmbCoFcFACuFQNqsSAcHvnPTNnJpkWdiZ9dcf2nwxSWq6j",
  "versionTime": "2025-04-01T17:39:51Z",
  "parameters": {
    "updateKeys": [
      "z6MkrZC56Sc72278z3mpyBWrFPuZ5P1EnMPx1uKTmK6VhGTh"
    ],
    "nextKeyHashes": [
      "QmScCC6BgnbNNy8ADyxkJ2xamnC6iPpDDtPH79YtohNcBh"
    ]
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1",
      "https://w3id.org/security/multikey/v1",
      "https://identity.foundation/.well-known/did-configuration/v1"
    ],
    "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example",
    "authentication": [
      "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT"
    ],
    "assertionMethod": [
      "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT"
    ],
    "verificationMethod": [
      {
        "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT",
        "controller": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example",
        "type": "Multikey",
        "publicKeyMultibase": "z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT"
      }
    ],
    "service": [
      {
        "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#domain",
        "type": "LinkedDomains",
        "serviceEndpoint": "https://domain.example"
      }
    ]
  },
  "proof": [
    {
      "type": "DataIntegrityProof",
      "cryptosuite": "eddsa-jcs-2022",
      "verificationMethod": "did:key:z6MkrZC56Sc72278z3mpyBWrFPuZ5P1EnMPx1uKTmK6VhGTh#z6MkrZC56Sc72278z3mpyBWrFPuZ5P1EnMPx1uKTmK6VhGTh",
      "created": "2025-04-01T17:39:51Z",
      "proofPurpose": "authentication",
      "proofValue": "z2uiQcW8mDt7DphWmT7o9FCgZyvC7wJQSN9zUMPEson8bGboAg9jAek8RihzxAhA4bMja8zN7Z9BTe1WjJja99yk5"
    }
  ]
}
```

#### DID Log File For Version 2

The new version 2 `did.jsonl` file contains two DID log entries, one for each version
of the DIDDoc -- as per the use of JSON Lines.

```json
{"versionId": "1-QmQ6FJ4fk2xheSSQoEjVpTgx9AQPKhJgtR9hn1nr4EeCrZ", "versionTime": "2025-04-01T17:39:50Z", "parameters": {"witness": {"threshold": 2, "witnesses": [{"id": "did:key:z6Mkkc51mg2vpQzKWAbWQZupeGYhowaBjYkmvcKMTqteqHB4", "weight": 1}, {"id": "did:key:z6MkuDdJdKLCgwZuQuEi9xG6LVgJJ9Tebr74CXPYPSumqgJs", "weight": 1}, {"id": "did:key:z6MkoSWmQyp4fTk4ZQy4KUsss9dFX51XfEUzKKKj1J1JUsrF", "weight": 1}]}, "updateKeys": ["z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr"], "nextKeyHashes": ["QmZreDcjvWEpyRFznQeExWNCsvMLk5i59AcRJJuQC8UodJ"], "method": "did:webvh:0.5", "scid": "QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE"}, "state": {"@context": ["https://www.w3.org/ns/did/v1"], "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example"}, "proof": [{"type": "DataIntegrityProof", "cryptosuite": "eddsa-jcs-2022", "verificationMethod": "did:key:z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr#z6MkgzBDcBFV3sk4ypPE5YXMZHmS213A3HpYY2LmcVKV15jr", "created": "2025-04-01T17:39:50Z", "proofPurpose": "authentication", "proofValue": "zQZVJizP7UGAoLzGYGvHmTUhQVs7fFByj4zNP9N1vGHARtWfyupxEp1qjLQ65iKuvHrtXhUe6UXfCNJA6WYLwvg5"}]}
{"versionId": "2-QmbCoFcFACuFQNqsSAcHvnPTNnJpkWdiZ9dcf2nwxSWq6j", "versionTime": "2025-04-01T17:39:51Z", "parameters": {"updateKeys": ["z6MkrZC56Sc72278z3mpyBWrFPuZ5P1EnMPx1uKTmK6VhGTh"], "nextKeyHashes": ["QmScCC6BgnbNNy8ADyxkJ2xamnC6iPpDDtPH79YtohNcBh"]}, "state": {"@context": ["https://www.w3.org/ns/did/v1", "https://w3id.org/security/multikey/v1", "https://identity.foundation/.well-known/did-configuration/v1"], "id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example", "authentication": ["did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT"], "assertionMethod": ["did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT"], "verificationMethod": [{"id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT", "controller": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example", "type": "Multikey", "publicKeyMultibase": "z6MkjU89vLCBmQUW9rdbUCNrSqeNfCTHV5L45kBZN8Ljj1mT"}], "service": [{"id": "did:webvh:QmdmPkUdYzbr9txmx8gM2rsHPgr5L6m3gHjJGAf4vUFoGE:domain.example#domain", "type": "LinkedDomains", "serviceEndpoint": "https://domain.example"}]}, "proof": [{"type": "DataIntegrityProof", "cryptosuite": "eddsa-jcs-2022", "verificationMethod": "did:key:z6MkrZC56Sc72278z3mpyBWrFPuZ5P1EnMPx1uKTmK6VhGTh#z6MkrZC56Sc72278z3mpyBWrFPuZ5P1EnMPx1uKTmK6VhGTh", "created": "2025-04-01T17:39:51Z", "proofPurpose": "authentication", "proofValue": "z2uiQcW8mDt7DphWmT7o9FCgZyvC7wJQSN9zUMPEson8bGboAg9jAek8RihzxAhA4bMja8zN7Z9BTe1WjJja99yk5"}]}
```

#### `witness.json` File After Version 2

Since this DID has been configured to have witnesses (3, with a required threshold of 2, as noted in DID Log Entry 1), there is a `witness.json` file associated with the DID. The witness proofs are Data Integrity proofs, signed by the `did:key` DIDs of the witnesses, with a payload of the `versionId` value for the most recently witnessed DID log entry. The `witness.json` file is as follows:

[
  {
    "versionId": "2-QmbCoFcFACuFQNqsSAcHvnPTNnJpkWdiZ9dcf2nwxSWq6j",
    "proof": [
      {
        "type": "DataIntegrityProof",
        "cryptosuite": "eddsa-jcs-2022",
        "verificationMethod": "did:key:z6Mkkc51mg2vpQzKWAbWQZupeGYhowaBjYkmvcKMTqteqHB4#z6Mkkc51mg2vpQzKWAbWQZupeGYhowaBjYkmvcKMTqteqHB4",
        "created": "2025-04-01T17:39:51Z",
        "proofPurpose": "assertionMethod",
        "proofValue": "zAJbjewF2RpV4DMCCyYaui6jmcSEJgEMUj7rAZ9543hcurTN6ahfTWBwTFdSbh46HdP59E3V89GpaC45Df9W2uB3"
      },
      {
        "type": "DataIntegrityProof",
        "cryptosuite": "eddsa-jcs-2022",
        "verificationMethod": "did:key:z6MkuDdJdKLCgwZuQuEi9xG6LVgJJ9Tebr74CXPYPSumqgJs#z6MkuDdJdKLCgwZuQuEi9xG6LVgJJ9Tebr74CXPYPSumqgJs",
        "created": "2025-04-01T17:39:51Z",
        "proofPurpose": "assertionMethod",
        "proofValue": "z5BR5iViZoj2AkFakKCpiSrD9fstM3Ba88C9vBiyiqyzeCyZueoipfEuKikXgkRGtEcwvMkTaQFijjrB2tEmVJb81"
      }
    ]
  }
]

Note that there are only two signatures (because the threshold is 2), and the proofs both reference the `versionId` of the second DID log entry of the DID. What about the first DID log entry?  As per the specification ([here](https://identity.foundation/didwebvh/#the-witness-proofs-file)), the signing of a later DID log entry implies that the signing witness is approving of ("witnessing") all prior DID log entries. So since the witnesses are the same for DID log entries 1 and 2, the witness proofs on DID log entry 2 are sufficient for DID log entry 1 as well.
