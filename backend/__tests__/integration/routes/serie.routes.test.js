const mongoose = require('mongoose')
const jwt = require("jsonwebtoken")

const request = require('supertest')
const { MongoMemoryServer } = require('mongodb-memory-server')

const app = require("../../../app")

const Aluno = require("../../../src/models/Aluno.model")
const Professor = require("../../../src/models/Professor.model")
const Serie = require("../../../src/models/Serie.model")

const {
  AUTH,
  ERRO,
  SERIE
} = require("../../../src/constants/responseMessages.constants")

const {
  ROLES
} = require("../../../src/constants/validation.constants")

const {
  API
} = require("../../../src/constants/error.constants")

let mongoServer

// Hooks do Jest: Funções que rodam antes ou depois dos testes

// Roda UMA VEZ antes de todos os testes neste arquivo para configurar o DB em memória
beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create()
  const mongoUri = mongoServer.getUri()
  await mongoose.connect(mongoUri)
})

// Roda UMA VEZ depois de todos os testes para limpar a conexão
afterAll(async () => {
  await mongoose.disconnect()
  await mongoServer.stop()
})

// Roda ANTES de CADA teste para limpar a coleção de alunos e a coleção de professores
beforeEach(async () => {
  await Aluno.deleteMany({})
  await Professor.deleteMany({})
  await Serie.deleteMany({})
})

// Roda APÓS cada teste para voltar os timers ao normal, caso eles tenham sido alterados para timers fake
afterEach(() => {
  jest.useRealTimers();
});

describe("Rotas de relacionadas a series", () => {
  // 1. Testes relacionados ao cadastro de series
  describe("POST /series", () => {
    let profToken, alunoToken, serieValida

    // Cria um professor antes dos testes de cadastro de séries, pq o cadastro de séries necessita de uma professor logado
    // Cria também um aluno para testar os middlewares
    // Cria também uma série válida para reutilização dentro de diversos dos testes
    beforeEach(async () => {
      // Professor com token
      const professor = new Professor({
        email: "professor2195156161@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      });
      await professor.save()

      // Para simplificar, vamos criar um token manualmente
      profToken = jwt.sign({sub: professor._id, role: ROLES.PROFESSOR}, process.env.JWT_SECRET)

      // Aluno com token
      const aluno = new Aluno({
        email: "aluno5198151@alunoteste.com",
        senha: "senhaDoAluno",
        nome: "Aluno de Teste",
        ra: "118198151116663878"
      })

      await aluno.save()

      alunoToken = jwt.sign({sub: aluno._id, role: ROLES.ALUNO}, process.env.JWT_SECRET)

      // Série válida
      serieValida = {
        nome: "Série de Testes"
      }
    })

    // 1.1 Testa um cadastro de série que falha devido a requisição não possuir o header de authorization
    it("Deve retornar um erro 401 caso a requisição não possua o header de authorization", async () => {
      // 1. Arrange

      // 2. Act
      const response = await request(app)
        .post("/series")
        // .set("Authorization", `Bearer ${profToken}`)
        .send(serieValida)

      // 3. Assert
      expect(response.statusCode).toBe(401)
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_NAO_FORNECIDO)
    })

    // 1.2 Testa um cadastro de série que falha devido ao token estar mal formatado
    it("Deve retornar um erro 401 caso o token esteja mal formatado", async () => {
      // 1. Arrange

      // 2. Act
      const response = await request(app)
        .post("/series")
        .set("Authorization", `${profToken}`)
        .send(serieValida)

      // 3. Assert
      expect(response.statusCode).toBe(401)
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_MAL_FORMATADO)
    })

    // 1.3 Testa um cadastro de série que falha devido ao token estar expirado
    it("Deve retornar um erro 401 caso o token esteja expirado", async () => {
      // 1. Arrange
      jest.useFakeTimers()
      tokenExpirado = jwt.sign({sub: "idGenerico", role: ROLES.PROFESSOR}, process.env.JWT_SECRET, {expiresIn: "1s"})
      jest.advanceTimersByTime(2000)

      // 2. Act
      const response = await request(app)
        .post("/series")
        .set("Authorization", `Bearer ${tokenExpirado}`)
        .send(serieValida)

      // 3. Assert
      expect(response.statusCode).toBe(401)
      expect(response.body).toHaveProperty("code", API.TOKEN_EXPIRADO)
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_EXPIROU)
    })

    // 1.4 Testa um cadastro de série que falha devido ao token estar inválido
    it("Deve retornar um erro 401 caso o token esteja inválido", async () => {
      // 1. Arrange
      tokenInvalido = jwt.sign({sub: "idGenerico", role: ROLES.PROFESSOR}, "segredoInvalido")

      // 2. Act
      const response = await request(app)
        .post("/series")
        .set("Authorization", `Bearer ${tokenInvalido}`)
        .send(serieValida)

      // 3. Assert
      expect(response.statusCode).toBe(401)
      expect(response.body).toHaveProperty("code", API.TOKEN_INVALIDO)
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_INVALIDO)
    })

    // 1.5 Testa um cadastro de série que falha devido ao requisitante não ter uma role que esteja dentre aquelas permitidas para essa ação
    it("Deve retornar um erro 403 caso o requisitante não tenha uma role que esteja dentre aquelas permitidas para essa ação", async () => {
      // 1. Arrange

      // 2. Act
      const response = await request(app)
        .post("/series")
        .set("Authorization", `Bearer ${alunoToken}`)
        .send(serieValida)

      // 3. Assert
      expect(response.statusCode).toBe(403)
      expect(response.body).toHaveProperty("mensagem", AUTH.NAO_TEM_PERMISSAO)
    })

    // 1.6 Testa um cadastro de série que é bem sucedido
    it("Deve retornar um código 201 caso o cadastro da série seja bem sucedido", async () => {
      // 1. Arrange

      // 2. Act
      const response = await request(app)
        .post("/series")
        .set("Authorization", `Bearer ${profToken}`)
        .send(serieValida)

      // 3. Assert - Checa a resposta da API
      expect(response.statusCode).toBe(201)
      expect(response.body).toHaveProperty("mensagem", SERIE.CRIADA_COM_SUCESSO)

      // 4. Assert - Checa se a série foi salva no Banco de Dados
      const serieSalva = await Serie.findOne({nome: "Série de Testes"})
      expect(serieSalva).not.toBeNull()
      expect(serieSalva.nome).toBe("Série de Testes")
    })

    // 1.7 Testa um cadastro de série que falha devido ao nome da série fornecida já estar em uso
    it("Deve retornar um erro 409 caso o nome da série fornecida já esteja em uso", async () => {
      // 1. Arrange
      const serieJaCadastrada = {
        nome: "Série de Testes"
      }

      await request(app)
        .post("/series")
        .set("Authorization", `Bearer ${profToken}`)
        .send(serieValida)

      // 2. Act
      const response = await request(app)
        .post("/series")
        .set("Authorization", `Bearer ${profToken}`)
        .send(serieJaCadastrada)

      // 3. Assert
      expect(response.statusCode).toBe(409)
      expect(response.body).toHaveProperty("mensagem", SERIE.NOME_EM_USO)
    })

    // 1.8 Testa um cadastro de série que falha devido a série fornecida não ter nome
    it("Deve retornar um erro 400 caso o nome da série não tenha sido fornecido", async () => {
      // 1. Arrange
      const serieSemNome = {}

      // 2. Act
      const response = await request(app)
        .post("/series")
        .set("Authorization", `Bearer ${profToken}`)
        .send(serieSemNome)

      // 3. Assert
      expect(response.statusCode).toBe(400)
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO)
    })
  })
})
