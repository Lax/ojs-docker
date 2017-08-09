FROM debian
ENV HOME_DIR /var/ojs_home
ENV WORK_DIR /var/ojs_home/src

RUN apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends curl gnupg git composer phpunit php-curl php-dom php-zip \
    && curl -sL http://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -qq -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/* \
    && npm install npm@latest -g

RUN useradd -m -d $HOME_DIR -s /bin/bash ojs
USER ojs

RUN git clone https://github.com/Lax/ojs.git $WORK_DIR
WORKDIR $WORK_DIR
RUN git submodule update --init --recursive
RUN cd lib/pkp && composer update
RUN cd plugins/paymethod/paypal && composer update
RUN cp config.TEMPLATE.inc.php config.inc.php
RUN npm install && npm run build
CMD ["php", "-S", "0.0.0.0:8000"]
