

module Analysis

using Sockets
using Dates
using Random
using Serialization
using CSV
using DataFrames

export uniqueutilisateursimplifié, selecteurΣfamilles
"""
clientutile.jl un exemple de communication avec le serveur TCP de riboDB
Destiné à la communication TCP avec le docker (ou non)  du serveur .

Copyright or © or Copr. UCBL Lyon, France;  
contributor : [Jean-Pierre Flandrois] ([2024/12/20])
[JP.flandrois@univ-lyon1.fr]

This software is a computer program whose purpose is to create a TCP server interface to the riboDB sequence database.

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

"""


function renvoieepoch()
    dte=datetime2epoch(x::DateTime) = (Dates.value(x) - Dates.UNIXEPOCH)
    return dte(now())
end

function uniqueutilisateursimplifié()
    timestamp::String=string(renvoieepoch())
    random_string::String = randstring(8)  # 8-char random
    #fichtempo::String =  joinpath(pwd(),"public","utilisateurs","task_$(timestamp)_$(random_string)")
    fichtempo::String =  "$(timestamp)_$(random_string)"
    return fichtempo
end

#a intégrer après le site et ailleurs ;)
function compresser(classeur_utilisateur) #intermédiaire de zippp (oui 3 p) pour travailler dans le directory utilisateur 
    #pwd(),"public","utilisateurs","task_$(timestamp)_$(random_string)"
    
    #println("---")
    #println(classeur_utilisateur)#/Users/jean-pierreflandrois/Documents/PKDBGENIESTIPPLE/public/utilisateurs/task_20241013_220057_lfXiwPpZ/
    originaldir=pwd()
    #println(originaldir)

    cd(classeur_utilisateur)

    
    #println(pwd())
    utilisateur=splitdir(classeur_utilisateur)[2]*".tar.zip"
    latelier=replace(splitdir(classeur_utilisateur)[2],"task_" => "atelier_")
    #println(utilisateur, "  <- tar va faire <-  ",latelier)
    try 
        cmd=`tar -zcvf  $utilisateur $latelier`
        #println(cmd)
        run(pipeline(cmd,stdout=devnull,stderr=devnull))#,stdout="dev/null",stderr="dev/null"))
        
    catch
        println(" ERREUR   targz ",latelier,"   ")
        
    end

    cd(originaldir)
    #println("retour...",pwd())
    return utilisateur

end

### le modèle d'appel TCP qui sera intégré dynamiquement dans le site
function appeltcp(arbeit::Vector{String},setproteines::Vector{String},paramètresqualité::Vector{String},diruseur::String)
    # Define the server's host and port
    host = "0.0.0.0"  # Localhost or the actual IP of the server listen(IPv4("0.0.0.0"), 8080)
    port = 8080       # Ensure this matches the server's port

    # Create a TCP connection to the server
    try
        sock = connect(host, port)
        response = readline(sock)  # Reads one line from the server
        println("réponse $response")
        println("Connected to server at $host:$port \n")
        
        
        # Prepare the message to send ["ul30", "us10", "ul1", "us14"],["Esch","Dickey","Shig"],["#T","#R","#C"],"/Users/jean-pierreflandrois/Documents/Xtract/"
        #message="ul1,us10;Esch,Dickey,Shig;#T,#R,#C;/Users/jean-pierreflandrois/Documents/Xtract/"
        tutti::Vector{String}=["16SrDNA", "23SrDNA", "5SrDNA", "bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9", "al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]
        # tests  tutti::Vector{String}=["16SrDNA", "ul1", "ul2", "ul3", "us2", "us3", "us4"]
        query::String="Bacillota" #"Esch,Dickey,Staphy" #"GCA_020907805.1" #"Esch,Dickey,Shig" #"Bacteria,Archaea"
        qual::String=""# #T,#R,#E"
        for ti in tutti
            message="F1;$ti;$query;$qual;$diruseur\n"
        #message="FM; ;Esch,Dickey,Shig;#T,#R,#U;/Users/jean-pierreflandrois/Documents\n"
        # (old) message = "RiboDB_16SrDNA,>Methanobrevibacter_woesei|na#U~GCA_020907805.1~K8V75_07880~190976~11~valid=Archaea-Euryarchaeota-Methanobacteria-Methanobacteriales-Methanobacteriaceae-Methanobrevibacter-Methanobrevibacter_woesei\n"
            println("\n**\nSending message: $message")
            write(sock, message)
            
            # Read the server's response
            response = readline(sock)  # Reads one line from the server
            println("réponse $response")
            responsevect::Vector{String}=[String(i) for i in split(response,';')]
            #println("$response")
            println(responsevect)
        end
        # Close the connection
        close(sock)
        println("Connection closed.")
    catch err
        println("Error: ", err)
    end
end

function selecteurΣfamilles(nomsets::Vector{String}) # bactprot archprot universaux
    familia=Dict("rdna" => ["16SrDNA", "23SrDNA", "5SrDNA"], "universaux"  => ["ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9"],
"bactprot"=>["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23"],
"archprot"=>["al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"])

    Σfam=[]
    for i in nomsets  
        Σfam=union(Σfam,familia[i])
    end 
    return Σfam
end
end
