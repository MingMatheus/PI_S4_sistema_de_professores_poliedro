const jwt = require("jsonwebtoken")

const authMiddleware = require("../../../src/middlewares/auth.middleware")

const {
  ROLES
} = require("../../../src/constants/validation.constants")

const {
  API
} = require("../../../src/constants/error.constants")

const {
  AUTH
} = require("../../../src/constants/responseMessages.constants")

describe("Middleware: auth", () => {
  let mockRequest
  let mockResponse
  let nextFunction

  beforeEach(() => {
    mockRequest = {
      headers: {}
    }

    mockResponse = {
      status: jest.fn().mockReturnThis(), // .mockReturnThis() permite encadear: res.status().json()
      json: jest.fn(),
    }

    nextFunction = jest.fn()
  })

  // 1. Testa o caso em que a requisição vem sem o header de authorization
  it("Deve retornar o código 401 caso a requsição venha sem o header de authorization", () => {
    // 1. Arrange

    // 2. Act
    authMiddleware(mockRequest, mockResponse, nextFunction)

    // 3. Assert
    expect(nextFunction).not.toHaveBeenCalled()
    expect(mockResponse.status).toHaveBeenCalledWith(401)
    expect(mockResponse.json).toHaveBeenCalledWith({
      mensagem: expect.stringContaining(AUTH.TOKEN_NAO_FORNECIDO)
    })
  })

  // 2. Testa o caso em que o token vem mal formatado
  it("Deve retornar o código 401 caso o token venha mal formatado", () => {
    // 1. Arrange
    token = jwt.sign({sub: "idGenerico", role: ROLES.ALUNO}, process.env.JWT_SECRET)
    mockRequest.headers.authorization = `${token}`

    // 2. Act
    authMiddleware(mockRequest, mockResponse, nextFunction)

    // 3. Assert
    expect(nextFunction).not.toHaveBeenCalled()
    expect(mockResponse.status).toHaveBeenCalledWith(401)
    expect(mockResponse.json).toHaveBeenCalledWith({
      mensagem: expect.stringContaining(AUTH.TOKEN_MAL_FORMATADO)
    })
  })

  // 3. Testa o caso em que o token vem certinho: bem formatado, válido e não expirado
  it("Deve chamar a função next caso tudo de certo", () => {
    // 1. Arrange
    token = jwt.sign({sub: "idGenerico", role: ROLES.ALUNO}, process.env.JWT_SECRET)
    mockRequest.headers.authorization = `Bearer ${token}`

    // 2. Act
    authMiddleware(mockRequest, mockResponse, nextFunction)

    // 3. Assert
    expect(nextFunction).toHaveBeenCalledTimes(1)
    expect(mockResponse.status).not.toHaveBeenCalled()
  })

  // 4. Testa o caso em que o token vem expirado
  it("Deve retornar o código 401 caso o token venha expirado", () => {
    // 1. Arrange
    jest.useFakeTimers()
    token = jwt.sign({sub: "idGenerico", role: ROLES.ALUNO}, process.env.JWT_SECRET, {expiresIn: "1s"})
    jest.advanceTimersByTime(2000)
    mockRequest.headers.authorization = `Bearer ${token}`

    // 2. Act
    authMiddleware(mockRequest, mockResponse, nextFunction)

    // 3. Assert
    expect(nextFunction).not.toHaveBeenCalled()
    expect(mockResponse.status).toHaveBeenCalledWith(401)
    expect(mockResponse.json).toHaveBeenCalledWith({
      code: expect.stringContaining(API.TOKEN_EXPIRADO),
      mensagem: expect.stringContaining(AUTH.TOKEN_EXPIROU)
    })

    // 4. Volta os timers ao normal
    jest.useRealTimers()
  })

  // 5. Testa o caso em que o token vem inválido
  it("Deve retornar o código 401 caso o token venha inválido", () => {
    // 1. Arrange
    token = jwt.sign({sub: "idGenerico", role: ROLES.ALUNO}, "segredoInvalido")
    mockRequest.headers.authorization = `Bearer ${token}`

    // 2. Act
    authMiddleware(mockRequest, mockResponse, nextFunction)

    // 3. Assert
    expect(nextFunction).not.toHaveBeenCalled()
    expect(mockResponse.status).toHaveBeenCalledWith(401)
    expect(mockResponse.json).toHaveBeenCalledWith({
      code: expect.stringContaining(API.TOKEN_INVALIDO),
      mensagem: expect.stringContaining(AUTH.TOKEN_INVALIDO)
    })
  })
})
