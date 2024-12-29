try
    using Sockets
catch
    import Pkg
    Pkg.add("Sockets")     
    using Sockets
end
try
    using Dates
catch
    import Pkg
    Pkg.add("Dates")     
    using Dates
end
try
    using Random
catch
    import Pkg
    Pkg.add("Random")     
    using Random
end


function putzen(classeur::String)
    
    monclasseur::Vector{String}=readdir(classeur,join=true)
    timestamp::Int64=renvoieepoch()
    for u in monclasseur
        if occursin("task",u)
            #println(u," ",parse(Int64,split(u,'_')[2])-timestamp) #tester
            if timestamp - parse(Int64,split(u,'_')[2]) >3600000
                rm(u, recursive=true)
            end
        end
    end
end

function renvoieepoch()
    dte=datetime2epoch(x::DateTime) = (Dates.value(x) - Dates.UNIXEPOCH)
    return dte(now())
end

function uniqueutilisateur()
    timestamp::String=string(renvoieepoch())
    random_string::String = randstring(8)  # 8-char random
    fichtempo::String =  joinpath(pwd(),"public","utilisateurs","task_$(timestamp)_$(random_string)")
    mkdir(fichtempo)
    atelier::String=joinpath(fichtempo,"atelier_"*timestamp*"_"*random_string)
    mkdir(atelier)
    putzen(joinpath(pwd(),"public","utilisateurs"))
    return atelier
end

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

function appeltcp()
    # Define the server's host and port
    host = "127.0.0.1"  # Localhost or the actual IP of the server
    port = 8080         # Ensure this matches the server's port

    # Create a TCP connection to the server
    try
        sock = connect(host, port)
        println("Connected to server at $host:$port \n")
        diruseur=uniqueutilisateur()
        #println(diruseur)
        # Prepare the message to send ["ul30", "us10", "ul1", "us14"],["Esch","Dickey","Shig"],["#T","#R","#C"],"/Users/jean-pierreflandrois/Documents/Xtract/"
        #message="ul1,us10;Esch,Dickey,Shig;#T,#R,#C;/Users/jean-pierreflandrois/Documents/Xtract/"
        tutti::Vector{String}=["16SrDNA", "23SrDNA", "5SrDNA", "bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9", "al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]
        query::String="Bacillota" #"Esch,Dickey,Staphy" #"GCA_020907805.1" #"Esch,Dickey,Shig" #"Bacteria,Archaea"
        qual::String=""# #T,#R,#E"
        for ti in tutti
            message="F1;$ti;$query;$qual;$diruseur\n"
            #println(message)
        #message="FM; ;Esch,Dickey,Shig;#T,#R,#U;/Users/jean-pierreflandrois/Documents\n"
        # (old) message = "RiboDB_16SrDNA,>Methanobrevibacter_woesei|na#U~GCA_020907805.1~K8V75_07880~190976~11~valid=Archaea-Euryarchaeota-Methanobacteria-Methanobacteriales-Methanobacteriaceae-Methanobrevibacter-Methanobrevibacter_woesei\n"
            #println("Sending message: $message")
            write(sock, message)
            
            # Read the server's response
            response = readline(sock)  # Reads one line from the server
            
            println("Server response: $response")
        end
        # Close the connection
        close(sock)
        println("Connection closed.")
    catch err
        println("Error: ", err)
    end
end

appeltcp()
# using Sockets

# # Define the server's host and port
# host = "127.0.0.1"  # Localhost or the actual IP of the server
# port = 8080         # Ensure this matches the server's port

# try
#     # Create a TCP connection to the server
#     sock = connect(host, port)
#     println("Connected to server at $host:$port")
    
#     # Prepare the message to send
#     message = "RiboDB_16SrDNA,>Methanobrevibacter_woesei|na#U~GCA_020907805.1~K8V75_07880~190976~11~valid=Archaea-Euryarchaeota-Methanobacteria-Methanobacteriales-Methanobacteriaceae-Methanobrevibacter-Methanobrevibacter_woesei\n"
#     println("Sending message: $message")
#     write(sock, message)
    
#     # Read the server's response (handle multiple lines)
#     println("Reading response from server:")
#     while !eof(sock)  # Continue reading until the connection is closed or no more data
#         response_line = readline(sock)
#         println("Server response: $response_line")
#     end
    
#     # Close the connection
#     close(sock)
#     println("Connection closed.")
# catch err
#     println("Error: ", err)
# end

# try
#     sock = connect(host, port)
#     println("Connected to server at $host:$port")
    
#     message = "SomeRequest\n"
#     write(sock, message)
    
#     println("Reading response from server:")
#     for line in eachline(sock)
#         if line == "END"  # Assuming "END" is the delimiter
#             break
#         end
#         println("Server response: $line")
#     end
    
#     close(sock)
#     println("Connection closed.")
# catch err
#     println("Error: ", err)
# end
