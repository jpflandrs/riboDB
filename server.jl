
try
    using Sockets
catch
    import Pkg
    Pkg.add("Sockets")     
    using Sockets
end


include("Module_moteur_serveur.jl")
include("Module_bnf.jl")

using .Module_moteur_serveur, .Module_bnf

function server()
    #gallica::Dict{String, Dict{String, String}} = bnf()
    gallica::Dict{String,Dict{String,Dict{String,String}}}=bnf()
    server = listen(8080)
    println("à l'écoute")
    while true
        conn = accept(server)
        @async begin
            try
                while true
                    # Attempt to read a line from the client
                    line = readline(conn)
                    
                    # Check if the line is empty or the connection is closing
                    if isempty(line)
                        println("Client sent an empty line or connection is closing.")
                        break
                    end

                    # Split the input and validate
                    item = split(line, ";")
                    if length(item) != 5
                        println("Invalid input received: $line")
                        write(conn, "ERROR: Invalid input format\n")
                        continue
                    else
                        fonctionchoisie::String=String(item[1]) #fixé par le site
                        listefamilles::Vector{String}=[String(i) for i in split(item[2],',')] #non fixé formellement par le site donc on fait des contrôles
                        estvalidequery::Bool=true
                        for ii in listefamilles
                            if haskey(gallica, ii) === false
                                estvalidequery=false
                                error_msg = "familly $ii not found"
                                println(error_msg)
                                write(conn, "ERROR: $error_msg\n")
                            else
                                #println("valide")
                            end
                        end        
                        lescibles::Vector{String}=[String(i) for i in split(item[3],',')] #non fixé aucun contrôle possible 
                        lesqualités::Vector{String}=[String(i) for i in split(item[4],',')] #fixé par le site
                        leclasseurperso::String=String(item[5]) #fixé par le site
                        # Process the query
                        #println("Query from client: ",typeof(fonctionchoisie),"   ", listefamilles, "   ", lescibles,"   ",lesqualités,"   ",leclasseurperso)
                        if fonctionchoisie == "F1" #unique pour lancer par une boucle et récupérer ligne à ligne
                            result = extraitunefamille(gallica,listefamilles,lescibles,lesqualités,leclasseurperso,true)
                            write(conn, "RESULT: $result\n")
                        elseif fonctionchoisie  == "CNT" #idem F1 mais comptage
                            result = extraitunefamille(gallica,listefamilles,lescibles,lesqualités,leclasseurperso,false)
                            write(conn, "RESULT: $result\n")
                        elseif fonctionchoisie == "FM" # en bloc, résultats à la fin (pour le labo)
                            result = extraitparbatchfamilles(gallica,listefamilles,lescibles,lesqualités,leclasseurperso)
                            write(conn, "RESULT: $result\n")
                        else
                            error_msg = "function $fonctionchoisie is not valid"
                                println(error_msg)
                                write(conn, "ERROR: $error_msg\n")
                        end
                    # else
                    #     error_msg = "Key not found"
                    #     println(error_msg)
                    #     write(conn, "ERROR: $error_msg\n")
                    end
                end
            catch e
                println("Connection ended with error: ", e)
            finally
                close(conn)  # Ensure the connection is closed
                println("Connection closed.")
            
            end
        end
    end
end

server()