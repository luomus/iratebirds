FROM rocker/shiny-verse

ARG PGUSER
ARG PGPASSWORD

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

RUN install2.r --error -s \
      auk \
      httr \
      jsonlite \
      RPostgres \
      shinyalert \
      waiter \
  && installGithub.r hadley/emo \
  && echo "PGHOST='postgres'" >> /usr/local/lib/R/etc/Renviron.site \
  && echo "PGUSER='${PGUSER}'" >> /usr/local/lib/R/etc/Renviron.site \
  && echo "PGPASSWORD='${PGPASSWORD}'" >> /usr/local/lib/R/etc/Renviron.site \
  && rm -rf /tmp/downloaded_packages
