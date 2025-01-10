# riboDB

This site is a new version of the previous site "*RiboDB : a prokaryotic ribosomal components DataBase*" hosted at the same URL.
The previous version was written in Python3 and uses CGI. But the CGI module is "*deprecated since version 3.11, removed in version 3.13*" so the need to refresh the site.

Using the new website is less difficult and more safe, most choices are obvious.

## Extraction or statistic 

### Extraction

From a query we will try to extract the ribosomal proteins and/or if needed the SSUrDNA.

#### Choosing the proteins families
R-prots are named according to BAN, Nenad, BECKMANN, Roland, CATE, Jamie HD, et al. A new system for naming ribosomal proteins. Current opinion in structural biology, 2014, vol. 24, p. 165-169 **[Ban Lab website](https://bangroup.ethz.ch/research/nomenclature-of-ribosomal-proteins.html)**

The families are 
``["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9", "al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]``

The "*Universal*" are shared by _Bacteria_ and _Archaea_: 
``["ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9"]``

_Bacteria_ may have "*Bacterial Specific*" families
``["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23"]``

and _Archaea_ have "*Archaeal Specific*" families
``["al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]``

If you are looking for Bacteria only you need to select "*Universal*" and "*Bacterial Specific*" and if Archaea, "*Universal*" and "*Archaeal Specific*" families.

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

See the "Exemple use" in cas of doubt.

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

##### the riboDB fasta

Typically:
``>Escherichia_coli|K_12substr.MG1655#R#E#C~GCF_000005845.2~NC_000913.3~C[3452959..3453270]~562~11=Bacteria-Pseudomonadota-Gammaproteobacteria-Enterobacterales-Enterobacteriaceae-Escherichia
MQNQRIRIRLKAFDHRLIDQATAEIVETAKRTGAQVRGPIPLPTRKERFTVLISPHVNKDARDQYEIRTHLRLVDIVEPTEKTVDALMRLDLAAGVDVQISLG``
With :

1) ``Escherichia_coli`` : Species name (Genus_species[_subspecies])
2) ``K_12substr.MG1655`` : Strain identifyer (collection...)
3) ``R#E#C``: #quality#quality... the declared quality of the genomes are R (reference/representative), T (type-strain), E (in Ensembl!), C (complete genome) S (Scaffold) U (not declared or low quality)
4) ``GCF_000005845.2`` : NCBI unique Id for the genome
5) ``NC_000913.3`` : Locus and version or contig Id.
6) ``C[3452959..3453270]``: Position in the genome (or contig, C means complementary)
7) ``562``: NCBI taxId
8) ``11`` :genetic code
9) ``Bacteria-Pseudomonadota-Gammaproteobacteria-Enterobacterales-Enterobacteriaceae-Escherichia``: Lineage_report = Domain-Phylum-Class-Order-Family-Genus
10) And of course the sequence...

### Statistics

In fact the results are similar, except that extraction not being done, upload will give nothing.
This function will be improoved.

## What is behind ?

### the riboDB database
RiboDB currently contains nucleic and protein sequences of ribosomal proteins from 196,228 genomes (Bacteria (183,167) and Archaea (13,061). The aim of this work is facilitate the use of ribosomal proteins in phylogeny.

RiboDB currently contains the rDNA if available in the genomes. As concern 16SrDNA, it contains 138,286 genomes of Bacteria and 4,779 of Archaea representing 22,781 species names.
In the common case of multiples operons only one rDNA is retained on the basis of its centrality

For Bacteria the source of the genomes is NCBI RefSeq, except for genomes bearing a "species" level not found in RefSeq. For Archaea we select all the genomes available in NCBI RefSeq and GenBank.

Building the DB is done by using our own HMM set. The candidate proteins are then submitted to a quality-control by using a MMSEQS clustering that include reference sequences manually selected. Sequences from a cluster where references are also found are validated. The sequences occuring twice or more in a genome are separated in the "multiples" category. 

### The TCP server
From riboDB the data are re-organized in Julia dictionaries that are used by a TCP server written in Julia to answer to the queries. The process is described in its GitHub at **[TCPriboDB](https://github.com/jpflandrs/TCPriboDB)**

### This website
It is, like _TCPriboDB_ written in Julia using the **[GenieFramework](https://genieframework.com)**.

### TCP-server communication
Both entities are in theyr own Docker and communicate using a Docker network. The server is behind a NGINX server to communicate outside.
Here is the NGINX description file in /sites-available

    server {
    listen 8008;
    listen [::]:8008;

    server_name   134.214.35.110;
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

Note for the Docker run instructions:
The directory PKXPLORE is here shared with **[PkXplore]("https://github.com/jpflandrs/PkXplore")** to hold the clients files and the logs. It must exist (or another directory with a "public" subdirectory, and also riboDB/log inside (see instructions))

    docker run --name ribodb --network ribodbnetwork -it -p 8008:8008 \
    --mount type=bind,src=/path_to/PKXPLORE/public,target=/home/genie/app/public \
    --mount type=bind,src=/path_to/PKXPLORE/riboDB/log,target=/home/genie/app/log \
    ribodb_dockerid

This is launched from a screen session. 

## License

    ribodb_server.jl le site riboDB

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

