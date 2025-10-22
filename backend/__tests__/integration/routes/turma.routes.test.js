const mongoose = require('mongoose')
const jwt = require("jsonwebtoken")

const request = require('supertest')
const { MongoMemoryServer } = require('mongodb-memory-server')

const app = require("../../../app")

const Aluno = require("../../../src/models/Aluno.model")
const Professor = require("../../../src/models/Professor.model")
const Turma = require("../../../src/models/Turma.model")

const {
  AUTH,
  ERRO,
  TURMA
} = require("../../../src/constants/responseMessages.constants")

const {
  ROLES
} = require("../../../src/constants/validation.constants")

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
  await Turma.deleteMany({})
})

describe("Rotas de relacionadas a turmas", () => {
  // 1. Testes relacionados ao cadastro de turmas
  describe("POST /turmas", () => {
    
  })
})
