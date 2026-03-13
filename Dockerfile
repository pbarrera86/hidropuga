FROM rocker/shiny:4.4.1
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City
ARG CACHE_BUST=4
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libfontconfig1-dev \
    libcairo2-dev \
    libxt-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    libmariadb-dev \
    libsodium-dev \
    ca-certificates \
    curl \
    wget \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*
RUN R -e "options(repos='https://cloud.r-project.org'); install.packages(c(\
  'shiny','dplyr','shinyjs','DT','emayili',\
  'DBI','RMySQL','sodium','jsonlite'\
), Ncpus = parallel::detectCores())"
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN mkdir -p /srv/shiny-server /var/log/shiny-server && \
    chown -R shiny:shiny /srv/shiny-server /var/log/shiny-server /etc/shiny-server
EXPOSE 3838
CMD ["shiny-server"]
