# dependencies

The upstream NodeSets the models in this repository require, committed rather than fetched at
build time.

Populate it once and commit what lands:

```
dotnet Opc.Ua.SpecificationPublisher fetch-dependencies
```

That reads every specification's model at once — they share this directory and mostly share one
set of dependencies — resolves what is missing by `ModelUri`, transitively, and downloads it from
the [OPC UA Cloud Library](https://uacloudlibrary.opcfoundation.org). The Cloud Library
authenticates every request including search, so set `OPCUA_CLOUDLIB_USER` and
`OPCUA_CLOUDLIB_PASSWORD` first; the password is deliberately not a command-line option, because
an argument list is visible to other processes and ends up in shell history and CI logs.

Why committed: a build that fetched from the network would build something slightly different
depending on when it ran and what the library held that day. A directory in the repository builds
the same thing for everyone, forever, and CI needs no credentials at all.

Shared by every specification here, because two parts of one family borrow from the same upstream
models and a copy per part would be megabytes of identical files to keep in step.
