const checkRole = require("../../../src/middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../../src/constants/validation.constants")

const {
  AUTH
} = require("../../../src/constants/responseMessages.constants")

describe("Middleware: checkRole", () => {
  let mockRequest
  let mockResponse
  let nextFunction

  beforeEach(() => {
    mockRequest = {}

    mockResponse = {
      status: jest.fn().mockReturnThis(), // .mockReturnThis() permite encadear: res.status().json()
      json: jest.fn(),
    }

    nextFunction = jest.fn()
  })

  // Teste 1: O "caminho feliz"
  it("deve chamar next() se o usuário tiver um cargo permitido", () => {
    // 1. Arrange (Preparar)
    const middleware = checkRole([ROLES.PROFESSOR]) // Cria o middleware para o cargo 'professor'
    mockRequest.user = { role: ROLES.PROFESSOR } // Simula que o auth.middleware já rodou

    // 2. Act (Agir)
    middleware(mockRequest, mockResponse, nextFunction); // Executa o middleware

    // 3. Assert (Verificar)
    expect(nextFunction).toHaveBeenCalledTimes(1) // Esperamos que next() tenha sido chamado 1 vez
    expect(mockResponse.status).not.toHaveBeenCalled()  // E que nenhuma resposta de erro tenha sido enviada
  })

  // Teste 2: O caminho de erro
  it("deve retornar um erro 403 se o usuário NÃO tiver um cargo permitido", () => {
    // 1. Arrange
    const middleware = checkRole([ROLES.PROFESSOR]);
    mockRequest.user = { role: ROLES.ALUNO }; // Damos ao usuário um cargo não permitido

    // 2. Act
    middleware(mockRequest, mockResponse, nextFunction);

    // 3. Assert
    expect(nextFunction).not.toHaveBeenCalled() // next() NÃO deve ter sido chamada
    expect(mockResponse.status).toHaveBeenCalledWith(403) // O status de erro deve ser 403 Forbidden
    expect(mockResponse.json).toHaveBeenCalledWith({ // A resposta JSON deve conter uma mensagem de erro
      mensagem: expect.stringContaining(AUTH.NAO_TEM_PERMISSAO),
    })
  })

  // Teste 3: Múltiplos cargos
  it("deve chamar next() se o cargo do usuário estiver na lista de múltiplos cargos permitidos", () => {
    // 1. Arrange
    const middleware = checkRole([ROLES.ALUNO, ROLES.PROFESSOR])
    mockRequest.user = {role: ROLES.PROFESSOR}

    // 2. Act
    middleware(mockRequest, mockResponse, nextFunction)

    // 3. Assert
    expect(nextFunction).toHaveBeenCalledTimes(1)
    expect(mockResponse.status).not.toHaveBeenCalled()
  })

  // Teste 4: O request não tem o parametro user
  it("deve retornar um erro 401 se o request não tiver o parametro user", () => {
    // 1. Arrange
    const middleware = checkRole([ROLES.PROFESSOR]);

    // 2. Act
    middleware(mockRequest, mockResponse, nextFunction);

    // 3. Assert
    expect(nextFunction).not.toHaveBeenCalled() // next() NÃO deve ter sido chamada
    expect(mockResponse.status).toHaveBeenCalledWith(401) // O status de erro deve ser 403 Forbidden
    expect(mockResponse.json).toHaveBeenCalledWith({ // A resposta JSON deve conter uma mensagem de erro
      mensagem: expect.stringContaining(AUTH.TOKEN_NAO_ENCONTRADO),
    })
  })
})
