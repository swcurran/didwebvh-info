The following covers the evolution of a `did:tdw` from inception through several
versions, showing the DID, DIDDoc, DID Log, and some of the
intermediate data structures.

**The examples are aligned with version 0.4 of the `did:tdw` specification.**

In some of the following examples the data for the DID log entries is
displayed as prettified JSON for readability. In the log itself, the JSON has
all whitespace removed, and each line ends with a `CR`, per the JSON
Lines convention.

### DID Creation Data

These examples show the important structures used in the [Create (Register)](https://identity.foundation/trustdidweb/#create-register) operation for a `did:tdw` DID.

#### Input to the SCID Generation Process with Placeholders

The following JSON is an example of the input that the DID Controller
constructs and passes into the
[SCID Generation Process](https://identity.foundation/trustdidweb/#scid-generation-and-verification). In this example, the DIDDoc is
particularly boring, containing the absolute minimum for a valid DIDDoc.

This example includes both the initial "authorized keys" to sign the Data Integrity proof
(`updateKeys`) and the pre-rotation commitment to the next authorization keys (`nextKeyHashes`). Both
are in the `parameters` property in the log entry.

```json
{
  "versionId": "{SCID}",
  "versionTime": "2024-09-26T23:22:26Z",
  "parameters": {
    "prerotation": true,
    "updateKeys": [
      "z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R"
    ],
    "nextKeyHashes": [
      "QmXC3vvStVVzCBHRHGUsksGxn6BNmkdETXJGDBXwNSTL33"
    ],
    "method": "did:tdw:0.4",
    "scid": "{SCID}"
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:tdw:{SCID}:domain.example"
  }
}
```

#### Output of the SCID Generation Process

After the SCID is generated, the literal `{SCID}` placeholders are
replaced by the generated SCID value (see below). This JSON is the
input to the [`entryHash` generation
process](https://identity.foundation/trustdidweb/#entry-hash-generation-and-verification) -- with the SCID
`versionId``. Once the process has run, the version number of this first version
of the DID (`1`), a dash `-` and the resulting output hash replace the [[ref:
SCID as the `versionId` value.

```json
{
  "versionId": "QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ",
  "versionTime": "2024-09-26T23:22:26Z",
  "parameters": {
    "prerotation": true,
    "updateKeys": [
      "z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R"
    ],
    "nextKeyHashes": [
      "QmXC3vvStVVzCBHRHGUsksGxn6BNmkdETXJGDBXwNSTL33"
    ],
    "method": "did:tdw:0.4",
    "scid": "QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ"
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example"
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

The following is the JSON prettified version of the entry log file that is
published as the initial `did.jsonl` file. When published, all extraneous
whitespace is removed, as shown in the block below the pretty-printed version.

```json
{
  "versionId": "1-QmQq6Kg4ZZ1p49znzxnWmes4LkkWgMWLrnrfPre8UD56bz",
  "versionTime": "2024-09-26T23:22:26Z",
  "parameters": {
    "prerotation": true,
    "updateKeys": [
      "z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R"
    ],
    "nextKeyHashes": [
      "QmXC3vvStVVzCBHRHGUsksGxn6BNmkdETXJGDBXwNSTL33"
    ],
    "method": "did:tdw:0.4",
    "scid": "QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ"
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example"
  },
  "proof": [
    {
      "type": "DataIntegrityProof",
      "cryptosuite": "eddsa-jcs-2022",
      "verificationMethod": "did:key:z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R#z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R",
      "created": "2024-09-26T23:22:26Z",
      "proofPurpose": "authentication",
      "proofValue": "z2fPF6fMewtV15kji2N432R7RjmmFs8p7MiSHSTM9FoVmJPtc3JUuZ472pZKoWgZDuT75EDwkGmZbK8ZKVF55pXvx"
    }
  ]
}
```

The same content "un-prettified", as it is found in the `did.jsonl` file:

```json
{"versionId": "1-QmQq6Kg4ZZ1p49znzxnWmes4LkkWgMWLrnrfPre8UD56bz", "versionTime": "2024-09-26T23:22:26Z", "parameters": {"prerotation": true, "updateKeys": ["z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R"], "nextKeyHashes": ["QmXC3vvStVVzCBHRHGUsksGxn6BNmkdETXJGDBXwNSTL33"], "method": "did:tdw:0.4", "scid": "QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ"}, "state": {"@context": ["https://www.w3.org/ns/did/v1"], "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example"}, "proof": [{"type": "DataIntegrityProof", "cryptosuite": "eddsa-jcs-2022", "verificationMethod": "did:key:z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R#z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R", "created": "2024-09-26T23:22:26Z", "proofPurpose": "authentication", "proofValue": "z2fPF6fMewtV15kji2N432R7RjmmFs8p7MiSHSTM9FoVmJPtc3JUuZ472pZKoWgZDuT75EDwkGmZbK8ZKVF55pXvx"}]}
```

#### `did:web` Version of DIDDoc

As noted in the [publishing a parallel `did:web`
DID](https://identity.foundation/trustdidweb/#publishing-a-parallel-didweb-did) section of this specification a `did:tdw` can be published
by replacing `did:tdw` with `did:web` in the DIDDoc, adding an `alsoKnownAs` entry for the `did:tdw`
and publishing the resulting DIDDoc at `did.json`, logically beside the `did.jsonl` file.

Here is what the `did:web` DIDDoc looks like for the `did:tdw` above.

```json
{
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:web:domain.example",
    "alsoKnownAs": ["did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example"]
}
```

### Version 2 of the DIDDoc

Time passes, and the DID Controller of the `did:tdw` DID decides to
update its DID to a new version, version 2. In this case, the only change
the DID Controller makes is transition the authorization key to
the pre-rotation key.

#### Version 2 Entry Hashing Input

To generate a new version of the DID, the DID Controller needs to
provide the updated `parameters`, and the new DIDDoc. The following
processing is done to create the new DID log entry:

- The `versionId` from the previous (first) log entry is made the value
  of the `versionId` in the new log entry.
- The `versionTime` in the new log entry is set to the current time.
- The `parameters` entry passed in is processed. In this case, since the
`updateKeys` array is updated, and pre-rotation is active, the a
verification is done to ensure that the hash of the `updateKeys` entries are
found in the `nextKeyHashes` property from version 1 of the DID. As required by the
`did:tdw` specification, a new `nextKeyHashes` is included in the new `parameters`.
- The new (but unchanged) DIDDoc is included in its entirety, as the value of the `state` property.
- The resultant JSON object is passed into the [`entryHash` generation
  process](https://identity.foundation/trustdidweb/#entry-hash-generation-and-verification) which outputs the
  `entryHash` for this log entry. Once again, the `versionId` value is
  replaced by the version number (the previous version number plus `1`, so `2`
  in this case), a dash (`-`), and the new `entryHash`.
- The data integrity proof is generated added to the log
  entry, spaces are removed, a `CR` character added (per JSON Lines)
  and the entire entry is appended to the existing DID log file.

The DID log file can now be published, optionally with an updated version of the corresponding `did:web` DID.

The following is the JSON pretty-print log entry for the second version of an example `did:tdw`. Things to note in this example:

- The data integrity proof `verificationMethod` is the `did:key` from
  the first log entry, since the `updateKeys` change in the second
  log entry does not take affect until _after_ the version update is
  complete.
- A new `updateKeys` property in the `parameters` has been added, along with
  commitment to a future key (`nextKeyHashes`) that will control future updates
  to the DID.

```json
{
  "versionId": "2-QmXL6CLK1BMHAd3zQMqkY49VSc9T3zhUcPxu6zEW176PfN",
  "versionTime": "2024-09-26T23:22:26Z",
  "parameters": {
    "updateKeys": [
      "z6MkvQnUuQn3s52dw4FF3T87sfaTvXRW7owE1QMvFwpag2Bf"
    ],
    "nextKeyHashes": [
      "QmdA9fxQSLLwCQo6TkovcoaLgGYWq6Ttqx6A5D1RY13iFG"
    ]
  },
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1"
    ],
    "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example"
  },
  "proof": [
    {
      "type": "DataIntegrityProof",
      "cryptosuite": "eddsa-jcs-2022",
      "verificationMethod": "did:key:z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R#z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R",
      "created": "2024-09-26T23:22:26Z",
      "proofPurpose": "authentication",
      "proofValue": "z2nkLj9rYAMG7TStpvihuo4HTovpC7uvWcDoYiGhoN8cqQuiwW2EnPZdWtid2FZAQDQPoaNkTooKVftGKDTh9p3Fy"
    }
  ]
}
```

#### Log File For Version 2

The new version 2 `did.jsonl` file contains two entries, one for each version
of the DIDDoc -- as per the use of JSON Lines.

```json
{"versionId": "1-QmQq6Kg4ZZ1p49znzxnWmes4LkkWgMWLrnrfPre8UD56bz", "versionTime": "2024-09-26T23:22:26Z", "parameters": {"prerotation": true, "updateKeys": ["z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R"], "nextKeyHashes": ["QmXC3vvStVVzCBHRHGUsksGxn6BNmkdETXJGDBXwNSTL33"], "method": "did:tdw:0.4", "scid": "QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ"}, "state": {"@context": ["https://www.w3.org/ns/did/v1"], "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example"}, "proof": [{"type": "DataIntegrityProof", "cryptosuite": "eddsa-jcs-2022", "verificationMethod": "did:key:z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R#z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R", "created": "2024-09-26T23:22:26Z", "proofPurpose": "authentication", "proofValue": "z2fPF6fMewtV15kji2N432R7RjmmFs8p7MiSHSTM9FoVmJPtc3JUuZ472pZKoWgZDuT75EDwkGmZbK8ZKVF55pXvx"}]}
{"versionId": "2-QmXL6CLK1BMHAd3zQMqkY49VSc9T3zhUcPxu6zEW176PfN", "versionTime": "2024-09-26T23:22:26Z", "parameters": {"updateKeys": ["z6MkvQnUuQn3s52dw4FF3T87sfaTvXRW7owE1QMvFwpag2Bf"], "nextKeyHashes": ["QmdA9fxQSLLwCQo6TkovcoaLgGYWq6Ttqx6A5D1RY13iFG"]}, "state": {"@context": ["https://www.w3.org/ns/did/v1"], "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example"}, "proof": [{"type": "DataIntegrityProof", "cryptosuite": "eddsa-jcs-2022", "verificationMethod": "did:key:z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R#z6MkhbNRN2Q9BaY9TvTc2K3izkhfVwgHiXL7VWZnTqxEvc3R", "created": "2024-09-26T23:22:26Z", "proofPurpose": "authentication", "proofValue": "z2nkLj9rYAMG7TStpvihuo4HTovpC7uvWcDoYiGhoN8cqQuiwW2EnPZdWtid2FZAQDQPoaNkTooKVftGKDTh9p3Fy"}]}
```

#### Log File For Version 3

The same process is repeated for version 3 of the DID. In this case:

- The DIDDoc is changed.
  - an `authentication` method is added.
  - two services are added.
- No changes are made to the authorized keys to update the DID. As a result, the `parameters` entry is empty (`{}`), and the parameters in effect from previous versions of the DID remain in effect.

Here is the pretty-printed log entry:

```json
{
  "versionId": "3-QmaSKJRACGefmi19LkS6TFj5FeMEfr98GpBWk7vEmbhT92",
  "versionTime": "2024-09-26T23:22:26Z",
  "parameters": {},
  "state": {
    "@context": [
      "https://www.w3.org/ns/did/v1",
      "https://w3id.org/security/multikey/v1",
      "https://identity.foundation/.well-known/did-configuration/v1",
      "https://identity.foundation/linked-vp/contexts/v1"
    ],
    "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example",
    "authentication": [
      "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX"
    ],
    "assertionMethod": [
      "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX"
    ],
    "verificationMethod": [
      {
        "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX",
        "controller": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example",
        "type": "Multikey",
        "publicKeyMultibase": "z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX"
      }
    ],
    "service": [
      {
        "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#domain",
        "type": "LinkedDomains",
        "serviceEndpoint": "https://domain.example"
      },
      {
        "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#whois",
        "type": "LinkedVerifiablePresentation",
        "serviceEndpoint": "https://domain.example/.well-known/whois.vc"
      }
    ]
  },
  "proof": [
    {
      "type": "DataIntegrityProof",
      "cryptosuite": "eddsa-jcs-2022",
      "verificationMethod": "did:key:z6MkvQnUuQn3s52dw4FF3T87sfaTvXRW7owE1QMvFwpag2Bf#z6MkvQnUuQn3s52dw4FF3T87sfaTvXRW7owE1QMvFwpag2Bf",
      "created": "2024-09-26T23:22:26Z",
      "proofPurpose": "authentication",
      "proofValue": "z2V72e7bRFpjvphDcWfYeSDTLsbkoVU5SfWAKMwpxYAL74D8GugTuoB2vH93cJqb8XXz8tN4es9AM787CogcbmXKa"
    }
  ]
}
```

Here is the log entry for just version 3 of the DID.

```json
{"versionId": "3-QmaSKJRACGefmi19LkS6TFj5FeMEfr98GpBWk7vEmbhT92", "versionTime": "2024-09-26T23:22:26Z", "parameters": {}, "state": {"@context": ["https://www.w3.org/ns/did/v1", "https://w3id.org/security/multikey/v1", "https://identity.foundation/.well-known/did-configuration/v1", "https://identity.foundation/linked-vp/contexts/v1"], "id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example", "authentication": ["did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX"], "assertionMethod": ["did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX"], "verificationMethod": [{"id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX", "controller": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example", "type": "Multikey", "publicKeyMultibase": "z6MkrgET7ZLV32qNrr6vUd2kVXGw63vbPvqxDqqhRQpvngBX"}], "service": [{"id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#domain", "type": "LinkedDomains", "serviceEndpoint": "https://domain.example"}, {"id": "did:tdw:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:domain.example#whois", "type": "LinkedVerifiablePresentation", "serviceEndpoint": "https://domain.example/.well-known/whois.vc"}]}, "proof": [{"type": "DataIntegrityProof", "cryptosuite": "eddsa-jcs-2022", "verificationMethod": "did:key:z6MkvQnUuQn3s52dw4FF3T87sfaTvXRW7owE1QMvFwpag2Bf#z6MkvQnUuQn3s52dw4FF3T87sfaTvXRW7owE1QMvFwpag2Bf", "created": "2024-09-26T23:22:26Z", "proofPurpose": "authentication", "proofValue": "z2V72e7bRFpjvphDcWfYeSDTLsbkoVU5SfWAKMwpxYAL74D8GugTuoB2vH93cJqb8XXz8tN4es9AM787CogcbmXKa"}]}
```

And so on...
