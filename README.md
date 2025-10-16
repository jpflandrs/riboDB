# riboDB

The best is to read first the [riboDB wiki](https://github.com/jpflandrs/riboDB/wiki), this ReadMe is focused on the construction of the website and installation

# Construction and installation of the website

This website is written in pure [Julia](https://julialang.org) and relies on [GenieFrameworks](https://genieframework.com).

## the riboDB database

RiboDB is built two time a year. It contains the ribosomal proteins of Archaea and Bacteria.

For Bacteria the source of the genomes is NCBI RefSeq, except for genomes bearing a "species" level not found in RefSeq. For Archaea we select all the genomes available in NCBI RefSeq and GenBank.

From the [initial approach](https://academic.oup.com/mbe/article/33/8/2170/2579323), there has been evolutions to manage the heavy increase of available genomes. The new version of the riboDB construction program is written in pure [Julia](https://julialang.org) and this led to a 20x speeds-up of the construction process and reduction of the storage needs by 3. Building the DB is done by using our own HMM set. The candidate proteins are then submitted to a quality-control by using a MMSEQS clustering that include reference sequences manually selected. Sequences from a cluster where references are also found are validated. The sequences occuring twice or more in a genome are separated in the "multiples" category.

RiboDB currently contains also the rDNA if available in the genomes. In the common case of multiples operons only one rDNA is retained on the basis of its centrality.



## The TCP server
From riboDB the data are re-organized in Julia dictionaries that are used by a TCP server written in Julia to answer to the queries. The process is described in its GitHub at **[TCPriboDB](https://github.com/jpflandrs/TCPriboDB)**

## This website

It is, like _TCPriboDB_ written in Julia using the **[GenieFramework](https://genieframework.com)**.

# Building the web-site

## Preparing the BNF

The BNF is a system for representing sequences as a dictionary. An alternative would have been to use a classic DBMS. There are multiple reasons for not choosing the DBMS option, but the main idea is that the TCP server is a solution that can be used every time a Knowledge Base (BdC, the new representation of genomes) is created to allow local queries and is not limited to riboDB.

We start from the latest version of riboDB (riboDB is available upon request and can be downloaded via the lab's website or internally on the bibi-lab server). RiboDB is a set of FASTA files classified by families and (except for dRNA) includes 4 files per family:
```famille_prot_uniques.fasta; famille_prot_multiples.fasta; famille_nuc_multiples.fasta; famille_nuc_uniques.fasta```

**WARNING**: The new version of the rDNA extractor produces **inadequate** filenames! Change them as shown below (for Archaea and Bacteria)! Example:

```shell
/Users/flandrs/Documents/ProtéinesDuJour/RIBODB/ENSEMBLEdes_serRP_V2/16SrDNA/16SrDNA_nuc_uniques.ser
/Users/flandrs/Documents/ProtéinesDuJour/RIBODB/BACTERIA/16SrDNA/16SrDNA.fst
/Users/flandrs/Documents/ProtéinesDuJour/RIBODB/ENSEMBLEdes_serRP_V2/23SrDNA/23SrDNA_nuc_uniques.ser
/Users/flandrs/Documents/ProtéinesDuJour/RIBODB/BACTERIA/23SrDNA/23SrDNA.fst
/Users/flandrs/Documents/ProtéinesDuJour/RIBODB/ENSEMBLEdes_serRP_V2/5SrDNA/5SrDNA_nuc_uniques.ser
/Users/flandrs/Documents/ProtéinesDuJour/RIBODB/BACTERIA/5SrDNA/5SrDNA.fst
```
Awaiting a solution!!!

Archaea and Bacteria are separated.

The families are:

```["16SrDNA", "23SrDNA", "5SrDNA", "bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl39", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9", "al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es32", "es4", "es6", "es8", "p1p2"]```

The following families are shared between Bacteria and Archaea:

```communs=["16SrDNA", "23SrDNA", "5SrDNA", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9"]```

The following families are specific to Bacteria:

```bacteriapropres=["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23"]```

And the following families are specific to Archaea:

```archaeapropres=["al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es32", "es4", "es6", "es8", "p1p2"]```

The principle of preparation is to associate the sequences of Bacteria and Archaea from shared families in the same file while creating, for each family and each type of protein, a dictionary Dict{String,String} linking the FASTA comment to its sequence.

Everything is serialized and ready to use. A future option could be to use additional zip compression to facilitate exchanges (as this allows 77% compression).


The script prepareBNF.jl does the job. As in all my development phases, the paths are hardcoded in the .jl file in __Main__. You have to change it:

```
D1="/Users/jean-pierreflandrois/Documents/ProtéinesDuJour/RIBODB/BACTERIA"
D2="/Users/jean-pierreflandrois/Documents/ProtéinesDuJour/RIBODB/ARCHAEA"
```
to, for instance:

```
D1="/Users/flandrs/Documents/Proteinsoftheday/RIBODB/BACTERIA"
D2="/Users/flandrs/Documents/Proteinsoftheday/RIBODB/ARCHAEA"
```

prepareBNF.jl is slow!!! because it is not parallelized, but it is not done often.


Proteinsoftheday will be a folder dedicated to this work; I have abandoned the dated names here for simplicity.
This must be changed in the real context. So, julia prepareBNF.jl does the job.
Take the outputs (yes, not everything is automatic...):

In a folder whose name is also hardcoded (~line 92): ENSEMBLEdes_serRP_V2, put the files ENCYCLOPRIBODB.ser and TITRESENCYCLOP.ser


## Structure of the Site's Folders (for both nucworkshop and riboDB)
Typically, there should be a folder called ```PKXPLORE``` that serves as both a database and a results repository.
It contains:

- For nucworkshop, PKXPLORE (yes, same name, sorry), is related to BLAST searches on nucleic databases (like rDNA). It is not essential for riboDB, but on our server, everything is associated.
- For riboDB you need the following folders:
  - ```BNKriboDB_SER```: Contains the protein databases by family (riboDB) in serialized format.
  - ```STATSRIBODB```: Contains pre-calculated statistical data in serialized format.
  - ```riboDB```, ```TCPriboDB```, and ```log``` to collect logs, and finally 
  - the ```public``` folder with a user folder  (note the exact name is ```utilisateurs```) that will contain the extractions.

To avoid issues, it is recommended to carefully respect the structure of ```PKXPLORE```, which will be used by Docker instructions.

```PKXPLORE``` is therefore the folder that contains both the data and the results.

We will see here extensively its structure:

- ```PKXPLORE/BLAST``` (```ls``` output). Remember that this folder is not used by riboDB and may be empty.
```shell 
Ar_TRECS_ChaperoninGroeL.fst                            Ba_TRECS_ChaperoninGroeL.fst.nin                      Ba_TRECS_TranslationElongationFactorTu.fst.nos  cTRECS_23SrRNA.fst.ntf  TRECS_23SrRNA.fst.ndb
Ar_TRECS_ChaperoninGroeL.fst.ndb                        Ba_TRECS_ChaperoninGroeL.fst.njs                      Ba_TRECS_TranslationElongationFactorTu.fst.not  cTRECS_23SrRNA.fst.nhr   TRECS_23SrRNA.fst.njs
Ar_TRECS_ChaperoninGroeL.fst.nhr                        Ba_TRECS_ChaperoninGroeL.fst.nog                      Ba_TRECS_TranslationElongationFactorTu.fst.nto  cTRECS_23SrRNA.fst.nin   TRECS_23SrRNA.fst.nog
Ar_TRECS_ChaperoninGroeL.fst.nin                        Ba_TRECS_ChaperoninGroeL.fst.nos                      Ba_TRECS_TranslationElongationFactorTu.fst.nsq  cTRECS_23SrRNA.fst.njs   TRECS_23SrRNA.fst.nos
Ar_TRECS_ChaperoninGroeL.fst.njs                        Ba_TRECS_ChaperoninGroeL.fst.not                      cTRECS_16SrRNA.fst                              cTRECS_23SrRNA.fst.nog   TRECS_23SrRNA.fst.not
Ar_TRECS_ChaperoninGroeL.fst.nog                        Ba_TRECS_ChaperoninGroeL.fst.nsq                      cTRECS_16SrRNA.fst.ndb                          cTRECS_23SrRNA.fst.nos   TRECS_23SrRNA.fst.nsq
.../...
cTRECS_16SrRNA.fst.nsq                          cTRECS_5SrRNA.fst.nog   TRECS_5SrRNA.fst.njs
Ar_TRECSextended_TranslationElongationFactorTu.fst.nin  Ba_TRECS_DNADirectedRNAPolymeraseSubunitBeta.fst.nsq  cTRECS_23SrRNA.fst                              cTRECS_5SrRNA.fst.nos   TRECS_5SrRNA.fst.nog
Ar_TRECSextended_TranslationElongationFactorTu.fst.njs  Ba_TRECS_DNADirectedRNAPolymeraseSubunitBeta.fst.ntf  cTRECS_23SrRNA.fst.ndb                          cTRECS_5SrRNA.fst.nsq   TRECS_5SrRNA.fst.nos
Ar_TRECSextended_TranslationElongationFactorTu.fst.nog  Ba_TRECS_TranslationElongationFactorTu.fst            cTRECS_23SrRNA.fst.nhr                          cTRECS_5SrRNA.fst.nto   TRECS_5SrRNA.fst.nsq
cTRECS_23SrRNA.fst.ntf                          TRECS_16SrRNA.fst.nos   TRECS_5SrRNA.fst.nin
...
```


- ```PKXPLORE/log``` :
  - ```PKXPLORE/log/prod-2025-06-30.log```
  - ```PKXPLORE/log/prod-2025-09-12.log```

- ```PKXPLORE/public```: Contains users results in 
  - ```PKXPLORE/public/utilisateurs```
    - ```PKXPLORE/public/utilisateurs/task_1759861102339_UcWWhkjM/atelier_1759861102339_UcWWhkjM/...```
  - On the client side there are two posssible queries
  - 1) Statistics
    - 1) The files that can be downloaded are constructed *by the web server* riboDB and stored in `public/utilisateurs` in a `task_nnnnn_aaaa/atelier__nnnnn_aaaa` subdirectory. 
  - 2) Extraction 
    - 1) The files that can be downloaded are constructed *by the TCP server* riboDB and stored in `public/utilisateurs` in a `task_nnnnn_aaaa/atelier__nnnnn_aaaa` subdirectory.
  - 3) `task_nnnnn_aaaa/atelier__nnnnn_aaaa` is an unique identifyer that change for each query, so even if you ask for statistics and then extraction, the directory is not shared

  - In our machine  `public/utilisateurs` is also used by **[PkXplore]("https://github.com/jpflandrs/PkXplore")** to hold the clients files and the logs. 

- ```PKXPLORE/STATSRIBODB```: Contains pre-calculated statistical data, e.g., 
  - ```PKXPLORE/STATSRIBODB/ENCYCLOPRIBODB.ser```
  - ```PKXPLORE/STATSRIBODB/TITRESENCYCLOP.ser```

- ```PKXPLORE/BNKriboDB_SER```: Contains serialized FASTA sequences of families in folders by family:
  - ```PKXPLORE/BNKriboDB_SER/16SrDNA```
  - ```PKXPLORE/BNKriboDB_SER/al45``` Etc.

Here is the family list:
```shell
16SrDNA  al45  bl12  bl20  bl27  bl32  bl35  bs16  bs21  cs23  el15  el20  el30  el33  el38  el41  el8   es19  es26  es30  es6   ul1   ul13  ul16  ul22  ul29  ul4  us10  us13  us17  us3  us7
23SrDNA  al46  bl17  bl21  bl28  bl33  bl36  bs18  bs6   el13  el18  el21  el31  el34  el39  el42  es1   es24  es27  es31  es8   ul10  ul14  ul18  ul23  ul3   ul5  us11  us14  us19  us4  us8
5SrDNA   al47  bl19  bl25  bl31  bl34  bl9   bs20  bTHX  el14  el19  el24  el32  el37  el40  el43  es17  es25  es28  es4   p1p2  ul11  ul15  ul2   ul24  ul30  ul6  us12  us15  us2   us5  us9
```

Finally, logs for riboDB and its TCP server:

- ```PKXPLORE/riboDB/log```
- ```PKXPLORE/TCPriboDB/log```

## Transferring Folders from Julia Programs TCPriboDB and riboDB
The easiest way is to retrieve them from GitHub.

Attention: Follow the instructions below for LINUX servers!

## Docker Build and Docker Run
ASSUMPTION: THE SERVER IS A LINUX MACHINE

So, ```/home/user_name/PKXPLORE``` as the base path! (here /home/flandrs). On MAC, it's ```/Users/flandrs/PKXPLORE```, so you will need to change it.

Here are the instructions to build and run Docker:

```shell
cd TCPriboDB
screen -S TCP
docker build -t tcpribodb .
docker run --name tcpribo  --network jpfnetwork -it -p 8080:8080 --mount type=bind,src=/home/flandrs/PKXPLORE/BNKriboDB_SER,target=/home/ribo_tcp/app/BNKriboDB_SER --mount type=bind,src=/home/flandrs/PKXPLORE/public,target=/home/ribo_tcp/app/public --mount type=bind,src=/home/flandrs/PKXPLORE/TCPriboDB/log/,target=/home/ribo_tcp/app/log tcpribodb
````
Answer : Listening
Ctrl A + Ctrl D (detach screen)

```shell
cd riboDB
screen -S ribodb
docker build -t ribodb .
sudo docker run --name ribodb --network jpfnetwork -it -p 8008:8008 --mount type=bind,src=/home/flandrs/PKXPLORE/public,target=/home/genie/app/public --mount type=bind,src=/home/flandrs/PKXPLORE/riboDB/log,target=/home/genie/app/log --mount type=bind,src=/home/flandrs/PKXPLORE/STATSRIBODB,target=/home/genie/app/STATSRIBODB  ribodb 

 ██████╗ ███████╗███╗   ██╗██╗███████╗    ███████╗
██╔════╝ ██╔════╝████╗  ██║██║██╔════╝    ██╔════╝
██║  ███╗█████╗  ██╔██╗ ██║██║█████╗      ███████╗
██║   ██║██╔══╝  ██║╚██╗██║██║██╔══╝      ╚════██║
╚██████╔╝███████╗██║ ╚████║██║███████╗    ███████║
 ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝╚══════╝    ╚══════╝
[ Info: Binding to host 0.0.0.0 and port 8008
Ctrl A + Ctrl D (detach screen)
```

## NGINX Configuration on the Server

Both entities are in their own Docker and communicate using the Docker network. 

The server is behind a NGINX server to communicate outside.
Here is the NGINX description file in /sites-available

```shell
cat /etc/nginx/sites-enabled/my-genie-app
server {
  listen 80;
  listen [::]:80;
  server_name   134.214.35.110;
  root          /;
  index         welcome.html;
  location / {
      proxy_http_version 1.1;
      proxy_pass http://localhost:8000;
      #websocket specific settings
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host \$host;
  }
}
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
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection
```



# License

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


