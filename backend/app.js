require('dotenv').config()

const express = require("express")

const conectaAoBancoDeDados = require("./src/config/database")
const configuraExpress = require("./src/config/express")

const authRoutes = require("./src/api/routes/auth.routes")
const turmaRoutes = require("./src/api/routes/turma.routes")
const serieRoutes = require("./src/api/routes/serie.routes")
const alunoRoutes = require("./src/api/routes/aluno.routes")
const professorRoutes = require("./src/api/routes/professor.routes")
const pastaRoutes = require("./src/api/routes/pasta.routes")
const arquivoRoutes = require("./src/api/routes/arquivo.routes")

const app = express()

configuraExpress(app)

app.use("/api/auth", authRoutes)
app.use("/api/turmas", turmaRoutes)
app.use("/api/series", serieRoutes)
app.use("/api/alunos", alunoRoutes)
app.use("/api/professores", professorRoutes)
app.use("/api/pastas", pastaRoutes)
app.use("/api/arquivos", arquivoRoutes)

// Exporta o app para uso dos testes de integração
module.exports = app

// Só executa essa parte do código caso esse seja o arquivo principal em execução
// ou seja, só vai executar esse código quando o servidor for ligado de fato e não durante os testes
// Isso é necessário pois os testes de integração não estavam funcionando
if(require.main === module)
{
  const PORT = process.env.API_PORT
  
  conectaAoBancoDeDados()
  
  app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`)
  })
}
