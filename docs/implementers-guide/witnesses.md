# Witnesses

The term "witness" is often used in the decentralized trust space to refer to
participants in an ecosystem that oversee the evolution of an identifier
according to some ecosystem-specific governance framework. The goal is for a
witness to collect, verify and approve data about the identifier and
share it with others that trust the witness so they don't need to do
that work themselves. The extra participants are intended to identify both
malicious attackers of the identifier, and malicious use of the identifier by
the DID Controller.

Witnesses play an explicit function in `did:webvh`. When used by a DID
Controller, witnesses (themselves identified by DIDs) are sent
pending DID log entries prepared by the DID Controller. The
witnesses verify the log entry using their copy of the
"current state" of the DID, and then "approve" the update, according to the
governance they use to define what "approval" means. For example, a [[ref:
witness might interact with another party (perhaps even a person) to confirm
that the DID Controller created the log entry. Once the [[ref:
witness has both verified and approved the change, they express that approval
by creating a Data Integrity proof that is chained to the data
integrity proof created by the DID Controller, and send the proof
back to the DID Controller. Once the number of data integrity
proofs received by the DID Controller from the witnesses has
exceeded a threshold, the DID Controller adds those proofs to their own
data integrity proof in the log entry. Next, the DID
Controller adds the log entry to the DID log and publishes
the updated DIDDoc. A DID Controller relying on witnesses
cannot independently publish an update to their DID -- they must get and publish
the witness approval proofs.

The application of witnesses is very much dependent on the governance
of the ecosystem. Such governance is outside the scope of the `did:webvh`
specification, and up to those deploying `did:webvh` DIDs. Hence, a DID
Controller that controls a series of DIDs and uses those DIDs as [[ref:
witnesses adds no additional trust or security to a DID if no properly defined
governance is in place. In particular, in order for witnesses to add
security and trust to a DID requires the members of an ecosystem to agree to the
defined governance. A witness could be an "endorser" of a set of DIDs
that are part of an ecosystem, with the act of witnessing the updates conveying
through their approval that the DIDs are a legitimate participant in the
ecosystem. Witnesses can also be used as a form of "two-factor
authentication" of a change, such as having a public key published as a DNS
record used as a witness for the DID. Such an addition means that an
attacker would need to compromise both the web-publishing infrastructure of the
DID Controller (where they publish the DID's `did.jsonl` file) as well as its
DNS entry.

`did:webvh` witnesses have been specified to be simple to implement and use. Their
power and effectiveness will come in how they are deployed within specific,
governed ecosystems.
