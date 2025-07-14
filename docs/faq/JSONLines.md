# Why JSON Lines?

JSON Lines (newline-delimited JSON) is a format where each line is a valid JSON object. It’s widely used in data streaming, logging, and large-scale data processing.

## Benefits of JSON Lines

**1. Streaming-Friendly**  
JSON Lines allows data to be processed one entry at a time. This means applications can handle very large datasets without loading everything into memory.

**2. Incremental Parsing**  
Each line is self-contained. Parsers can begin consuming data as soon as the first line is received, which enables early processing and partial reads.

**3. Incremental Retrieval**  
A resolver that saves the state of a Log File (including the current size of the file), can retrieve (via HTTP header settings) and process only the entries added since the last read. This is efficient for applications that need to keep up with changes to DIDs without having to re-fetch the entire log.

**4. Easy Appending**  
New records can be added to the end of a file without modifying or re-serializing the existing content—ideal for systems that grow over time.

**5. Simple Tooling**  
Line-based formats work well with traditional Unix tools (`grep`, `awk`, `sed`) and can be parsed with minimal code in most languages.

## Performance Trade-offs

Benchmarks show that single JSON arrays may parse slightly faster in some environments. However, the practical benefits of JSON Lines—especially for scalability, simplicity, and streaming use cases—often outweigh the marginal performance difference.

JSON Lines is a strong choice for systems dealing with large, growing, or streamed data where simplicity and flexibility matter.
