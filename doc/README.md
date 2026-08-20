doc
===

This directory contains tutorials describing how to configure and run GEOS-Chem simulations.


Contents
--------

* [simulation-guide](simulation-guide.md): Guide to running simulations on GRICAD/CIMENT or ige-calcul.
Here is a flowchart of the workflow that you will find in the simulation guide:

```mermaid
flowchart TD

    A[Connect to computing cluster]
    B[Create WORKDIR]
    C[Clone GEOS-Chem-infra]
    D[Clone GEOS-Chem + checkout version]
    E[Create run directory]
    F[Configure run environment]
    G[Configure simulation]
    H[Configure job scripts]
    
    BUILD["1_build.sh"]
    DRY1["2_dryrun.sh"]
    MISS{"Missing data?"}

    DOWNLOAD["download-data.sh"]
    DRY2["2_dryrun.sh"]
    STILL{"Still missing?"}

    CATALOG["bashdatacatalog"]


    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> BUILD
    BUILD --> DRY1
    DRY1 --> MISS

    MISS -- "No" --> RUN
    MISS -- "Yes" --> DOWNLOAD

    DOWNLOAD --> DRY2
    DRY2 --> STILL

    STILL -- "No" --> RUN
    STILL -- "Yes" --> CATALOG

    CATALOG --> RUN
   

    RUN --> END
```
