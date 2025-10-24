# PI S4 - Sistema de Professores Poliedro 

## O projeto
### Introdução
Esse software é um projeto desenvolvido por alunos do Instituto Mauá de Tecnologia (IMT) para a disciplina de Projeto Integrador Interdisciplinar voltado para o nosso parceiro, o colégio Poliedro.
### Funcionalidades
Esse projeto tem como objetivo ser um sistema para professores e alunos do colégio Poliedro para facilitar a comunicação de informações entre as partes. As principais funcionalidades do programa são:
- Professores:

  Compartilhamento de materiais de estudo.

  Envio de avisos para os alunos.

  Registro e atualização de notas.

- Alunos:

  Visualização e download de materiais.

  Leitura dos avisos mandados pelos professores

  Consulta de notas.

## Tecnologias Utilizadas
- **Frontend**: [Flutter](https://flutter.dev/)
- **Backend**: [Node.js](https://nodejs.org/)
- **Banco de Dados**: [MongoDB](https://www.mongodb.com/)

## Como utilizar o projeto
### Pré-requisitos
1. Ter o [Flutter](https://flutter.dev/) instalado
2. Ter o [Node.js](https://nodejs.org/) instalado
3. Ter o [MongoDB](https://www.mongodb.com/) instalado e rodando (caso for usar o MongoDB localmente)

### 1. Clonagem do repositório
- Inicialmente clone o repositório usando o seguinte comando:

```bash
git clone https://github.com/MingMatheus/PI_S4_sistema_de_professores_poliedro
```

### 2. Frontend
1. Com um terminal já aberto na pasta do projeto navegue para a pasta do frontend usando o seguinte comando:

```bash
cd frontend
```

2. Instale as dependências do frontend usando o seguinte comando:

```bash
flutter pub get
```

3. Execute um dos seguintes comandos (baseado no seu sistema operacional) para criar o arquivo ``` .env ``` baseado no ``` .env.example ``` e então troque os valores das variáveis de ambiente no arquivo ``` .env ``` para os valores que serão usados no projeto

```bash
# No Windows
copy .env.example .env

# No macOS / Linux
cp .env.example .env
```

4. Inicie a aplicação do frontend executando o seguinte comando e em seguida selecione o dispositivo em que você deseja executar a aplicação (web, mobile, desktop):
```bash
flutter run
```

### 3. Backend
1. Com um terminal já aberto na pasta do projeto navegue para a pasta do backend usando o seguinte comando:

```bash
cd backend
```

2. Instale as dependências do backend usando o seguinte comando:

```bash
npm install
```

3. Execute um dos seguintes comandos (baseado no seu sistema operacional) para criar o arquivo ``` .env ``` baseado no ``` .env.example ``` e então troque os valores das variáveis de ambiente no arquivo ``` .env ``` para os valores que serão usados no projeto

```bash
# No Windows
copy .env.example .env

# No macOS / Linux
cp .env.example .env
```

4. Inicie a aplicação do backend executando um dos seguintes comandos:
```bash
# Para ambiente de desenvolvimento
npm run dev

# Para ambiente de produção
npm start
```

### 4. Testes
Para rodar os testes do backend abra um terminal na pasta do backend e execute o seguinte comando
```bash:
npm test
```