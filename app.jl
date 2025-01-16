module App
using GenieFramework


using GenieFramework.Genie.Requests: postpayload

route("/") do
    Html.div([h1("Here is the riboDB server")], [h2("riboDB")], [p("Exploring the ribosomal proteins of prokaryotes")], [a(href="https://github.com/jpflandrs/riboDB/wiki","Help in riboDB Wiki")],[p("  ")],[a(href="http://ribodb.univ-lyon1.fr/miningribodb","Mining riboDB")],
    [h1("Another site available: PkXplore")], [h2("PkXplore")], [p("From rDNA and other nucleic sequences to phylogeny of Prokaryotes")], [a(href="https://github.com/jpflandrs/PkXplore/wiki","Help in PkXplore Wiki")],[p("  ")],[a(href="https://pkxplore.univ-lyon1.fr/nucworkshop","Querying PkXplore")],
    [ h1("Old sites")],
    [p("these sites may be functionning by chance")], [a(href="https://umr5558-bibiserv.univ-lyon1.fr/mubii/mubii-in.cgi","MUBII tuberculosis (obsolete)") ],[p("   ")],[ a(href="https://umr5558-proka.univ-lyon1.fr/PKPhy/PKPhy.html","leBIBI (obsolete) see PkXplore") ]
    ) 
end




include("riboDBsite.jl")
include("moduletest.jl")
end

