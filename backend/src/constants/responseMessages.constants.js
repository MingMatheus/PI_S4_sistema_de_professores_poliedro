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

  // Mensagens de validação, usadas nos models
  VALIDACAO: {
    GERAL: {
      EMAIL_OBRIGATORIO: "O email é obrigatório",
      SENHA_OBRIGATORIA: "A senha é obrigatória",
      SENHA_INVALIDA: "A senha está inválida"
    },
    
    ALUNO: {
      EMAIL_INVALIDO: "Por favor insira um email de aluno válido",
      NOME_OBRIGATORIO: "O nome do aluno é obrigatório",
      RA_OBRIGATORIO: "O RA é obrigatório"
    },

    PROFESSOR: {
      EMAIL_INVALIDO: "Por favor insira um email de professor válido",
      NOME_OBRIGATORIO: "O nome do professor é obrigatório"
    },

    TURMA: {
      NOME_OBRIGATORIO: "O nome da turma é obrigatório"
    },

    SERIE: {
      NOME_OBRIGATORIO: "O nome da série é obrigatório"
    },

    ARQUIVO: {
      NOME_ORIGINAL_OBRIGATORIO: "O nome original do arquivo é obrigatório",
      NOME_NO_SISTEMA_OBRIGATORIO: "O nome do arquivo no sistema é obrigatório",
      TAMANHO_OBRIGATORIO: "O tamanho do arquivo é obrigatório",
      TIPO_OBRIGATORIO: "O tipo do arquivo é obrigatório",
      CAMINHO_OBRIGATORIO: "O caminho do arquivo é obrigatório",
      URL_OBRIGATORIA: "A URL do arquivo é obrigatória",
      PROFESSOR_QUE_FEZ_O_UPLOAD_OBRIGATORIO: "O professor que fez o upload é obrigatório"
    },

    PASTA: {
      NOME_OBRIGATORIO: "O nome da pasta é obrigatório",
      CRIADOR_OBRIGATORIO: "A pasta precisa do professor que a criou"
    }
  },

  ALUNO: {
    ENCONTRADO_COM_SUCESSO: "Aluno encontrado com sucesso",
    NAO_ENCONTRADO: "Aluno não encontrado",
    TODOS_ALUNOS_ENCONTRADOS: "Alunos encontrados com sucesso",
    ATUALIZADO_COM_SUCESSO: "Aluno atualizado com sucesso",
    DELETADO_COM_SUCESSO: "Aluno deletado com sucesso",
    ID_NAO_FORNECIDO: "O id do aluno não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido do aluno é inválido",
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
