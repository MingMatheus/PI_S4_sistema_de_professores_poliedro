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
    },

    NOTA: {
      NOTA_OBRIGATORIA: "A nota obtida é obrigatória",
      ALUNO_OBRIGATORIO: "O aluno que tirou a nota é obrigatório",
      AVALIACAO_OBRIGATORIA: "A avaliação a qual essa nota se refere é obrigatória",
      NOTA_INVALIDA: "Nota inválida. Por favor garanta que a nota esteja entre 0 e a nota máxima permitida por essa avaliação. Garanta também que a avaliação em questão exista"
    },
    
    MATERIA: {
      NOME_OBRIGATORIO: "O nome da matéria é obrigatório",
      PESO_PROVA_OBRIGATORIO: "O peso das provas é obrigatório",
      PESO_TRABALHO_OBRIGATORIO: "O peso dos trabalhos é obrigatório",
      MEDIA_PARA_PASSAR_INVALIDA: "A média para passar não pode ser negativa e deve ser menor ou igual a nota máxima",
      PESO_DE_PROVA_INVALIDO: "O peso de prova está inválido. Por favor digite um valor positivo",
      PESO_DE_TRABALHO_INVALIDO: "O peso de trabalho está inválido. Por favor digite um valor positivo",
      NOTA_MAXIMA_INVALIDA: "A nota máxima está inválida. Por favor digite um valor positivo"
    },

    AVALIACAO: {
      NOME_OBRIGATORIO: "O nome da avaliação é obrigatório",
      TIPO_OBRIGATORIO: "O tipo da avaliação é obrigatório",
      MATERIA_OBRIGATORIA: "A matéria da avaliação é obrigatória"
    }
  },

  ALUNO: {
    ENCONTRADO_COM_SUCESSO: "Aluno encontrado com sucesso",
    NAO_ENCONTRADO: "Aluno não encontrado",
    TODOS_ALUNOS_ENCONTRADOS: "Alunos encontrados com sucesso",
    ATUALIZADO_COM_SUCESSO: "Aluno atualizado com sucesso",
    DELETADO_COM_SUCESSO: "Aluno deletado com sucesso",
    ID_NAO_FORNECIDO: "O id do aluno não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido do aluno é inválido"
  },

  PROFESSOR: {
    ENCONTRADO_COM_SUCESSO: "Professor encontrado com sucesso",
    NAO_ENCONTRADO: "Professor não encontrado",
    TODOS_PROFESSORES_ENCONTRADOS: "Professores encontrados com sucesso",
    ATUALIZADO_COM_SUCESSO: "Professor atualizado com sucesso",
    DELETADO_COM_SUCESSO: "Professor deletado com sucesso",
    ID_NAO_FORNECIDO: "O id do professor não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido do professor é inválido"
  },

  TURMA: {
    CRIADA_COM_SUCESSO: "Turma criada com sucesso",
    NOME_EM_USO: "Já existe uma turma cadastrada com esse nome",
    ENCONTRADA_COM_SUCESSO: "Turma encontrada com sucesso",
    NAO_ENCONTRADA: "Turma não encontrada",
    TODAS_TURMAS_ENCONTRADAS: "Turmas encontradas com sucesso",
    ATUALIZADA_COM_SUCESSO: "Turma atualizada com sucesso",
    DELETADA_COM_SUCESSO: "Turma deletada com sucesso",
    ID_NAO_FORNECIDO: "O id da turma não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido da turma é inválido"
  },

    SERIE: {
    CRIADA_COM_SUCESSO: "Série criada com sucesso",
    NOME_EM_USO: "Já existe uma série cadastrada com esse nome",
    ENCONTRADA_COM_SUCESSO: "Série encontrada com sucesso",
    NAO_ENCONTRADA: "Série não encontrada",
    TODAS_SERIES_ENCONTRADAS: "Séries encontradas com sucesso",
    ATUALIZADA_COM_SUCESSO: "Série atualizada com sucesso",
    DELETADA_COM_SUCESSO: "Série deletada com sucesso",
    ID_NAO_FORNECIDO: "O id da série não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido da série é inválido"
  },

  PASTA: {
    CRIADA_COM_SUCESSO: "Pasta criada com sucesso",
    NOME_EM_USO: "Já existe uma pasta com esse nome nesse diretório",
    ENCONTRADA_COM_SUCESSO: "Pasta encontrada com sucesso",
    NAO_ENCONTRADA: "Pasta não encontrada",
    TODAS_PASTAS_ENCONTRADAS: "Pastas encontradas com sucesso",
    ATUALIZADA_COM_SUCESSO: "Pasta atualizada com sucesso",
    DELETADA_COM_SUCESSO: "Pasta deletada com sucesso",
    ID_NAO_FORNECIDO: "O id da pasta não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido da pasta é inválido",
    SUBPASTAS_ENCONTRADAS: "Subpastas encontradas com sucesso"
  },

  ARQUIVO: {
    CRIADO_COM_SUCESSO: "Arquivo criado com sucesso",
    NOME_EM_USO: "Já existe um arquivo com esse nome nesse diretório",
    ENCONTRADO_COM_SUCESSO: "Arquivo encontrado com sucesso",
    NAO_ENCONTRADO: "Arquivo não encontrado",
    TODOS_ARQUIVOS_ENCONTRADOS: "Arquivos encontrados com sucesso",
    ATUALIZADO_COM_SUCESSO: "Arquivo atualizado com sucesso",
    DELETADO_COM_SUCESSO: "Arquivo deletado com sucesso",
    ID_NAO_FORNECIDO: "O id do arquivo não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido do arquivo é inválido",
    TIPO_DE_ARQUIVO_INVALIDO: "O tipo de arquivo fornecido não é válido",
    ARQUIVO_NAO_ENVIADO: "O arquivo não foi enviado",
    ARQUIVO_MUITO_GRANDE: "O arquivo enviado excede o limite de tamanho permitido"
  },

  MATERIA: {
    CRIADA_COM_SUCESSO: "Matéria criada com sucesso",
    NOME_EM_USO: "Já existe uma matéria com esse nome",
    ENCONTRADA_COM_SUCESSO: "Matéria encontrada com sucesso",
    NAO_ENCONTRADA: "Matéria não encontrada",
    TODAS_MATERIAS_ENCONTRADAS: "Matérias encontradas com sucesso",
    ATUALIZADA_COM_SUCESSO: "Matéria atualizada com sucesso",
    DELETADA_COM_SUCESSO: "Matéria deletada com sucesso",
    ID_NAO_FORNECIDO: "O id da matéria não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido da matéria é inválido"
  },

  AVALIACAO: {
    CRIADA_COM_SUCESSO: "Avaliação criada com sucesso",
    NOME_EM_USO: "Já existe uma avaliação com esse nome para essa matéria",
    ENCONTRADA_COM_SUCESSO: "Avaliação encontrada com sucesso",
    NAO_ENCONTRADA: "Avaliação não encontrada",
    TODAS_AVALIACOES_ENCONTRADAS: "Avaliações encontradas com sucesso",
    ATUALIZADA_COM_SUCESSO: "Avaliação atualizada com sucesso",
    DELETADA_COM_SUCESSO: "Avaliação deletada com sucesso",
    ID_NAO_FORNECIDO: "O id da avaliação não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido da avaliação é inválido"
  },

  NOTA: {
    CRIADA_COM_SUCESSO: "Nota criada com sucesso",
    JA_EXISTE: "Já existe uma nota para este aluno nesta avaliação",
    ENCONTRADA_COM_SUCESSO: "Nota encontrada com sucesso",
    NAO_ENCONTRADA: "Nota não encontrada",
    TODAS_NOTAS_ENCONTRADAS: "Notas encontradas com sucesso",
    ATUALIZADA_COM_SUCESSO: "Nota atualizada com sucesso",
    DELETADA_COM_SUCESSO: "Nota deletada com sucesso",
    ID_NAO_FORNECIDO: "O id da nota não foi fornecido",
    ID_FORNECIDO_INVALIDO: "O id fornecido da nota é inválido"
  }
}

module.exports = Object.freeze(RESPONSE_MESSAGES);
