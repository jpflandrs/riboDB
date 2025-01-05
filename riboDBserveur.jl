module ReactiveForm
using GenieFramework
using Stipple
using StippleDownloads
using DataFrames
@genietools

@app begin
    #["statseules", "extraction", "bactprot", "archprot", "universaux", "representatifs", "souchestype", "ensembl", "complet"]
    
    @in CheckboxMultiple_checked = (false, @in(selection = []))
    @in selection=["extraction", "bactprot","representatifs"]
    
    
    
    @in trigger = false
    @in clearit = false
    
    @in download_event = false
    
    
    @out travail = false
    
    @in testing = false
    @in ddff_pagination = DataTablePagination(rows_per_page = 1)

    
    @in S = "?!"
    
    @in posdsk::String ="waiting for the link"
    @in downloadinfo::String = "not Ready"
    #@out genomeid = []
    @out termine = "Ready for a new submission"
    #listedesaextraire,lataxinomie,laqualite,evalue,scores,ali_length,identitynumber,identitypc,gapsopen,collection_avec_query
    @out ddff = DataTable(DataFrame(SpeciesGenome=String["no data101"],GenomeId=String["no data"],Quality=String["no data"],Scores=String["NAN"],Evalue=String["NAN"],Ali_Length=String["NAN"],IdentityNumber=String["NAN"],Identity=String["NAN"],GapsOpen=String["NAN"]))# sseqid           stitle                             evalue   bitscore  length  nident  pident   gapopen
    
    @out pourgzip = ""

    @onchange isready begin
        clearit = false
        selection=["extraction", "bactprot","representatifs"]
        ddff = DataTable(DataFrame(SpeciesGenome=String["no data157"],GenomeId=String["no data"],Quality=String["no data"],Scores=String["NAN"],Evalue=String["NAN"],Ali_Length=String["NAN"],IdentityNumber=String["NAN"],Identity=String["NAN"],GapsOpen=String["NAN"]))
        ddff_pagination = DataTablePagination(rows_per_page = 1)
        download_event = false
        downloadinfo = "not Ready"
        
        message = ""
        
        posdsk ="waiting for the link"
        pourgzip = ""
        
        S = "?!"
        
        termine = "Cleared, Ready for a new submission"
        testing = false
        
        travail = false
        trigger = false
    end
    
    @onchange testing begin
        if testing == true
            S="Esch Staphylococcus_aureus Methanohalo"
        else
            S=""
         end
    end
    
    @onbutton clearit begin
        println(selection)
        clearit = false
        selection = []
        ddff = DataTable(DataFrame(SpeciesGenome=String["no data157"],GenomeId=String["no data"],Quality=String["no data"],Scores=String["NAN"],Evalue=String["NAN"],Ali_Length=String["NAN"],IdentityNumber=String["NAN"],Identity=String["NAN"],GapsOpen=String["NAN"]))
        ddff_pagination = DataTablePagination(rows_per_page = 1)
        download_event = false
        downloadinfo = "not Ready"
        
        message = ""
        
        posdsk ="waiting for the link"
        pourgzip = ""
        
        S = ""
        
        termine = "Cleared, Ready for a new submission"
        testing = false
        
        travail = false
        trigger = false
        
    end
    @onbutton trigger begin
        println(selection)
        #nettoyer avant en cas de non utilisation du bouton clear
        ddff = DataTable(DataFrame(SpeciesGenome=String["no data172"],GenomeId=String["no data"],Quality=String["no data"],Scores=String["NAN"],Evalue=String["NAN"],Ali_Length=String["NAN"],IdentityNumber=String["NAN"],Identity=String["NAN"],GapsOpen=String["NAN"]))
        posdsk ="waiting for the link"
        downloadinfo = "not Ready"
        
        download_event = false
        
        ticketvalide=true
        S=strip(S)
        Ssplit=[]
        if S == ""                      #pas vide
            termine = "MISSING QUERY, PLEASE SUBMIT A QUERY"
            S = "MISSING QUERY ! "
            ticketvalide=false
        else
            println(S)
            instructionS=""
            Ssplit=split(strip(S)," ")
            println(Ssplit)
            if length(Ssplit) >5
                termine ="NO MORE THAN 5 ITEMS"
                S=join(Ssplit[1:5]," ")
                ticketvalide=false
            end
            println("A $ticketvalide")
            for u in split(strip(S)," ")
                if length(u) < 4 
                    termine ="each query item must be longer than 5"
                    ticketvalide=false
                else
                    instructionS=instructionS*" "*u
                end
            end
            println("B $ticketvalide")
            Spresentable=join(split(strip(instructionS)," "),',')
            println("présentable $Spresentable")
            #ddff_pagination = DataTablePagination(rows_per_page = 5)
            # if paramètres == false
            #     termine = "Please choose and valid the parameters"
            termine = "Fasta verifications"
        
        
        
       if ticketvalide #on peut y aller
            
            
                #reininitialisation
                S = "EXPLORATION FINISHED\n-------------------\n"*S*"\n-------------------\nEXPLORATION FINISHED\n-------------------\n"
                
                travail = false
                trigger = false
                clearit = false
            end
        end
    end
    @event download_event begin
        downloadinfo = "running..." #/Users/jean-pierreflandrois/Documents/PKDBGENIESTIPPLE/public/utilisateurs/task_20241013_220057_lfXiwPpZ/atelier
        #println("downloda process")
        #println(posdsk)
        pourgzip=compresser(splitdir(posdsk)[1]) #compresser atelier sous le nom de l'utilisateur
        #println("=====")
        #println(pourgzip)
        downloadinfo = pourgzip
        try
            solution = joinpath("public", "utilisateurs", splitdir(posdsk)[1],pourgzip)
            #println("downloading...",joinpath("public", "utilisateurs", splitdir(posdsk)[1],pourgzip))
            io = IOBuffer()
            open(solution, "r") do file 
                write(io, read(file))
            end
            seekstart(io)
            download_binary(__model__,take!(io), pourgzip)
            downloadinfo = "Done !"
            
        catch ex
            println("Error during download: ",ex)
        end
    end

    

end
#[btn("Trigger action", @click(:trigger))]#




# Function to define custom CSS styles taken from https://github.com/BuiltWithGenie/GenieTodo/blob/main/genietodo.jl
function custom_styles()
    ["""
    <style>
        body { background-color: #f4f4f4; }
        .todo-container { max-width: 600px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .todo-header { text-align: center; color: #007bff; padding-bottom: 20px; }
        .todo-input { margin-bottom: 20px; }
        .todo-list { list-style-type: none; padding: 0; }
        .todo-item { display: flex; align-items: center; margin-bottom: 10px; padding: 10px; border-radius: 4px; background-color: #f8f9fa; }
        .todo-item label { margin-left: 10px; flex-grow: 1; }
        .todo-item button { padding: 2px 8px; }
        .todo-filters { margin-bottom: 20px; }
        .todo-filters .btn { margin-right: 5px; }
        .todo-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; }
        .btn-focused { background-color: #007bff; color: white; }
        [v-cloak] { display: none; }
    </style>
    """]
end

function ui()  #btn("valider",color="red",@click("press_btn = true")), # @onbutton start begin
    # cell([
    #     textfield(type="textarea","fasta ?", :N),btn("valider",color="red",@click("press_btn = true")),
    #     p("fasta est {{N}} de longueur is {{m}}") # random numbers is {{m}}
    # ])
    #[btn("Trigger action", @click(:trigger)),p("{{m}}")]

    # Add Bootstrap CSS
    #Stipple.Layout.add_css("https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css")
    # Add custom styles
    Stipple.Layout.add_css(custom_styles)

    [cell([h1("riboDB extractor")])#toolbar("Configuration", class = "bg-primary text-white shadow-2")
    cell([h6("LBBE UMR5558 Université Lyon1-CNRS & Master bioinfo@lyon Université Lyon1"),  a(href="https://github.com/jpflandrs/riboDB","Code")])
    separator(color = "primary")
    p(h5("General Parameters"))
    cell([h5("Global Parameters")])
    row([
        column(class="q-pa-sm",
            [[h6("Options")],
            checkbox("Statistics ", :selection, val = "statseules", color = "grey"),
            checkbox("Extraction ", :selection, val = "extraction", color = "grey"),
        ], sm=4),
        column(class="q-pa-sm",
            [[h6("Sets of proteins")],
            checkbox("Bacteria proteins", :selection, val = "bactprot", color = "grey"),
            checkbox("Archaea proteins", :selection, val = "archprot", color = "grey"),
            checkbox("Universal proteins", :selection, val = "universaux", color = "grey"),
        ], sm=4),
        column(class="q-pa-sm",
            [[h6("Quality of the genomes (3 choices max)")],
            checkbox("Representative genomes", :selection, val = "representatifs", color = "grey"),
            checkbox("Type-Strain genomes", :selection, val = "souchestype", color = "grey"),
            checkbox("Genomes tagged as complete", :selection, val = "complet", color = "grey"),
            checkbox("Genomes in Ensembl!", :selection, val = "ensembl", color = "grey"),
            ], sm=4),
        ])    
    cell([separator(color = "primary")])
    p(h5("Queries")) 
    # [
    #     expansionitem(
    #         label = "Help",
    #         dense = true,
    #         var"dense-toggle" = true,
    #         var"expand-separator" = true,
    #         var"header-class" = "bg-blue-1",
    #         p(
    #             "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.",
    #         ),
    #     ),
    # ]
    cell([textfield(
        "max 5 queries separated by a white-space",
        :S,
        bottomslots = "",
        dense = "",
        [
            template(
                var"v-slot:append" = "",
                [
                    icon(
                        "close",
                        @iif("S !== ''"),
                        @click("S = ''"),
                        class = "cursor-pointer",
                    ),
                ],
            ),
        ],
    )
    ])
    cell([])
    
    cell([btn("Submit", @click(:trigger),loading =:travail,color = "secondary")],[btn("Clear", @click(:clearit)),toggle("exemple use", :testing),])
    cell([separator(color = "primary")]) 
    cell(["Process info: {{termine}}"])
        Html.div(cell([h5("Statistics"),table(:ddff, paginationsync = :ddff_pagination, flat = true, bordered = true, title = "STATISTICS")]), @showif("tcprunning") )
    ]


end
@page("/ribodbreactive", ui)

end

#How to make multiple browser windows independent
# route("/nucworkshop") do                              
#     model = @init(channel = Stipple.channelfactory())
#     page(model, ui) |> html
# end

