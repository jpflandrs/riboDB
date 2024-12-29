
module Module_bnf
try
    using Serialization
catch
    import Pkg
    Pkg.add("Serialization")     
    using Serialization
end

export desreialisation, bnf

function lisclasseur(classeur::String,tagjoin::Bool)
    classeur[end] == '/' ? classeur=classeur[1:(end-1)] : classeur
    monclasseur::Vector{String}=[]
    tagjoin ? monclasseur=readdir(classeur,join=true) : monclasseur=readdir(classeur)
    deleteat!(monclasseur,findall(x->x==".DS_Store",monclasseur)) #.DS_Store
    deleteat!(monclasseur,findall(x->x==classeur*"/.DS_Store",monclasseur)) #.DS_Store
    return monclasseur
end

function desreialisation(inputfile::String)
    monfastamiracle::Dict{String,String}=Dict([])
    monfastamiracle=deserialize(inputfile)
end

function bnf()
    diris="/Users/jean-pierreflandrois/Documents/ProtéinesBacteria1612/RIBODB/ENSEMBLEdes_serRP_V2"
    lescibles::Vector{String}=lisclasseur(diris,true)
    gallica::Dict{String,Dict{String,Dict{String,String}}}=Dict([])
    #println(lescibles)
    for sc in lescibles#[1:2] #cas des testts
        prot::SubString{String}=splitpath(sc)[end]
        #println(prot)
        #subgreatdirout=joinpath("/Users/jean-pierreflandrois/Documents/Xtract/",prot)
        subcibles::Vector{String}=lisclasseur(sc,true)
        #println(subcibles)
        gallica[prot]=Dict([])
        for subsc in subcibles
            #println(prot,"   ",split(splitpath(subsc)[end],'.')[1])
             #split(splitpath(subsc)[end],'.')[1]
            gallica[prot][split(splitpath(subsc)[end],'.')[1]]=desreialisation(subsc)
        end 
    end
    # println(length(gallica))
    # println(keys(gallica))
    #resu=tordue(gallica,cibles,["Enterobacterales"],["#E"],"/Users/jean-pierreflandrois/Documents/Xtract/")
    # pas une bonne idee 
    # serialize("GALLICA.ser", gallica)
    # println("sauver serialisation fait")
    return gallica
end




end #fin module