FROM rocker/shiny:4.4.1

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    ca-certificates \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "options(repos='https://cloud.r-project.org'); install.packages(c('shiny','dplyr'))"

RUN mkdir -p /srv/shiny-server /var/log/shiny-server && \
    chown -R shiny:shiny /srv/shiny-server /var/log/shiny-server

EXPOSE 3838

CMD ["shiny-server"]
