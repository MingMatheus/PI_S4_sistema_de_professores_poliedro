const RESPONSE_MESSAGES = {
  AUTH: {
    ALUNO_CRIADO: "Aluno criado com sucesso",
    PROFESSOR_CRIADO: "Professor criado com sucesso",
    LOGIN_FEITO: "Login realizado com sucesso",
    EMAIL_EM_USO: "Esse endereço de email já está cadastrado",
    RA_EM_USO: "Esse RA já está cadastrado",
    ERRO_DE_UNICIDADE_GENERICO: "Um campo único já existe",
    CREDENCIAIS_INVALIDAS: "Credenciais inválidas",
    TOKEN_NAO_FORNECIDO: "Acesso negado. O token de autenticação não foi fornecido",
    TOKEN_MAL_FORMATADO: "Erro no formato do token. O formato esperado é \"Bearer <token>\"",
    TOKEN_EXPIROU: "Sua sessão expirou. Por favor, faça login novamente",
    TOKEN_INVALIDO: "Token de autenticação inválido",
    TOKEN_NAO_ENCONTRADO: "Acesso negado. O token não foi encontrado no corpo da requisição",
    NAO_TEM_PERMISSAO: "Acesso proibido. Você não tem a permissão necessária para acessar esse recurso"
  },

  // Mensagens de erro genéricas
  ERRO: {
    UNICIDADE: "Um campo único já existe",
    VALIDACAO: "Dados inválidos. Por favor, verifique os campos obrigatórios e formatos",
    ERRO_INTERNO_NO_SERVIDOR: "Ocorreu um erro no servidor, tente novamente mais tarde"
  },

  TURMA: {
    CRIADA_COM_SUCESSO: "Turma criada com sucesso",
    NOME_EM_USO: "Já existe uma turma cadastrada com esse nome"
  },

  SERIE: {
    CRIADA_COM_SUCESSO: "Série criada com sucesso",
    NOME_EM_USO: "Já existe uma série cadastrada com esse nome"
  }
}

module.exports = Object.freeze(RESPONSE_MESSAGES);
