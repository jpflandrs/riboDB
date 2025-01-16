"""
Module_fonctions_recherche.jl Le système de sélection des options du serveur TCP de riboDB

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
module Module_fonctions_recherche

export abinitiowhichresearch,fuzzil,recherche1_0,recherche2_0,recherche3_0,recherche4_0,recherche5_0,recherche1_1,recherche2_1,recherche3_1,recherche4_1,recherche5_1,recherche1_2,recherche2_2,recherche3_2,recherche4_2,recherche5_2,
recherche1_3,recherche2_3,recherche3_3,recherche4_3,recherche5_3,importestatistiquesbnf

function abinitiowhichresearch(vecteurmotpartiel::Vector{String},vecteurqualité::Vector{String})
    #println(" selection  ",vecteurmotpartiel,"  ",vecteurqualité)
    fuzzil(vecteurmotpartiel::Vector{String},vecteurqualité::Vector{String}) #fixe le mode de recherche incomplete 
end

function fuzzil(vecteurmotpartiel::Vector{String},vecteurqualité::Vector{String})
    #deballage des cas possibles et on va affecter une fonction pour les différents cas 
    lmp=length(vecteurmotpartiel)
    if lmp==1
        if vecteurqualité == [""]
            recherche1_0
        elseif length(vecteurqualité) ==1
            recherche1_1
        elseif length(vecteurqualité) ==2
            recherche1_2
        elseif length(vecteurqualité) ==3
            recherche1_3
        end
    elseif lmp==2
        if vecteurqualité == [""]
            recherche2_0
        elseif length(vecteurqualité) ==1
            recherche2_1
        elseif length(vecteurqualité) ==2
            recherche2_2
        elseif length(vecteurqualité) ==3
            recherche2_3
        end
    elseif lmp==3
        if vecteurqualité == [""]
            recherche3_0
        elseif length(vecteurqualité) ==1
            recherche3_1
        elseif length(vecteurqualité) ==2
            recherche3_2
        elseif length(vecteurqualité) ==3
            recherche3_3
        end
    elseif lmp==4
        if vecteurqualité == [""]
            recherche4_0
        elseif length(vecteurqualité) ==1
            recherche4_1
        elseif length(vecteurqualité) ==2
            recherche4_2
        elseif length(vecteurqualité) ==3
            recherche4_3
        end
    elseif lmp==5
        if vecteurqualité == [""]
            recherche5_0
        elseif length(vecteurqualité) ==1
            recherche5_1
        elseif length(vecteurqualité) ==2
            recherche5_2  
        elseif length(vecteurqualité) ==3
            recherche5_3
        end
    end
end

#   recherche1
function recherche1_0(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon))
end
function recherche1_1(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon))  && (occursin(vecteurqualité[1],irayon))
end
function recherche1_2(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon))
end
function recherche1_3(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon) || occursin(vecteurqualité[3],irayon))
end
# recherche2
function recherche2_0(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon))
end
function recherche2_1(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    #println(vecteurqualité[1],"   ",irayon)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon))  && (occursin(vecteurqualité[1],irayon))
end
function recherche2_2(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    #println("MP ",motpartiel[1],"  ",motpartiel[2],"  Q ",vecteurqualité[1],"  ",vecteurqualité[2])
    # if (occursin(motpartiel[2],irayon))
    #     println("2     ",irayon,vecteurqualité[1],vecteurqualité[2],"  u  ",(occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon)),"  Σ ",(occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon)))
    #     #stop()
    # end
    # if (occursin(motpartiel[1],irayon))
    #     println("1     ",irayon,vecteurqualité[1],vecteurqualité[2],"  u  ",(occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon)),"  Σ ",(occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon)))
    #     #stop()
    # end
    #println((occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon)))
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon))

end
function recherche2_3(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon) || occursin(vecteurqualité[3],irayon))
end

# recherche3  
function recherche3_0(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) ||  occursin(motpartiel[3],irayon))
end
function recherche3_1(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon))  && (occursin(vecteurqualité[1],irayon))
end
function recherche3_2(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon))
end
function recherche3_3(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon) || occursin(vecteurqualité[3],irayon))
end

# recherche4
function recherche4_0(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon))
end
function recherche4_1(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon))  && (occursin(vecteurqualité[1],irayon))
end
function recherche4_2(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon))
end
function recherche4_3(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon) || occursin(vecteurqualité[3],irayon))
end

# recherche5 
function recherche5_0(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon) || occursin(motpartiel[5],irayon))
end
function recherche5_1(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon) || occursin(motpartiel[5],irayon))  && (occursin(vecteurqualité[1],irayon))
end
function recherche5_2(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon) || occursin(motpartiel[5],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon))
end
function recherche5_3(motpartiel::Vector{String},vecteurqualité::Vector{String},irayon::String)
    (occursin(motpartiel[1],irayon) || occursin(motpartiel[2],irayon) || occursin(motpartiel[3],irayon) || occursin(motpartiel[4],irayon) || occursin(motpartiel[5],irayon))  && (occursin(vecteurqualité[1],irayon) || occursin(vecteurqualité[2],irayon) || occursin(vecteurqualité[3],irayon))
end

function importestatistiquesbnf()
    #seulement la lecture des données
    diris="STATSRIBODB"
    encyclop::Dict{String,Vector{Int64}}=deserialize(joinpath(diris,"ENCYCLOPRIBODB.ser"))
    #titres::Vector{String}=deserialize(joinpath(diori,diris,"TITRESENCYCLOP.ser")) #ecrit en dur 
    return(encyclop)
end

end #module
