

module Module_moteur_serveur



include("Module_fonctions_recherche.jl")
include("Module_ancilla.jl")

using .Module_fonctions_recherche, .Module_ancilla

export approx_cherche, extraitparbatchfamilles, extraitunefamille, init_werkstatt


function approx_cherche(montrieur::Function,rayon::Dict{String,String},motpartiel::Vector{String},qualitet::Vector{String}=[])#approx_cherche(montrieur,encyclo[famille][rayon],motpartiel,qualitet)
    vecteurfasta::Vector{String}=[]
    #println(rayon)
    for i in keys(rayon) #rayon de famille
       if montrieur(motpartiel,qualitet,i) #occursin(motpartiel[1],irayon) && (occursin(vecteurqualité[1],irayon))
            # println("gardé ",i,"  /n")
            push!(vecteurfasta,rayon[i])
            # push!(vecteurfasta,join([i,rayon[i]],"\n")) #version avec nom tout complet y compris ~!!qualité... .=
            
        end
    end
    return (string(length(vecteurfasta)),join(vecteurfasta,"\n"))
end


function extraitparbatchfamilles(encyclo::Dict{String,Dict{String,Dict{String,String}}},listefamilles::Vector{String},motpartiels::Vector{String},qualitet::Vector{String},basefichiersorties::String,sauver::Bool)
    montrieur::Function=abinitiowhichresearch(motpartiels,qualitet)
    #initialisateur des classeurs
    greatdirout::String=creationclientdir(basefichiersorties)
    #println(greatdirout,"  créé")
    message::Vector{String}=[]
    for famille in listefamilles #us1... bl17 ... 
        push!(message,famille)
        subgreatdirout::String=faitclasseurfamille(greatdirout,famille)
        #println(subgreatdirout,"  créé")
        for rayon in sort(collect(keys(encyclo[famille])),rev=true) # 16SrDNA => 16SrDNA_nuc.ser, p1p2 => _nuc_multiples.ser ... p1p2_prot_multiples.ser ...p1p2_nuc_uniques.ser ... p1p2_prot_uniques.ser
            # ici renversé pour avoir l'ordre prot-nuc et unique-multiple
            # mais même sans intérêt pour le 16/23/(S on garde
            push!(message,rayon)
            fichiersorties::String=identifiepositionfichier(greatdirout,famille,rayon*".fasta") #public/atelier...atelierXXX/p1p2/p1p2_prot_multiples.ser
            # push!(metaglanage,approx_cherche(encyclo[famille][rayon],motpartiel)) #renvoie une string de tout
            #println(approx_cherche(montrieur,encyclo[famille][rayon],motpartiels,qualitet))
            messageetfichiers=approx_cherche(montrieur,encyclo[famille][rayon],motpartiels,qualitet)
            
            if sauver
                sauveflattoflat(messageetfichiers[2],fichiersorties) #join final
            end
            
            push!(message,messageetfichiers[1])
        end
        push!(message,"NEXT")
    end
    return join(message,";") #dans ce cas on renvoie un à la fois
end

function extraitunefamille(encyclo::Dict{String,Dict{String,Dict{String,String}}},listefamilles::Vector{String},motpartiels::Vector{String},qualitet::Vector{String},greatdirout::String,sauver::Bool)
    montrieur::Function=abinitiowhichresearch(motpartiels,qualitet)
    
    #println(greatdirout,"  créé")
    message::Vector{String}=[]
    for famille in listefamilles #ici une seule 
        if sauver
            subgreatdirout::String=faitclasseurfamille(greatdirout,famille)
        end
        #println(subgreatdirout,"  créé")
        push!(message,famille)
        for rayon in sort(collect(keys(encyclo[famille])),rev=true) # 16SrDNA => 16SrDNA_nuc.ser, p1p2 => _nuc_multiples.ser ... p1p2_prot_multiples.ser ...p1p2_nuc_uniques.ser ... p1p2_prot_uniques.ser
            # ici renversé pour avoir l'ordre prot-nuc et unique-multiple
            # mais même sans intérêt pour le 16/23/(S on garde
            if sauver
                fichiersorties::String=identifiepositionfichier(greatdirout,famille,rayon*".fasta") #public/atelier...atelierXXX/p1p2/p1p2_prot_multiples.ser
            end
            #println(fichiersorties)
            # push!(metaglanage,approx_cherche(encyclo[famille][rayon],motpartiel)) #renvoie une string de tout
            #println(approx_cherche(montrieur,encyclo[famille][rayon],motpartiels,qualitet))
            messageetfichiers=approx_cherche(montrieur,encyclo[famille][rayon],motpartiels,qualitet)
            if occursin("_nuc",rayon) #on fait sur les nuc comme ça on a les 16S etc. aussi
                push!(message,messageetfichiers[1])
            end
            if sauver
                sauveflattoflat(messageetfichiers[2],fichiersorties) #join final
            end
        end
        #println(message)#["ul30", "77771", "198"]

        if length(message)==3 && sauver
            if message[2] == "0" && message[3] == "0"
                rm(subgreatdirout, recursive=true)
            end
        end
    end
    return join(message,";") #dans ce cas on renvoie un à la fois
end

# function init_werkstatt(encyclo::Dict{String,Dict{String,Dict{String,String}}},listefamilles::Vector{String},motpartiels::Vector{String},qualitet::Vector{String},basefichiersorties::String)
#     #initialisateur des classeurs
#     greatdirout::String=creationclientdir(basefichiersorties)
#     return greatdirout
# end

end