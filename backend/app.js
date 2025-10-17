require('dotenv').config()

const express = require("express")

const conectaAoBancoDeDados = require("./src/config/database")
const configuraExpress = require("./src/config/express")

const authRoutes = require("./src/api/routes/auth.routes")
const turmaRoutes = require("./src/api/routes/turma.routes")
const serieRoutes = require("./src/api/routes/serie.routes")

const app = express()

conectaAoBancoDeDados()
configuraExpress(app)

app.use("/auth", authRoutes)
app.use("/turmas", turmaRoutes)
app.use("/series", serieRoutes)

const PORT = process.env.API_PORT

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`)
})
