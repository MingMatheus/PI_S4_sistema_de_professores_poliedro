require('dotenv').config()

const express = require("express")

const conectaAoBancoDeDados = require("./src/config/database")
const configuraExpress = require("./src/config/express")
const configuraRotas = require("./src/config/rotas.config")

const app = express()

configuraExpress(app)
configuraRotas(app)

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
