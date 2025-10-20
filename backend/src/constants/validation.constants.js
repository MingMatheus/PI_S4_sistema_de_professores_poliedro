const VALIDATION_CONSTANTS = {
  // Constantes de Senha
  TAMANHO_MINIMO_SENHA: 8,

  // Constantes de Email
  REGEX_EMAIL_GERAL: /^\S+@\S+\.\S+$/,
  REGEX_EMAIL_PROFESSOR: /.*@sistemapoliedro.com.br$/,
  
  // Constantes de Cargos (Roles)
  ROLES: {
    ALUNO: "aluno",
    PROFESSOR: "professor"
  }
}

// Congela o objeto para torná-lo imutável
module.exports = Object.freeze(VALIDATION_CONSTANTS)
