# DID Portability

As noted in the [DID Portability](https://identity.foundation/didwebvh/#did-portability) section of the
specification, a `did:webvh` DID can be renamed (ported) by changing the `id` DID string in
the DIDDoc to one that resolves to a different HTTPS URL, as long as the
specified conditions are met.

While the impact of the feature is in fact the creation of a new DID, we think
there is significant value in some use cases for supporting the specified
capability. Ideally, the HTTPS URL for the "old" DID is changed to a redirect to
the new DID, allowing for a seamless, verifiable evolution of the DID.

An interesting example use case is a DID that replaces an email address hosted
by a particular service. The extra capabilities of having the identifier being a
DID vs. an email address is compelling enough, allowing it to be used for a
range of services beyond email. The portability benefit comes when the owner of
the DID decides to move to a new service, taking their DID with them. The
verifiable history carried over to the renamed DID hosted by the new service
provides assurance to those who interacted with the old DID (through chats,
emails, postings, etc.) that they are still engaging with the same entity,
despite the DID renaming. Compare that with what happens today when you switch
from one email provider to another, and you have to reach out to all your
contacts to assure them that you changed providers.

While portability is powerful, it must be used with care and only in use
cases where the capability is specifically required. When used, both the
pre-rotation and witnesses features of `did:webvh` **SHOULD** also be enabled.

## Mergers, Acquisitions and Name Changes

Organizations change over time and such changes often involve names changes.
Name changes in turn trigger domain name changes, as organizations match their
Web location with their names. Mergers, acquisitions, and simple name changes,
all can cause an organization's "known" domain name to change, including the
relinquishment of control over their previous domain name. When such changes
occur, it is very unlikely that just because the organization's DIDs use the old
domain name will prevent the changes. Thus the DIDs need to "adapt" to the new
domain -- the domain name portion of the DID has to change. Ideally, the old
location and domain can be retained and a web redirect used to resolve the old
DID to the new, but even if that cannot be done, the ability to use the same
SCID and retain the full history can be preserved.

## DID Hosting Service Providers

Consider being able to replace the current identifiers we are given (email
addresses, phone numbers) with `did:webvh` DIDs. Comparable hosting platforms
might publish our DIDs for us (ideally, with us in custody of our own private
keys...). Those DIDs, with the inherent public keys can be used for many
purposes -- encrypted email (hello PGP!), messaging, secure file sharing, and
more.

From time to time in that imagined future, we may want to move our DIDs
from one hosting service to another, just as we move from one email or mobile
provider to another. With DIDs that can move and retain the history, we can make
such moves smoothly. Contacts will see the change, but also see that the history
of the DID remains.

## Challenges in Moving a DID

While we see great value (and even a hard requirement) for being able to move a
DID's web location, it does create challenges in aligning with the
[DID Core](https://www.w3.org/TR/did-core/) specification. These challenges are listed below.

Moving a `did:webvh` is actually the (partial or complete) deactivation of the old
DID and the creation of a new DID. The use of the SCID and the way it
is generated is designed to prevent an attacker from being able to create a DID
they control but with the same SCID as existing DID. Thus, "finding" a `did:webvh`
with the same SCID implies the DIDs are the same. That can be verified by
processing the DID Log.

By retaining the incrementing of the `versionId` after a move, the "new" DID
does not start at `versionId` of `1`. Further, resolving `<new-did>?versionId=1`
is going to return a DIDDoc with the top-level `id` equal to the `<old-did>`.
This is useful from a business perspective, but unexpected from a
[DID Core](https://www.w3.org/TR/did-core/) perspective.
