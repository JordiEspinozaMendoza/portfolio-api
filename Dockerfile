FROM node:16
# Installing libvips-dev for sharp Compatability
RUN apt-get update && apt-get install libvips-dev -y
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
WORKDIR /home/node 
COPY --chown=node:node ./package.json ./ 
COPY --chown=node:node ./yarn.lock ./ 
ENV PATH /home/node/node_modules/.bin:$PATH 
USER node 
RUN yarn config set network-timeout 600000 -g 
RUN yarn add pg knex 
RUN yarn add @strapi/provider-email-nodemailer 
RUN yarn add @strapi/provider-email-amazon-ses 
RUN yarn install 
WORKDIR /home/node/app 
COPY --chown=node:node ./ . 
USER root 
RUN chown -R node:node /home/node 
USER node 
RUN yarn build 
EXPOSE 1337 
CMD ["yarn", "start"]