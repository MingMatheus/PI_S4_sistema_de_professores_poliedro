const mongoose = require('mongoose')

const request = require('supertest')
const { MongoMemoryServer } = require('mongodb-memory-server')

const app = require("../../../app")

const Aluno = require("../../../src/models/Aluno.model")
const Professor = require("../../../src/models/Professor.model")

const {
  AUTH,
  ERRO
} = require("../../../src/constants/responseMessages.constants")

const tamanhoMinimoDaSenha = 8
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
})

describe("Rotas de autenticação", () => {
  // 1. Testes relacionados ao cadastro de alunos
  describe("POST /api/auth/cadastro/alunos", () => {
    let profToken

    // Cria um professor antes dos testes de cadastro de alunos, pq o cadastro de alunos necessita de uma professor logado
    beforeEach(async () => {
      const professor = new Professor({
        email: "professor@test.com",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      });
      await professor.save()

      // Para simplificar, vamos criar um token manualmente
      const jwt = require('jsonwebtoken')
      profToken = jwt.sign({ sub: professor._id, role: "professor" }, process.env.JWT_SECRET)
    })

    // 1.1 Testa um cadastro de aluno feito com sucesso
    it('deve cadastrar um novo aluno e retornar status 201', async () => {
      // 1. Arrange
      const novoAluno = {
        email: 'aluno@teste.com',
        senha: 'password123',
        nome: 'Aluno Teste',
        ra: '123456'
        // Supondo que a turma não seja obrigatória para este teste simples
      };

      // 2. Act (Agir) - Faz a requisição para a API
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`) // Adiciona o token de autenticação
        .send(novoAluno); // Envia os dados do novo aluno no corpo da requisição

      // 3. Assert (Verificar) - Checa a resposta da API
      expect(response.statusCode).toBe(201);
      expect(response.body).toHaveProperty("mensagem", AUTH.ALUNO_CRIADO);
      
      // 4. Assert (Verificar) - Checa se o usuário foi realmente salvo no banco de dados
      const alunoSalvo = await Aluno.findOne({ email: 'aluno@teste.com' });
      expect(alunoSalvo).not.toBeNull();
      expect(alunoSalvo.nome).toBe('Aluno Teste');
    });

    // 1.2 Testa um cadastro de aluno que falha devido ao email do aluno ter o formato do email dos professores
    it("deve retornar erro 400 caso o email enviado seja um de professor", async () => {
      // Arrange
      const aluno = {
        email: "aluno@sistemapoliedro.com.br",
        senha: "senhaTeste12345",
        nome: "Aluno Teste",
        ra: "123456"
      }

      // Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 1.3 Testa um cadastro de aluno que falha devido a senha estar inválida
    it("deve retornar 400 caso a senha do novo aluno esteja inválida, de acordo com as regras de negócio", async () => {
      // Arrange
      const aluno = {
        email: "aluno@test.com",
        senha: "1234567",
        nome: "Aluno Teste",
        ra: "123456"
      }

      // Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 1.4 Testa um cadastro de aluno que falha devido a já haver um aluno cadastrado com aquele email
    it('deve retornar erro 409 se o email já estiver em uso', async () => {
      // 1. Arrange
      const aluno1 = {
        email: 'aluno@test.com',
        senha: 'senha1234',
        nome: 'Aluno 1',
        ra: '123456'
      };

      const aluno2 = {
        email: 'aluno@test.com', // Email duplicado
        senha: 'password0987',
        nome: 'Aluno 2',
        ra: '654321'
      };

      // Cadastra o primeiro aluno
      await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno1)

      // 2. Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno2);

      // 3. Assert
      expect(response.statusCode).toBe(409);
      expect(response.body).toHaveProperty("mensagem", AUTH.EMAIL_EM_USO);
    })

    // 1.5 Testa um cadastro de aluno que falha devido a já haver um aluno cadastrado com aquele RA
    it('deve retornar erro 409 se o RA já estiver em uso', async () => {
      // 1. Arrange
      const aluno1 = {
        email: 'aluno1@test.com',
        senha: 'senha1234',
        nome: 'Aluno 1',
        ra: '123456'
      };

      const aluno2 = {
        email: 'aluno2@test.com',
        senha: 'password0987',
        nome: 'Aluno 2',
        ra: '123456'  // RA duplicado
      };

      // Cadastra o primeiro aluno
      await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno1)

      // 2. Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno2);

      // 3. Assert
      expect(response.statusCode).toBe(409);
      expect(response.body).toHaveProperty("mensagem", AUTH.RA_EM_USO);
    })

    // 1.6 Testa um cadastro de aluno que falha devido ao email estar mal formatado
    it("deve retornar erro 400 se o email estiver mal formatado (email inválido)", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno1@testcom',
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 1.7 Testa um cadastro de aluno que falha devido ao email não ter sido fornecido
    it("deve retornar erro 400 se o email não tiver sido fornecido", async () => {
      // 1. Arrange
      const aluno = {
        // email: 'aluno1@testcom',  * sem email *
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 1.8 Testa um cadastro de aluno que falha devido a senha não ter sido fornecida
    it("deve retornar erro 400 se a senha não tiver sido fornecida", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno1@testcom',
        // senha: 'senha1234',  * sem senha *
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 1.9 Testa um cadastro de aluno que falha devido ao nome não ter sido fornecido
    it("deve retornar erro 400 se o nome não tiver sido fornecido", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno1@testcom',
        senha: 'senha1234',
        // nome: 'Aluno Teste',  * sem nome *
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 1.10 Testa um cadastro de aluno que falha devido ao RA não ter sido fornecido
    it("deve retornar erro 400 se o RA não tiver sido fornecido", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno1@testcom',
        senha: 'senha1234',
        nome: 'Aluno Teste'
        // ra: '123456'  * sem RA *
      };

      // 2. Act
      const response = await request(app)
        .post('/api/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })
  })

  // 2. Testes relacionados ao cadastro de professores
  describe("POST /api/auth/cadastro/professores", () => {
    
  })

  // 3. Testes relacionados ao login
  describe("POST /api/auth/login", () => {
    
  })
})
