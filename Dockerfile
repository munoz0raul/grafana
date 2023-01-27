FROM node:16-alpine3.15 as js-builder

ENV NODE_OPTIONS=--max_old_space_size=8000

WORKDIR /grafana

COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn .yarn
COPY packages packages
COPY plugins-bundled plugins-bundled

RUN apk add --no-cache git make clang build-base python3

RUN yarn install

COPY tsconfig.json .eslintrc .editorconfig .browserslistrc .prettierrc.js babel.config.json .linguirc ./
COPY public public
COPY tools tools
COPY scripts scripts
COPY emails emails

ENV NODE_ENV production
RUN yarn build


FROM grafana/grafana:9.3.6

COPY --from=js-builder /grafana/public ./public
COPY --from=js-builder /grafana/tools ./tools
COPY grafana.db /var/lib/grafana/grafana.db
COPY grafana.ini /etc/grafana/grafana.ini

USER root
RUN apk add --no-cache vim git

USER grafana
ENTRYPOINT [ "/run.sh" ]

