# Using Pre-Rotation Keys

In an effort to prevent the loss of control over a decentralized identifier
(DID) due to a compromised private key, pre-rotation keys are
introduced. These commitments, made by the DID Controller, are
declarations about the authorization keys that will be published in future
versions of the DID log, without revealing the keys themselves.

The primary goal of pre-rotation keys is to ensure that even if an attacker
gains access to the current active key, they will not be able to take control of
the DID. This safeguard is achieved because the attacker could not simply rotate to
a key they generate and control. Rather, they would need to have also
compromised the unpublished (and presumably securely stored) pre-rotation key in
order to rotate the DID keys.

The cost of having pre-rotation protection is a more complicated process to update
the keys of a DID. The following are some considerations we have come across in
thinking about how to use the pre-rotation feature. The feature adds a
layer of key management complexity in return for the benefit.

## Key Rotation with Pre-Rotation

In using pre-rotation, a DID Controller should generate an "active" key
for the DIDDoc that is accessible for "production" purposes (signing,
decrypting), and generates the "next key" in an isolated location from
production. This prevents both the "active" and "next key" from being compromised in the
same intrusion attack. For example, if an intruder gets into your infrastructure and is able to extract all of your
private keys both DID control keys would be lost. Thus, we expect the feature to be used as follows:

- The DID Controller creating the DID would request from an isolated
  service the hash of the "next key" as defined in this specification. For
  example, an entity might have the "active" DID/key hosted by one Cloud
  Provider, and the "next key" by another, on the theory that an attacker might
  get into one environment or another but not both.
- When a key rotation is to be done, two entries are put in the log, using the following steps by the DID Controller:
  1. Get the full key reference entry from the isolated service for the pre-rotation "nextKey".
  2. Locally generate a pre-rotation key hash for a new key that will soon become the "active" key.
  3. Add a DID log entry that includes the properties from the previous two steps, and signs the proof using an authorized key (that presumably it controls, though not required).
    1. Although the DID log could be published now, it is probably best to hold off and publish it after adding a second, as described by the rest of the steps.
  4. Get a new pre-rotation hash from the isolated service.
  5. Get the full key-rotation key reference for the pre-rotation hash created for the last DID log entry.
  6. Add a DID Log entry that includes the properties from the previous two step
  7. If the key rotated in the previous DID log entry was a/the
     authorized key to make updates to the DID, call the isolated service to produce
     the Data Integrity proof over the entry using the key the isolated
     service controls.
     1. This step is not needed if the active service has a key authorized to sign the DIDDoc update.
  8. Publish the new DID log containing the two new entries.

## Post Quantum Attacks

One of the potential benefits of this approach to pre-rotation is that it is
"post-quantum safe". The idea is that in a post-quantum world, the availability
of the published key and signatures may enable the calculation of the
corresponding private key. Since the pre-rotation value is a hash of the
`nextKey` and not the public key itself, a post-quantum attack would not
compromise that key, and so a further rotation by the attacker would not be
possible. If there was a (suspected) need to transition to using a quantum-safe
key, the same process listed above would be used, but key reference and the
pre-rotation hash added into the second DID log entry would presumably
both be for quantum-safe keys.

## Challenges in Using Pre-Rotation

Key management is hard enough without having to maintain isolated key generation
environments for creating keys for different purposes. Enabling connectivity between
the key generation environments to enable automated key rotation while maintaining the
key recovery environment as "isolated" is technically challenging.
