const mongoose = require('mongoose')
const jwt = require("jsonwebtoken")

const request = require('supertest')
const { MongoMemoryServer } = require('mongodb-memory-server')

const app = require("../../../app")

const Aluno = require("../../../src/models/Aluno.model")
const Professor = require("../../../src/models/Professor.model")

const {
  AUTH,
  ERRO
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
})

// Roda APÓS cada teste para voltar os timers ao normal, caso eles tenham sido alterados para timers fake
afterEach(() => {
  jest.useRealTimers();
});

describe("Rotas de autenticação", () => {
  // 1. Testes relacionados ao cadastro de alunos
  describe("POST /auth/cadastro/alunos", () => {
    let profToken, alunoToken

    // Cria um professor antes dos testes de cadastro de alunos, pq o cadastro de alunos necessita de uma professor logado
    // Cria também um aluno para testar os middlewares
    beforeEach(async () => {
      const professor = new Professor({
        email: "professor763454837@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      });
      await professor.save()

      // Para simplificar, vamos criar um token manualmente
      profToken = jwt.sign({sub: professor._id, role: ROLES.PROFESSOR}, process.env.JWT_SECRET)

      const aluno = new Aluno({
        email: "aluno873453@alunoteste.com",
        senha: "senhaDoAluno",
        nome: "Aluno de Teste",
        ra: "7643563045045345"
      })

      await aluno.save()

      alunoToken = jwt.sign({sub: aluno._id, role: ROLES.ALUNO}, process.env.JWT_SECRET)
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
        .post('/auth/cadastro/alunos')
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
        .post('/auth/cadastro/alunos')
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
        .post('/auth/cadastro/alunos')
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
        .post('/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno1)

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
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
        .post('/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno1)

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
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
        .post('/auth/cadastro/alunos')
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
        // email: 'aluno@test.com',  * sem email *
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
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
        email: 'aluno@test.com',
        // senha: 'senha1234',  * sem senha *
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
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
        email: 'aluno@test.com',
        senha: 'senha1234',
        // nome: 'Aluno Teste',  * sem nome *
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
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
        email: 'aluno@test.com',
        senha: 'senha1234',
        nome: 'Aluno Teste'
        // ra: '123456'  * sem RA *
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 1.11 Testa um cadastro de aluno que falha devido a requisição não possuir o header de authorization
    it("deve retornar erro 401 se a requisição não possuir o header de authorization", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno@test.com',
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
        // .set('Authorization', `Bearer ${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_NAO_FORNECIDO);
    })

    // 1.12 Testa um cadastro de aluno que falha devido ao token estar mal formatado (sem o bearer)
    it("deve retornar erro 401 se o token estiver mal formatado", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno@test.com',
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
        .set('Authorization', `${profToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_MAL_FORMATADO);
    })

    // 1.13 Testa um cadastro de aluno que falha devido ao token estar expirado
    it("deve retornar erro 401 se o token estiver expirado", async () => {
      // 1. Arrange
      const professorComTokenExpirado = new Professor({
        email: "professorComTokenExpirado@sistemapoliedro.com.br",
        senha: "senhaDoProfessorComTokenExpirado",
        nome: "professorComTokenExpirado"
      })
      
      await professorComTokenExpirado.save()
      
      jest.useFakeTimers()  // Faz o uso de timers fake para 'manipular' o tempo para deixar o token expirado
      const tokenExpirado = jwt.sign({sub: professorComTokenExpirado._id, role: ROLES.PROFESSOR}, process.env.JWT_SECRET, {expiresIn: "1s"})
      jest.advanceTimersByTime(2000)  // Faz com que se passe 2s, virtualmente, o que deixa o token expirado

      const aluno = {
        email: 'aluno@test.com',
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${tokenExpirado}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("code", API.TOKEN_EXPIRADO);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_EXPIROU);
    })

    // 1.14 Testa um cadastro de aluno que falha devido ao token estar inválido
    it("deve retornar erro 401 se o token estiver inválido", async () => {
      // 1. Arrange
      const professorComTokenInvalido = new Professor({
        email: "professorComTokenInvalido@sistemapoliedro.com.br",
        senha: "senhaDoProfessorComTokenInvalido",
        nome: "professorComTokenInvalido"
      })

      await professorComTokenInvalido.save()

      const tokenInvalido = jwt.sign({sub: professorComTokenInvalido._id, role: ROLES.PROFESSOR}, "segredoInvalido")

      const aluno = {
        email: 'aluno@test.com',
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${tokenInvalido}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("code", API.TOKEN_INVALIDO);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_INVALIDO);
    })

    // 1.15 Testa um cadastro de aluno que falha devido a role do requisitante não estar dentre as roles permitidas para essa ação
    it("deve retornar erro 403 se a role do requisitante não estiver dentre as roles permitidas para essa ação", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno@test.com',
        senha: 'senha1234',
        nome: 'Aluno Teste',
        ra: '123456'
      };

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/alunos')
        .set('Authorization', `Bearer ${alunoToken}`)
        .send(aluno);

      // 3. Assert
      expect(response.statusCode).toBe(403);
      expect(response.body).toHaveProperty("mensagem", AUTH.NAO_TEM_PERMISSAO);
    })
  })

  // 2. Testes relacionados ao cadastro de professores
  describe("POST /auth/cadastro/professores", () => {
    let profToken, alunoToken

    // Cria um professor antes dos testes de cadastro de professores, pq o cadastro de professores necessita de uma professor logado
    beforeEach(async () => {
      const professor = new Professor({
        email: "professor5192166@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      });
      await professor.save()

      // Para simplificar, vamos criar um token manualmente
      profToken = jwt.sign({sub: professor._id, role: ROLES.PROFESSOR}, process.env.JWT_SECRET)

      const aluno = new Aluno({
        email: "aluno8751616523@alunoteste.com",
        senha: "senhaDoAluno",
        nome: "Aluno de Teste",
        ra: "76435651515165045345"
      })

      await aluno.save()

      alunoToken = jwt.sign({sub: aluno._id, role: ROLES.ALUNO}, process.env.JWT_SECRET)
    })

    // 2.1 Testa um cadastro de professor feito com sucesso
    it("deve cadastrar um novo professor e retornar status 201", async () => {
      // 1. Arrange
      const novoProfessor = {
        email: "professor.teste@sistemapoliedro.com.br",
        senha: "password123",
        nome: "Professor Teste"
      }

      // 2. Act (Agir) - Faz a requisição para a API
      const response = await request(app)
        .post("/auth/cadastro/professores")
        .set("Authorization", `Bearer ${profToken}`) // Adiciona o token de autenticação
        .send(novoProfessor); // Envia os dados do novo aluno no corpo da requisição

      // 3. Assert (Verificar) - Checa a resposta da API
      expect(response.statusCode).toBe(201);
      expect(response.body).toHaveProperty("mensagem", AUTH.PROFESSOR_CRIADO);
      
      // 4. Assert (Verificar) - Checa se o usuário foi realmente salvo no banco de dados
      const professorSalvo = await Professor.findOne({email: "professor.teste@sistemapoliedro.com.br"});
      expect(professorSalvo).not.toBeNull();
      expect(professorSalvo.nome).toBe("Professor Teste");
    })

    // 2.2 Testa um cadastro de professor que falha devido ao email ja estar em uso
    it("deve retornar erro 409 se o email já estiver em uso", async () => {
      // 1. Arrange
      const professor1 = {
        email: "professor.teste@sistemapoliedro.com.br",
        senha: "password1234",
        nome: "Professor Teste 1"
      }

      const professor2 = {
        email: "professor.teste@sistemapoliedro.com.br",
        senha: "password4321",
        nome: "Professor Teste 2"
      }

      // Cadastra o primeiro professor
      await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor1)

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor2);

      // 3. Assert
      expect(response.statusCode).toBe(409);
      expect(response.body).toHaveProperty("mensagem", AUTH.EMAIL_EM_USO);
    })

    // 2.3 Testa um cadastro de professor que falha devido ao email não ser um email de professor
    it("deve retornar erro 400 se o email fornecido não for um email de professor", async () => {
      // 1. Arrange
      const professor = {
        email: "professor.teste@outrodominio.com.br",
        senha: "password1234",
        nome: "Professor Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 2.4 Testa um cadastro de professor que falha devido ao email estar mal formatado
    it("deve retornar erro 400 se o email fornecido estiver mal formatado", async () => {
      // 1. Arrange
      const professor = {
        email: "professor.teste@sistemapoliedrocombr",
        senha: "password1234",
        nome: "Professor Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 2.5 Testa um cadastro de professor que falha devido a senha não estar válida
    it("deve retornar erro 400 se a senha fornecido não for válida", async () => {
      // 1. Arrange
      const professor = {
        email: "professor.teste@sistemapoliedro.com.br",
        senha: "1234567",
        nome: "Professor Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 2.6 Testa um cadastro de professor que falha devido ao email não ter sido fornecido
    it("deve retornar erro 400 se o email não for fornecido", async () => {
      // 1. Arrange
      const professor = {
        // email: "professor.teste@sistemapoliedro.com.br",
        senha: "12345678",
        nome: "Professor Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 2.7 Testa um cadastro de professor que falha devido a senha não ter sido fornecida
    it("deve retornar erro 400 se a senha não for fornecida", async () => {
      // 1. Arrange
      const professor = {
        email: "professor.teste@sistemapoliedro.com.br",
        // senha: "12345678",
        nome: "Professor Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 2.8 Testa um cadastro de professor que falha devido ao nome não ter sido fornecido
    it("deve retornar erro 400 se o nome não for fornecido", async () => {
      // 1. Arrange
      const professor = {
        email: "professor.teste@sistemapoliedro.com.br",
        senha: "12345678"
        // nome: "Professor Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(400);
      expect(response.body).toHaveProperty("mensagem", ERRO.VALIDACAO);
    })

    // 2.9 Testa um cadastro de professor que falha devido a requisição não possuir o header de authorization
    it("deve retornar erro 401 se a requisição não possuir o header de authorization", async () => {
      // 1. Arrange
      const professor = {
        email: "professorTeste@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        // .set('Authorization', `Bearer ${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_NAO_FORNECIDO);
    })

    // 2.10 Testa um cadastro de professor que falha devido ao token estar mal formatado (sem o bearer)
    it("deve retornar erro 401 se o token estiver mal formatado", async () => {
      // 1. Arrange
      const professor = {
        email: "professorTeste@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `${profToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_MAL_FORMATADO);
    })

    // 2.11 Testa um cadastro de professor que falha devido ao token estar expirado
    it("deve retornar erro 401 se o token estiver expirado", async () => {
      // 1. Arrange
      const professorComTokenExpirado = new Professor({
        email: "professorComTokenExpirado@sistemapoliedro.com.br",
        senha: "senhaDoProfessorComTokenExpirado",
        nome: "professorComTokenExpirado"
      })
      
      await professorComTokenExpirado.save()
      
      jest.useFakeTimers()  // Faz o uso de timers fake para 'manipular' o tempo para deixar o token expirado
      const tokenExpirado = jwt.sign({sub: professorComTokenExpirado._id, role: ROLES.PROFESSOR}, process.env.JWT_SECRET, {expiresIn: "1s"})
      jest.advanceTimersByTime(2000)  // Faz com que se passe 2s, virtualmente, o que deixa o token expirado

      const professor = {
        email: "professorTeste@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${tokenExpirado}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("code", API.TOKEN_EXPIRADO);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_EXPIROU);
    })

    // 2.12 Testa um cadastro de professor que falha devido ao token estar inválido
    it("deve retornar erro 401 se o token estiver inválido", async () => {
      // 1. Arrange
      const professorComTokenInvalido = new Professor({
        email: "professorComTokenInvalido@sistemapoliedro.com.br",
        senha: "senhaDoProfessorComTokenInvalido",
        nome: "professorComTokenInvalido"
      })

      await professorComTokenInvalido.save()

      const tokenInvalido = jwt.sign({sub: professorComTokenInvalido._id, role: ROLES.PROFESSOR}, "segredoInvalido")

      const professor = {
        email: "professorTeste@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${tokenInvalido}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(401);
      expect(response.body).toHaveProperty("code", API.TOKEN_INVALIDO);
      expect(response.body).toHaveProperty("mensagem", AUTH.TOKEN_INVALIDO);
    })

    // 2.13 Testa um cadastro de professor que falha devido a role do requisitante não estar dentre as roles permitidas para essa ação
    it("deve retornar erro 403 se a role do requisitante não estiver dentre as roles permitidas para essa ação", async () => {
      // 1. Arrange
      const professor = {
        email: "professorTeste@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      }

      // 2. Act
      const response = await request(app)
        .post('/auth/cadastro/professores')
        .set('Authorization', `Bearer ${alunoToken}`)
        .send(professor);

      // 3. Assert
      expect(response.statusCode).toBe(403);
      expect(response.body).toHaveProperty("mensagem", AUTH.NAO_TEM_PERMISSAO);
    })
  })

  // 3. Testes relacionados ao login
  describe("POST /auth/login", () => {
    // Cadastra um aluno e um professor antes dos testes de login
    beforeEach(async () => {
      const professor = new Professor({
        email: "professor@sistemapoliedro.com.br",
        senha: "senhaDoProfessor",
        nome: "Professor de Teste"
      });
      await professor.save()

      const aluno = new Aluno({
        email: "aluno@teste.com",
        senha: "senhaDoAluno",
        nome: "Aluno de Teste",
        ra: 123456
      });
      await aluno.save()
    })

    // 3.1 Testa um login de aluno concluido com sucesso
    it("Deve retornar 200 quando o login de aluno for bem sucedido", async () => {
      // 1. Arrange
      const aluno = {
        email: 'aluno@teste.com',
        senha: 'senhaDoAluno'
      }

      // 2. Act
      const response = await request(app)
      .post("/auth/login")
      .send(aluno)

      // 3. Assert
      expect(response.statusCode).toBe(200)
      expect(response.body).toHaveProperty("mensagem", AUTH.LOGIN_FEITO)

      const token = response.body.token
      expect(token).not.toBeNull()
      const decodedPayload = jwt.verify(token, process.env.JWT_SECRET)
      expect(decodedPayload).not.toBeNull()
      expect(decodedPayload).toHaveProperty("sub")
      expect(decodedPayload).toHaveProperty("nome", "Aluno de Teste")
      expect(decodedPayload).toHaveProperty("role", ROLES.ALUNO)
    })

    // 3.2 Testa um login de professor concluido com sucesso
    it("Deve retornar 200 quando o login de professor for bem sucedido", async () => {
      // 1. Arrange
      const professor = {
        email: "professor@sistemapoliedro.com.br",
        senha: "senhaDoProfessor"
      }

      // 2. Act
      const response = await request(app)
      .post("/auth/login")
      .send(professor)

      // 3. Assert
      expect(response.statusCode).toBe(200)
      expect(response.body).toHaveProperty("mensagem", AUTH.LOGIN_FEITO)

      const token = response.body.token
      expect(token).not.toBeNull()
      const decodedPayload = jwt.verify(token, process.env.JWT_SECRET)
      expect(decodedPayload).not.toBeNull()
      expect(decodedPayload).toHaveProperty("sub")
      expect(decodedPayload).toHaveProperty("nome", "Professor de Teste")
      expect(decodedPayload).toHaveProperty("role", ROLES.PROFESSOR)
    })

    // 3.3 Testa um login que falha devido ao email não ter sido fornecido
    it("Deve retornar 400 quando o email não é fornecido", async () => {
      // 1. Arrange
      const professor = {
        // email: "professor@sistemapoliedro.com.br",
        senha: "senhaDoProfessor"
      }

      // 2. Act
      const response = await request(app)
      .post("/auth/login")
      .send(professor)

      // 3. Assert
      expect(response.statusCode).toBe(400)
      expect(response.body).toHaveProperty("mensagem", AUTH.CREDENCIAIS_INVALIDAS)
    })

    // 3.4 Testa um login que falha devido a senha não ter sido fornecida
    it("Deve retornar 400 quando a senha não é fornecida", async () => {
      // 1. Arrange
      const professor = {
        email: "professor@sistemapoliedro.com.br"
        // senha: "senhaDoProfessor"
      }

      // 2. Act
      const response = await request(app)
      .post("/auth/login")
      .send(professor)

      // 3. Assert
      expect(response.statusCode).toBe(400)
      expect(response.body).toHaveProperty("mensagem", AUTH.CREDENCIAIS_INVALIDAS)
    })

    // 3.5 Testa um login que falha devido ao email não ter sido cadastrado previamente
    it("Deve retornar 401 quando o email fornecido não está cadastrado na base de dados", async () => {
      // 1. Arrange
      const professor = {
        email: "professor2@sistemapoliedro.com.br",
        senha: "senhaDoProfessor"
      }

      // 2. Act
      const response = await request(app)
      .post("/auth/login")
      .send(professor)

      // 3. Assert
      expect(response.statusCode).toBe(401)
      expect(response.body).toHaveProperty("mensagem", AUTH.CREDENCIAIS_INVALIDAS)
    })

    // 3.6 Testa um login que falha devido a senha estar errada
    it("Deve retornar 401 quando a senha fornecida está errada", async () => {
      // 1. Arrange
      const professor = {
        email: "professor@sistemapoliedro.com.br",
        senha: "senhaDoProfessor2"
      }

      // 2. Act
      const response = await request(app)
      .post("/auth/login")
      .send(professor)

      // 3. Assert
      expect(response.statusCode).toBe(401)
      expect(response.body).toHaveProperty("mensagem", AUTH.CREDENCIAIS_INVALIDAS)
    })
  })
})
