# riboDB

This site is a new version of the previous site "*RiboDB : a prokaryotic ribosomal components DataBase*" hosted at the same URL.
The previous version was written in Python3 and uses CGI. But the CGI module is "*deprecated since version 3.11, removed in version 3.13*" so the need to refresh the site.

Using the new website is less difficult and more safe, most choices are obvious. 

The riboDB DB (nov 2024) contains data from 254,984 genomes (2262 _Archaea_, 252,722 _Bacteria_) and 15,282,163 sequences corresponding to 23,858 species of _Bacteria_ and 938 of _Archaea_. 

## Extraction or statistic

### Extraction

From a query we will try to extract the ribosomal proteins and/or if needed the SSUrDNA.

#### Choosing the proteins families
R-prots are named according to BAN, BECKMANN, CATE _et al._ A new system for naming ribosomal proteins. Current opinion in structural biology, 2014, vol. 24, p. 165-169 **[Ban Lab website](https://bangroup.ethz.ch/research/nomenclature-of-ribosomal-proteins.html)**

The families are 
``["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9", "al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]``

The "*Universal*" are shared by _Bacteria_ and _Archaea_: 
``["ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9"]``

_Bacteria_ may have "*Bacterial Specific*" families
``["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23"]``

and _Archaea_ have "*Archaeal Specific*" families
``["al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]``

If you are looking for Bacteria only, you need to select "*Universal*" and "*Bacterial Specific*" and if Archaea, "*Universal*" and "*Archaeal Specific*" families.

#### Selecting SSUrDNA (16S, 23S, 5S)

``["16SrDNA", "23SrDNA", "5SrDNA"]``

#### Selecting the quality-driven categories of the genomes

1) Reference or Representative genomes (as defined by the NCBI): high quality of the genomes and said to be a good exemple of the genomes of the species.
2) Genomes corresponding to Type-Strains, this qualification correspond to Type-stains of the species. But Type-stains may not be the best exemple for some species, and the quality of the genome is not guaranteed.
When a genome is said Representative _and_ belonging to a Type-Strain, this is the best we can have.
3) Genomes given as complete. This are usually good quality genomes but the major advantage is the coverage of the whole genome.
4) Genomes selected i the Ensembl! databank. Ensembl! is selecting the genomes to get a good representation of the geno-diversity of a species, and also check the global quality of the genomes (but this may much lower than that of Representative genomes)

#### The QUERY

Any word of fragment of word of more than 4 letters may be used as a query
The query must be one-ligned ad separators are spaces (white spaces) like here:
``Esch Staphylococcus_aureus Methanohalo``
In this exemple we are looking for a given species ``Staphylococcus_aureus``(mind the "_" inside the names) or fragments of the nomenclature.
The query is possible with or within:

1) Species name : ``Methanohalophilus_euhalobius``
2) NCBI "GCA" or "GCF" identifyer : ``GCF_004340645``
3) NCBI TaxId like ``51203``
4) Fragments of the nomenclature hierarchy : ``Archaea-Euryarchaeota-Methanomicrobia-Methanosarcinales-Methanosarcinaceae-Methanohalophilus``
And ``Methanosarcinales`` is a valid option, but ``Methano`` is also valid.
Note that some research **must** include "-" : ``Burkholderia`` will also return ``Burkholderiaceae``, the solution is to  add the separator: ``Burkholderia-``.

#### Submit 
The process being launched, the number of remaining family to treat is shown and the table is populating (you can expand it to more than 5 during the extraction). 
A summary appears at the end of the extraction.

#### Download the extracted sequences 
Note that the extracted sequences may not conserved more than 30 minutes.
The zipped directory is something like ``task_1736500391710_yGoNZJj9.tar.zip`` and when unzipped you get a directory ``atelier_1736368361478_g2QOgx4k`` with all the extracted families.
Inside each sub-directory (say ``us10``) there are 4 files 

1) protein sequences like ``us10_prot_uniques.fasta``, ``us10_prot_multiples.fasta``
2) nucleic sequences like ``us10_nuc_uniques.fasta``, ``us10_nuc_multiples.fasta``

##### uniques vs multiples
The explaination is straightforward: when only one protein is found in a genome, it is classified as "unique" and if more than one is is put in the "multiples" category. Multiples may be paralogues, duplicated etc. No check is done.

##### the special case of rDNA
each family sub-directory has only one files (``...nuc_uniques.fasta``) because only one rDNA from the possible multiples operons is retained on the basis of its centrality. The "unique" class is then not informative of the number of sequences in the genome. This is due to the fact that this database has been developped for the **[PkXplore web-site](https://pkxplore.univ-lyon1.fr/nucworkshop)** and available here for information.
##### the riboDB fasta

Typically:
``BEGIN COMMENTARY \n SEQUENCE`` ``BEGIN``is ``>``
``>Escherichia_coli|K_12substr.MG1655#R#E#C~GCF_000005845.2~NC_000913.3~C[3452959..3453270]~562~11=Bacteria-Pseudomonadota-Gammaproteobacteria-Enterobacterales-Enterobacteriaceae-Escherichia
MQNQRIRIRLKAFDHRLIDQATAEIVETAKRTGAQVRGPIPLPTRKERFTVLISPHVNKDARDQYEIRTHLRLVDIVEPTEKTVDALMRLDLAAGVDVQISLG``
Here within the COMMENTARY line:

1) ``Escherichia_coli`` : Species name (``Genus_species`` [``_subsp._subspecies`` or ``_pv._pathovar`` or ``_bv._biovar``])
2) ``K_12substr.MG1655`` : Strain identifyer (collection...)
3) ``R#E#C``: #quality#quality... the declared quality of the genomes are R (reference/representative), T (type-strain), E (in Ensembl!), C (complete genome) S (Scaffold) U (not declared or low quality)
4) ``GCF_000005845.2`` : NCBI unique Id for the genome
5) ``NC_000913.3`` : Locus and version or contig Id and version.
6) ``C[3452959..3453270]``: Position in the genome (or in contig, C means complementary)
7) ``562``: NCBI taxId
8) ``11`` :genetic code
9) ``Bacteria-Pseudomonadota-Gammaproteobacteria-Enterobacterales-Enterobacteriaceae-Escherichia``: Lineage_report (simplified) = Domain-Phylum-Class-Order-Family-Genus

### Statistics

In fact the results are similar, except that extraction not being done, upload will give nothing.
This function will be improoved.

## What is behind ?

### the riboDB database

RiboDB is built two time a year. It contains the ribosomal proteins of Archaea and Bacteria.

For Bacteria the source of the genomes is NCBI RefSeq, except for genomes bearing a "species" level not found in RefSeq. For Archaea we select all the genomes available in NCBI RefSeq and GenBank.

From the [initial approach](https://academic.oup.com/mbe/article/33/8/2170/2579323), there has been evolutions to manage the heavy increase of available genomes. Building the DB is done by using our own HMM set. The candidate proteins are then submitted to a quality-control by using a MMSEQS clustering that include reference sequences manually selected. Sequences from a cluster where references are also found are validated. The sequences occuring twice or more in a genome are separated in the "multiples" category.

RiboDB currently contains also the rDNA if available in the genomes. In the common case of multiples operons only one rDNA is retained on the basis of its centrality.

### The TCP server
From riboDB the data are re-organized in Julia dictionaries that are used by a TCP server written in Julia to answer to the queries. The process is described in its GitHub at **[TCPriboDB](https://github.com/jpflandrs/TCPriboDB)**

### This website

It is, like _TCPriboDB_ written in Julia using the **[GenieFramework](https://genieframework.com)**.

NOTE that the current programs concern the Docker version.
To use it outside docker, uncomment and resp. comment the two lines :
`#host = "0.0.0.0"  # Localhost or the actual IP of the server listen(IPv4("0.0.0.0"), 8080)`
`port = 8080       # Ensure this matches the server's port`

The best is to use inside a container and in this case the TCP server must be set-up before:

- 1) Create the directories and databases from the TCPriboDB directory as explained in **[TCPriboDB](https://github.com/jpflandrs/TCPriboDB)** and then create and run the container tcpribo. The instructions are also here (in english):

  - 1) From the TCPriboDB directory `julia prepareBNF.jl` will built `ENSEMBLEdes_serRP_V2` and `ENCYCLOPRIBODB.ser` and `TITRESENCYCLOP.ser`. Note that the path to the riboDB database is set in _Main_ (D1 and D2) and you need to fix this first.
  - 2) Create a directory ``/SOURCE/`` somewhere outside the TCPriboDB directory (the name is at your convenience).
  - 3) Within ``/SOURCE/`` create a directory `BNKriboDB_SER` and place here the _content_ of `ENSEMBLEdes_serRP_V2`.
  - 4) Same, within ``/SOURCE/`` create a directory `STATSRIBODB` and place here `ENCYCLOPRIBODB.ser` and `TITRESENCYCLOP.ser`
  - 5) Same, within ``/SOURCE/`` create the directories `public` and then `public/utilisateurs`, `TCPriboDB` and then `TCPriboDB/log`
  - 6) Build the container `docker build -t tcpribodb .` 
  - 7) Create the specific netwoerk `docker network create ribonetwork`
  - 8) Then `docker run --name tcpribo  --network ribonetwork -it -p 8080:8080 --mount type=bind,src=/pathto/SOURCE/BNKriboDB_SER,target=/home/ribo_tcp/app/BNKriboDB_SER --mount type=bind,src=/pathto/SOURCE/public,target=/home/ribo_tcp/app/public --mount type=bind,src=/apthto/SOURCE/TCPriboDB/log/,target=/home/ribo_tcp/app/log tcpribo`

- 2) Change to the riboDB directory 
- 3) Build the container `docker build -t ribodb .`
- 4) `docker run --name ribodb --network ribonetwork -it -p 8008:8008 --mount type=bind,src=/pathto/SOURCE/PKXPLORE/public,target=/home/genie/app/public --mount type=bind,src=/pathto/SOURCE/riboDB/log,target=/home/genie/app/log ribodb` 

So that the riboDB server is communicating toward outside (via NGINX) on port 8008 (may be another port) but the TCP server is communicating with the riboDB web server on port 8080.

### TCP-server communication
Both entities are in their own Docker and communicate using the Docker network. The server is behind a NGINX server to communicate outside.
Here is the NGINX description file in /sites-available

    server {
    listen 8008;
    listen [::]:8008;

    server_name   nnn.nnn.nnn.nnn;
    root          /;
    index         welcome.html;

    location / {
        proxy_http_version 1.1;
        proxy_pass http://localhost:8008;
        #websocket specific settings
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
    }

### Some explainations

On the client side there are two posssible queries
- 1) Statistics
  - 1) The files that can be downloaded are constructed *by the web server* riboDB and stored in `public/utilisateurs` in a `task_nnnnn_aaaa/atelier__nnnnn_aaaa` subdirectory. 
- 2) Extraction 
  - 1) The files that can be downloaded are constructed *by the TCP server* riboDB and stored in `public/utilisateurs` in a `task_nnnnn_aaaa/atelier__nnnnn_aaaa` subdirectory.

`task_nnnnn_aaaa/atelier__nnnnn_aaaa` is an unique identifyer that change for each query, so even if you ask for statistics and then extraction, the directory is not shared

In our machine  `public/utilisateurs` is also used by **[PkXplore]("https://github.com/jpflandrs/PkXplore")** to hold the clients files and the logs. 

## License

    riboDBsite.jl le site riboDB

    Copyright or © or Copr. UCBL Lyon, France;  
    contributor : [Jean-Pierre Flandrois] ([2024/12/20])
    [JP.flandrois@univ-lyon1.fr]

    This software is a computer program whose purpose is to create the riboDB sequence database site.

    This software is governed by the [CeCILL|CeCILL-B|CeCILL-C] license under French law and
    abiding by the rules of distribution of free software.  You can  use, 
    modify and/ or redistribute the software under the terms of the [CeCILL|CeCILL-B|CeCILL-C]
    license as circulated by CEA, CNRS and INRIA at the following URL
    "http://www.cecill.info". 

    As a counterpart to the access to the source code and  rights to copy,
    modify and redistribute granted by the license, users are provided only
    with a limited warranty  and the software's author,  the holder of the
    economic rights,  and the successive licensors  have only  limited
    liability. 

    In this respect, the user's attention is drawn to the risks associated
    with loading,  using,  modifying and/or developing or reproducing the
    software by the user in light of its specific status of free software,
    that may mean  that it is complicated to manipulate,  and  that  also
    therefore means  that it is reserved for developers  and  experienced
    professionals having in-depth computer knowledge. Users are therefore
    encouraged to load and test the software's suitability as regards their
    requirements in conditions enabling the security of their systems and/or 
    data to be ensured and,  more generally, to use and operate it in the 
    same conditions as regards security. 

    The fact that you are presently reading this means that you have had
    knowledge of the [CeCILL|CeCILL-B|CeCILL-C] license and that you accept its terms.


