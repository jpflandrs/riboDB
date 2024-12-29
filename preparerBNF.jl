# function mélangerlesribo(D1::String,D2::String) #on donne les deux fichiers actuellement
#     bac::Vector{String}=lisclasseur(D1,false)
#     arc::Vector{String}=lisclasseur(D2,false)
#     # println(typeof(bac))
#     union_ab::Vector{String}=union(bac,arc)
#     communs::Vector{String}=[nom for nom in intersect(bac,arc) if occursin("DNA",nom)==0]#intersect(bac,arc)
#     dnarna::Vector{String}=[nom for nom in intersect(bac,arc) if occursin("DNA",nom)==1]
#     println(dnarna)
#     bac_seul::Vector{String}=setdiff(bac,arc)
#     arc_seul::Vector{String}=setdiff(arc,bac)
#     #Pour avoir les sorties décommenter !
#     # println("Union ",bac_arch)
#     # println("Communs ",bac_i_arch)
#     # println("B" ,bac_seul)
#     # println("A ",arc_seul)
#     # union_ab =["16SrDNA", "23SrDNA", "5SrDNA", "bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9", "al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]
#     # communs=["16SrDNA", "23SrDNA", "5SrDNA", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9"]
#     # bacteriapropres=["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23"]
#     # archaeapropres=["al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]
#     # return union_ab, communs ,bac_seul, arc_seul
#     ## ON VA lire copier les Communs B et A et mélanger dans un même classeur et les uniques sont seulement copiés
#     positiondir::String=dirname(D1)
#     if isdir(joinpath(positiondir,"ENSEMBLEdesRP"))
#         rm(joinpath(positiondir,"ENSEMBLEdesRP"),recursive=true)
#     end
#     mkdir(joinpath(positiondir,"ENSEMBLEdesRP"))
#     for v in [communs]
#         for j in v
#             mkdir(joinpath(positiondir,"ENSEMBLEdesRP",j))
#             for i in ["_prot_uniques.fasta","_prot_multiples.fasta","_nuc_uniques.fasta","_nuc_multiples.fasta"]
#                 commeuncat(joinpath(D1,j,j*i),joinpath(D2,j,j*i),joinpath(positiondir,"ENSEMBLEdesRP",j,j*i))
#             end
#         end
#     end
#     for j in dnarna #RiboDB_16SrDNA.fst
#         mkdir(joinpath(positiondir,"ENSEMBLEdesRP",j))
#         commeuncat(joinpath(D1,j,"RiboDB_"*j*".fst"),joinpath(D2,j,"RiboDB_"*j*".fst"),joinpath(positiondir,"ENSEMBLEdesRP",j,"RiboDB_"*j*".fst"))
#     end
#     for v in [(bac_seul,"BACTERIA"),(arc_seul,"ARCHAEA")]
#         for j in v[1]
#             mkdir(joinpath(positiondir,"ENSEMBLEdesRP",j))
#             for i in ["_prot_uniques.fasta","_prot_multiples.fasta","_nuc_uniques.fasta","_nuc_multiples.fasta"]
#                 cp(joinpath(positiondir,v[2],j,j*i),joinpath(positiondir,"ENSEMBLEdesRP",j,j*i))
#             end
#         end
#     end
# end

try
    using Serialization
catch
    import Pkg
    Pkg.add("Serialization")     
    using Serialization
end

function mélangersérialiserlesribo(D1::String,D2::String) #on donne les deux fichiers actuellement
    bac::Vector{String}=lisclasseur(D1,false)
    arc::Vector{String}=lisclasseur(D2,false)
    # println(typeof(bac))
    union_ab::Vector{String}=union(bac,arc)
    communs::Vector{String}=[nom for nom in intersect(bac,arc) if occursin("DNA",nom)==0]#intersect(bac,arc)
    dnarna::Vector{String}=[nom for nom in intersect(bac,arc) if occursin("DNA",nom)==1]
    bac_seul::Vector{String}=setdiff(bac,arc)
    arc_seul::Vector{String}=setdiff(arc,bac)
    #Pour avoir les sorties décommenter !
    # println("Union ",bac_arch)
    # println("Communs ",bac_i_arch)
    # println("B" ,bac_seul)
    # println("A ",arc_seul)
    # union_ab =["16SrDNA", "23SrDNA", "5SrDNA", "bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9", "al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]
    # communs=["16SrDNA", "23SrDNA", "5SrDNA", "ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9"]
    # bacteriapropres=["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23"]
    # archaeapropres=["al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"]
    # return union_ab, communs ,bac_seul, arc_seul
    ## ON VA lire copier les Communs B et A et mélanger dans un même classeur et les uniques sont seulement copiés
    positiondir::String=dirname(D1)
    if isdir(joinpath(positiondir,"ENSEMBLEdes_serRP_V2"))
        rm(joinpath(positiondir,"ENSEMBLEdes_serRP_V2"),recursive=true)
    end
    mkdir(joinpath(positiondir,"ENSEMBLEdes_serRP_V2"))
    for v ∈ [communs]
        for j ∈ v
            mkdir(joinpath(positiondir,"ENSEMBLEdes_serRP_V2",j))
            for i ∈ ["_prot_uniques.fasta","_prot_multiples.fasta","_nuc_uniques.fasta","_nuc_multiples.fasta"]
                iser=replace(i,".fasta" => ".ser")
                serializedcat(joinpath(D1,j,j*i),joinpath(D2,j,j*i),joinpath(positiondir,"ENSEMBLEdes_serRP_V2",j,j*iser))
            end
        end
    end
    for j ∈ dnarna #ce n'est plus RiboDB_16SrDNA.fst mais 16SrDNA.fst pour harmoniser 
        iser=j*"_nuc.ser"
        println(joinpath(positiondir,"ENSEMBLEdes_serRP_V2",j,iser))
        mkdir(joinpath(positiondir,"ENSEMBLEdes_serRP_V2",j))
        serializedcat(joinpath(D1,j,j*".fst"),joinpath(D2,j,j*".fst"),joinpath(positiondir,"ENSEMBLEdes_serRP_V2",j,iser))
    end
    for v ∈ [(bac_seul,"BACTERIA"),(arc_seul,"ARCHAEA")]
        for j ∈ v[1]
            mkdir(joinpath(positiondir,"ENSEMBLEdes_serRP_V2",j))
            for i ∈ ["_prot_uniques.fasta","_prot_multiples.fasta","_nuc_uniques.fasta","_nuc_multiples.fasta"]
                iser=replace(i,".fasta" => ".ser")
                serializedcat(joinpath(positiondir,v[2],j,j*i),"nihil",joinpath(positiondir,"ENSEMBLEdes_serRP_V2",j,j*iser))
            end
        end
    end
end

function serializedcat(filea::String,fileb::String,ciblefile::String)
    monfastamiracle::Dict{String,String}=Dict([])
    # println(filea,"   +   ",fileb,"  ->  ",ciblefile)
    fileb == "nihil" ? ffs=[filea] : ffs=[filea,fileb]
    # println(ffs)
    for f ∈ ffs
        # println("sercat->",f,"  ldic  ",length(keys(monfastamiracle)))
        monfastamiracle=masolutiondictionnaire(f,monfastamiracle)
        # println("post sercat  ldic  ",length(keys(monfastamiracle)))
    end
    serialize(ciblefile, monfastamiracle)
end

function masolutiondictionnaire(initialfasta::String,monfastamiracle::Dict{String,String})
    localfasta::String = ""
    localtete1::String = ""
    localtete2::String = ""
    fileis = open(initialfasta) do f
        while  !eof(f)
            for l in eachline(f)
                if startswith(l,'>')
                    if localfasta != "" 
                        monfastamiracle[localtete1]=localtete2*localfasta #NB normalement sur une ligne donc pas besoin...
                        # println(localtete,"  ",monfastamiracle[localtete])
                    end
                    localtete1 = rsplit(strip(join(reverse(split(split(String(l),'=')[2],'-' )),'-')*'#'*split(split(String(l),'#' ; limit=2)[2],"!!")[1],'~'),'~'; limit=2)[1]
                    localtete2 = occursin("!!",l) ? strip(split(l,"!!";limit=2)[1],'~')*'='*join(split(split(l,'=')[2],'-')[1:end-1],'-')*'\n' : l*'\n'
                    #>Escherichia_coli|HT873X1#C~GCF_030142415.1~NZ_CP122318.1~[4098325..4098630]~562~11~!!QCG45_RS20045!36!122!0_RP.!!C.=Bacteria-Pseudomonadota-Gammaproteobacteria-Enterobacterales-Enterobacteriaceae-Escherichia-Escherichia_coli
                    # donne "Escherichia_coli-Escherichia-Enterobacteriaceae-Enterobacterales-Gammaproteobacteria-Pseudomonadota-Bacteria#C~GCF_030142415.1~NZ_CP122318.1~[4098325..4098630]~562~11"
                    # on simplifie pour accélérer les tris et clarifier les sorties 
                    # on place l'espèce en tête car c'est le plus demandé enfin je pense... 
                    localfasta=""
                    
                    #">Escherichia_coli|HT873X1#C~GCF_030142415.1~NZ_CP122318.1~[4098325..4098630]~562~11=Bacteria-Pseudomonadota-Gammaproteobacteria-Enterobacterales-Enterobacteriaceae-Escherichia"
                else  #if l ≠ ""
                    localfasta = String(strip(l,['\n','-',' ']))
                end
            end
        end
    end
    
    return monfastamiracle
end

function lisclasseur(classeur::String,tagjoin::Bool)
    classeur[end] == '/' ? classeur=classeur[1:(end-1)] : classeur
    monclasseur::Vector{String}=[]
    tagjoin ? monclasseur=readdir(classeur,join=true) : monclasseur=readdir(classeur)
    deleteat!(monclasseur,findall(x->x==".DS_Store",monclasseur)) #.DS_Store
    deleteat!(monclasseur,findall(x->x==classeur*"/.DS_Store",monclasseur)) #.DS_Store
    return monclasseur
end

function main()

    #doua
    # D1="/Users/jean-pierreflandrois/RIBODB/BANQUES/RiboDBBacteria"
    # D2="/Users/jean-pierreflandrois/RIBODB/BANQUES/RiboDBArchaea"
    # #home
    D1="/Users/jean-pierreflandrois/Documents/ProtéinesBacteria1612/RIBODB/BACTERIA"
    D2="/Users/jean-pierreflandrois/Documents/ProtéinesBacteria1612/RIBODB/ARCHAEA"
    mélangersérialiserlesribo(D1,D2)


end

main()