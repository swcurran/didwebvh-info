## A Web Server for publishing did:webvh (and did:web) DIDs

This server is built with the FastAPI framework.

The did:webvh spec: [https://identity.foundation/didwebvh/next](https://identity.foundation/didwebvh/next)

## Abstract

This server is for issuing clients to deposit their did documents, did logs and other objects.

Having a separate server to deposit verification material will ensure that signing material is isolated and provide a more secured architecture.

This also enables system architects to create rigid governance rules around publishing DID documents and related resources through endorsement.

## How it works
*For a demonstration, please see the did:webvh Server demo directory*

- An issuer requests an identifier location from the server.
    - The server returns a configuration if the location is available.
- The issuer generates a verification method and signs a did document with it.
    - Using the provided proof configuration from the server.
- The issuer request an endorser signature.
    - Using the provided proof configuration from the server.
- The issuer sends this request back to the server.

### Registering a new DID
```mermaid
sequenceDiagram
    participant did:webvh Web Server
    participant Issuer Client
    participant Endorser Agent
    Issuer Client->>did:webvh Web Server: Request an identifier namespace.
    Trust did:webvh Web Server->>Issuer Client: Provide a DID document and a proof configuration.
    Issuer Client->>Issuer Client: Create new verification method.
    Issuer Client->>Issuer Client: Sign DID document.
    Issuer Client->>Endorser Agent: Request endorser signature.
    Endorser Agent->>Endorser Agent: Verify and sign DID document.
    Endorser Agent->>Issuer Client: Return endorsed DID document.
    Issuer Client->>did:webvh Web Server: Send endorsed DID document.
    Trust DID Web Server->>did:webvh Web Server: Verify endorsed DID document.
```

## Roadmap
- DID log support
- whois VP support
- AnonCreds objects support
- Status lists support

```bash
In a web where trust is born anew,
Decentralized keys unlock our view.
We shape the code, and break the chain,
Trust in our hands will always reign.
```
