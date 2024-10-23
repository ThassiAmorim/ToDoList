# Usar imagem base do Ruby
FROM ruby:3.2.2

# Definir diretório de trabalho
WORKDIR /app

# Copiar Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar dependências do bundle
RUN bundle install

# Copiar o código da aplicação
COPY . .

# Configurar variáveis de ambiente (opcional)
ENV RAILS_ENV=production

# Expor a porta 3000
EXPOSE 3000

# Rodar o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]


