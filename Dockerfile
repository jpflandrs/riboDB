#ribodb
FROM julia:1.11

# Create user and set up directories
RUN useradd --create-home --shell /bin/bash genie
RUN mkdir /home/genie/app
COPY . /home/genie/app
WORKDIR /home/genie/app
COPY Project.toml /home/genie/app/

# Set ownership
RUN chown -R genie:genie /home/

# Switch to genie user
USER genie

# Configure ports
EXPOSE 8000
EXPOSE 80

# Préparer l'environnement Julia
RUN julia -e 'using Pkg; Pkg.Registry.add("General")'
RUN julia -e 'using Pkg; Pkg.add("JuliaFormatter")'

# ⚠️ Important : forcer l’installation d’OpenSSL_jll avant l’instanciation
RUN julia -e 'using Pkg; Pkg.add("OpenSSL_jll")'

ENV JULIA_DEPOT_PATH="/home/genie/.julia"
ENV JULIA_REVISE="off"
ENV GENIE_ENV="prod"
ENV GENIE_HOST="0.0.0.0"
ENV PORT="8008"
ENV WSPORT="8008"
ENV EARLYBIND="true"

# Instancier ton projet
RUN julia --project=. -e 'using Pkg; Pkg.resolve(); Pkg.instantiate(); Pkg.precompile()'

# Install Julia packages
# RUN julia -e "using Pkg; Pkg.activate(\".\"); Pkg.instantiate(); Pkg.precompile();"

ENTRYPOINT ["julia", "--project", "-e", "using GenieFramework; Genie.loadapp(); up(async=false);"]
