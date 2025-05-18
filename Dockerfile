# Usar imagem base do Ruby
FROM ruby:3.2.2

# Instalar dependências do sistema operacional
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

# Definir diretório de trabalho
WORKDIR /app

# Copiar Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar dependências do bundle
RUN bundle install

# Copiar o código da aplicação (incluindo assets)
COPY . .

# Copiar o arquivo de autenticação da API Google Cloud Vision
COPY arquivo_secreto.json /app/

# Precompilar os assets para produção
RUN RAILS_ENV=production SECRET_KEY_BASE=dummy_value bundle exec rake assets:precompile --trace

# Expor a porta 3000
EXPOSE 3000

# Definir local do JSON de autenticação da API Google Cloud
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/arquivo_secreto.json

ENV RAILS_SERVE_STATIC_FILES=true


# Rodar o servidor Rails em ambiente de produção
CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]

