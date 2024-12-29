module Module_ancilla

export faitclasseurfamille, identifiepositionfichier, sauveflattoflat, creationclientdir



function creationclientdir(basedir::String)
    greatdirout=joinpath(basedir,"collection")
    try
        mkdir(greatdirout)
    catch
        rm(greatdirout,recursive=true)
        mkdir(greatdirout)
    end 
    return greatdirout
end

function faitclasseurfamille(basedir::String,famille::String)
    subgreatdirout=joinpath(basedir,famille)
    try
        mkdir(subgreatdirout)
    catch
        rm(subgreatdirout,recursive=true)
        mkdir(subgreatdirout)
    end
    return subgreatdirout
end

# function faitclasseursubfamille(basedir::String,famille::String,typefile::String)
#     subdirout=joinpath(basedir,famille,typefile)
#     try
#         mkdir(subdirout)
#     catch
#         rm(subdirout,recursive=true)
#         mkdir(subdirout)
#     end
#     return subdirout
# end

function identifiepositionfichier(basedir::String,famille::String,typefile::String)
    subpos=joinpath(basedir,famille,typefile)
    return subpos
end

# function sauvevectortoflat(vecteurfasta::Vector{String},fichiersorties::String) #avec join
#     io = open(fichiersorties, "w")
#     write(io,join(vecteurfasta,"\n"))
#     close(io)
# end

function sauveflattoflat(fasta::String,fichiersorties::String) #sans join
    io = open(fichiersorties, "w")
    write(io,fasta*"\n")
    close(io)
end

end