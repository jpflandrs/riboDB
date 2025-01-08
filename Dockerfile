#FromPlatformFlagConstDisallowed: FROM --platform flag should not use constant value "linux/amd64"
FROM julia:latest 

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

# Set environment variables LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format
ENV JULIA_DEPOT_PATH="/home/genie/.julia"
ENV JULIA_REVISE="off"
ENV GENIE_ENV="prod"
ENV GENIE_HOST="0.0.0.0"
ENV PORT="8008"
ENV WSPORT="8008"
ENV EARLYBIND="true"

# Install Julia packages
RUN julia -e "using Pkg; Pkg.activate(\".\"); Pkg.instantiate(); Pkg.precompile();"

ENTRYPOINT ["julia", "--project", "-e", "using GenieFramework; Genie.loadapp(); up(async=false);"]
