module ReactiveForm
using GenieFramework
using Stipple
using StippleDownloads
using DataFrames
using Sockets
using Dates
using Random
using Serialization
using CSV
using DataFrames

@genietools

@app begin
    #["statseules", "extraction", "bactprot", "archprot", "universaux", "representatifs", "souchestype", "ensembl", "complet"]
    
    @in CheckboxMultiple_checked = (false, @in(selectionO = []))
    @in selection=["extraction"]
    @in CheckboxMultiple_checked = (false, @in(selectionP = []))
    @in selection=["bactprot","universaux"]
    @in CheckboxMultiple_checked = (false, @in(selectionQ = []))
    @in selectionQ=["representatifs"]
    
    
    
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
    @out ddff = DataTable(DataFrame(Family=String["no data101"],Uniques=String["no data"],Multiples=String["no data"]))
    
    @out pourgzip = ""

    @onchange isready begin
        clearit = false
        selectionO=["extraction"]
        selectionP=["bactprot","universaux"]
        selectionQ=["representatifs"]
    
        ddff = DataTable(DataFrame(Family=String["no data101"],Uniques=String["no data"],Multiples=String["no data"]))
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
            selectionO=["extraction"]
            selectionP=["bactprot","universaux","archprot"]
            selectionQ=["representatifs"]
            S="Esch Staphylococcus_aureus Methanohalo"
        else
            S="??!"
        end
    end
    
    @onbutton clearit begin
        
        clearit = false
        selectionO = []
        selectionP = []
        selectionQ = []
        ddff = DataTable(DataFrame(Family=String["no data101"],Uniques=String["no data"],Multiples=String["no data"]))
        ddff_pagination = DataTablePagination(rows_per_page = 1)
        download_event = false
        downloadinfo = "not Ready"
        
        message = ""
        
        posdsk ="waiting for the link"
        pourgzip = ""
        
        S = "!??"
        
        termine = "Cleared, Ready for a new submission"
        testing = false
        
        travail = false
        trigger = false
        
    end

    @onbutton trigger begin
        println("$selectionO  $selectionP  $selectionQ")
        if selectionO==[] || selectionP==[] || selectionQ==[]
            ticketvalide=false
            termine = "Global Parameters incomplete, please precise your selection"
        end
        #nettoyer avant en cas de non utilisation du bouton clear
        ddff = DataTable(DataFrame(Family=String["no data101"],Uniques=String["no data"],Multiples=String["no data"]))
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
        end
        
       if ticketvalide #on peut y aller
            postdsk=uniqueutilisateursimplifié()
            println(postdsk)
            println(selectionP)
            mesfamilles=selecteurfamilles(selectionP)
            println(mesfamilles)
            optionsx=replace(replace(join(selectionO), "extraction" => "F1", "statseules" => "CNT"), "F1CNT" => "F1")
            genomesafaire=replace(replace(join(selectionQ,','),"representatifs" => "#R", "souchestype" => "#T", "ensembl" => "#E", "complet" => "#C"), "#R,#T" => "#R#T")           
            println(Spresentable,genomesafaire,postdsk)
            host = "0.0.0.0"  # Localhost or the actual IP of the server listen(IPv4("0.0.0.0"), 8080)
            port = 8080       # Ensure this matches the server's port
            vecteurfamillescherchées::Vector{String}=["Family"]
            vecteurprotuniques::Vector{String}=["Unique"]
            vecteurprotmultiples::Vector{String}=["Multiple"]
            ddff = DataTable(DataFrame(Family=String["no data101"],Uniques=String["no data"],Multiples=String["no data"]))
            ddff_pagination = DataTablePagination(rows_per_page = 5)
            # Create a TCP connection to the server
            try
                sock = connect(host, port)
                response = readline(sock)  # Reads one line from the server
                println("réponse $response")
                #println("Connected to server at $host:$port \n")
                
                
                # message="F1;$ti;$query;$qual;$diruseur\n" CNT;us9;Escherichia;#T,#R,#C,#E;1736194681541_ZABY1p6s;
                for funit in mesfamilles
                    message=join([optionsx,funit,Spresentable,genomesafaire,postdsk*"\n"],";") 
                    write(sock, message)
                    response = readline(sock)  # Reads one line from the server
                    println("réponse $response") #/Users/jean-pierreflandrois/Documents/GitHub/TCPriboDB/public/utilisateurs/task_1736200658296_D3ZawUy6/atelier_1736200658296_D3ZawUy6;ul1;18;0
                    responsevect::Vector{String}=[String(i) for i in split(response,';')]
                    push!(vecteurfamillescherchées, responsevect[2])
                    push!(vecteurprotuniques, responsevect[3])
                    push!(vecteurprotmultiples, responsevect[4])
                    println(responsevect) #["/Users/jean-pierreflandrois/Documents/GitHub/TCPriboDB/public/utilisateurs/task_1736200658296_D3ZawUy6/atelier_1736200658296_D3ZawUy6", "ul22", "18", "0"
                    
                    ddff = DataTable(DataFrame(Family=vecteurfamillescherchées,Uniques=vecteurprotuniques,Multiples=vecteurprotmultiples))
                end
                # Close the connection
                close(sock)
                println("Connection closed.")
            catch err
                println("Error: ", err)
            end
        

            S = "EXPLORATION FINISHED\n-------------------\n"*S*"\n-------------------\nEXPLORATION FINISHED\n-------------------\n"
                
            travail = false
            trigger = false
            clearit = false
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

function selecteurfamilles(nomsets) # bactprot archprot universaux
    println(typeof(nomsets))
    familia=Dict("rdna" => ["16SrDNA", "23SrDNA", "5SrDNA"], "universaux"  => ["ul1", "ul10", "ul11", "ul13", "ul14", "ul15", "ul16", "ul18", "ul2", "ul22", "ul23", "ul24", "ul29", "ul3", "ul30", "ul4", "ul5", "ul6", "us10", "us11", "us12", "us13", "us14", "us15", "us17", "us19", "us2", "us3", "us4", "us5", "us7", "us8", "us9"],
"bactprot"=>["bTHX", "bl12", "bl17", "bl19", "bl20", "bl21", "bl25", "bl27", "bl28", "bl31", "bl32", "bl33", "bl34", "bl35", "bl36", "bl9", "bs16", "bs18", "bs20", "bs21", "bs6", "cs23"],
"archprot"=>["al45", "al46", "al47", "el13", "el14", "el15", "el18", "el19", "el20", "el21", "el24", "el30", "el31", "el32", "el33", "el34", "el37", "el38", "el39", "el40", "el41", "el42", "el43", "el8", "es1", "es17", "es19", "es24", "es25", "es26", "es27", "es28", "es30", "es31", "es4", "es6", "es8", "p1p2"])

    fam=[]
    for i in nomsets  
        fam=union(fam,familia[i])
    end 
    return fam
end

#la fonction de création de classeur utilisateur est dans le serveur TCP !
# function uniqueutilisateur()
#     timestamp::String=string(renvoieepoch())
#     random_string::String = randstring(8)  # 8-char random
#     fichtempo::String =  joinpath(pwd(),"public","utilisateurs","task_$(timestamp)_$(random_string)")
#     mkdir(fichtempo)
#     atelier::String=joinpath(fichtempo,"atelier_"*timestamp*"_"*random_string)
#     mkdir(atelier)
#     #putzen(joinpath(pwd(),"public","utilisateurs"))
#     return atelier
# end

# function putzen(classeur::String)
    
#     monclasseur::Vector{String}=readdir(classeur,join=true)
#     timestamp::Int64=renvoieepoch()
#     for u in monclasseur
#         if occursin("task",u)
#             #println(u," ",parse(Int64,split(u,'_')[2])-timestamp) #tester
#             if timestamp - parse(Int64,split(u,'_')[2]) >3600000
#                 rm(u, recursive=true)
#             end
#         end
#     end
# end

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
            checkbox("Statistics ", :selectionO, val = "statseules", color = "grey"),
            checkbox("Extraction ", :selectionO, val = "extraction", color = "grey"),
        ], sm=4),
        column(class="q-pa-sm",
            [[h6("Sets of proteins")],
            checkbox("Universal proteins", :selectionP, val = "universaux", color = "grey"),
            checkbox("Bacteria specific", :selectionP, val = "bactprot", color = "grey"),
            checkbox("Archaea specific", :selectionP, val = "archprot", color = "grey"),
            checkbox("rDNA 16S/23S/5S", :selectionP, val = "rdna", color = "grey"),
        ], sm=4),
        column(class="q-pa-sm",
            [[h6("Quality of the genomes (3 choices max)")],
            checkbox("Representative genomes", :selectionQ, val = "representatifs", color = "grey"),
            checkbox("Type-Strain genomes", :selectionQ, val = "souchestype", color = "grey"),
            checkbox("Genomes tagged as complete", :selectionQ, val = "complet", color = "grey"),
            checkbox("Genomes in Ensembl!", :selectionQ, val = "ensembl", color = "grey"),
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
        Html.div(cell([h5("Statistics"),table(:ddff, paginationsync = :ddff_pagination, flat = true, bordered = true, title = "STATISTICS")]) )
    ]


end

@page("/ribodbreactive", ui)

end

#How to make multiple browser windows independent
# route("/nucworkshop") do                              
#     model = @init(channel = Stipple.channelfactory())
#     page(model, ui) |> html
# end

