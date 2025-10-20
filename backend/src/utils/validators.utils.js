const {
  TAMANHO_MINIMO_SENHA,
  REGEX_EMAIL_GERAL,
  REGEX_EMAIL_PROFESSOR
} = require("../../constants/validation.constants")

const validaEmail = (email) => {
  if(!email) return false

  return REGEX_EMAIL_GERAL.test(email)
}

const validaEmailAluno = (emailAluno) => {
  if(!emailAluno) return false

  return REGEX_EMAIL_GERAL.test(emailAluno) && !REGEX_EMAIL_PROFESSOR.test(emailAluno)
}

const validaEmailProfessor = (emailProfessor) => {
  if(!emailProfessor) return false

  return REGEX_EMAIL_GERAL.test(emailProfessor) && REGEX_EMAIL_PROFESSOR.test(emailProfessor)
}

const validaSenha = (senha) => {
  if(!senha) return false

  return senha.legth >= TAMANHO_MINIMO_SENHA
}

module.exports = {
  validaEmail,
  validaEmailAluno,
  validaEmailProfessor,
  validaSenha
}
