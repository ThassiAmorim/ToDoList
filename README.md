# To Do Lists - V360 case


### Resumo

O projeto permite a criação de várias listas com vários afazeres, também é possível exportas as listas e seus itens para uma planilha, importar listas físicas (escritas a mão) e visualizar o progresso da realização das tarefas através de Dashboards. Os dados são armazenados em um banco de dados relacional PostgreSQL, hospedado localmente em uma VM Ubuntu WSL e roda em produção através de um container Docker. 


### Arquitetura

Diagrama da arquitetura do projeto:

![ToDoList](https://github.com/user-attachments/assets/f841fc63-fbc4-49b6-8f75-36cea96f6acc)


### Versões
Ruby: 3.2.2  
Rails: 7.0.8.5  
PostgreSQL: 16  

Demais versões e informações de gems podem ser encontradas no Gemfile


### Guia instalação 

Um guia de instalação e configuração de ambiente para trabalhar com o WebSite RoR


```
sudo apt-get update
sudo apt-get install git curl build-essential zlib1g-dev libyaml-dev libssl-dev libpq-dev libreadline-dev

# Install rbenv locally for the dev user
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
# Optional: Compile bash extensions
cd ~/.rbenv && src/configure && make -C src
# Add rbenv to the shell's $PATH.
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

# Run rbenv-init and follow the instructions to initialize rbenv on any shell
~/.rbenv/bin/rbenv init
# Issue the recommended command from the stdout of the last command
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
# Source bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install the required version as read from the Gemfile
rbenv install 3.2.2

rbenv global 3.2.2
rbenv rehash

gem install rails 

sudo apt-get install postgresql postgresql-client
sudo -i -u postgres
createuser --interactive  # Escolha o nome de usuário (nesse caso v360)
psql
ALTER USER <nome_do_usuario> WITH PASSWORD '<senha>';
\q
exit

```



Verifique a instalação com:

```
ruby --version

bundler --version
```

*OBS*: Certifique-se que o usuário e senha estão corretamente configurados no arquivo config\database.yml


Após realizar o clone:

```
rails db:create
rails db:migrate
bundle install

rails s

```

*OBS*: Para rodar a aplicação na versão da branch "v2-ocr-feature" é necessário possuir um json de autenticação para a API do Google Cloud Vision

### Docker

Pode-se construir o container docker apenas para a aplicação com o dockerfile (para se conectar remotamente a algum banco) ou construir o container da aplicação e o do banco e gerencia-los com o docker-compose, para este projeto, foi utilizado a primeira opção.

