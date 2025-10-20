const mongoose = require("mongoose")
const bcrypt = require("bcrypt")
const {validaEmailProfessor, validaSenha} = require("../utils/validators.utils")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const professorSchema = mongoose.Schema({
  email: {
    type: String,
    required: [true, VALIDACAO.GERAL.EMAIL_OBRIGATORIO],
    unique: true,
    trim: true,
    lowercase: true,
    validate: {
      validator: validaEmailProfessor,
      message: VALIDACAO.PROFESSOR.EMAIL_INVALIDO
    }
  },
  senha: {
    type: String,
    required: [true, VALIDACAO.GERAL.SENHA_OBRIGATORIA],
    select: false
  },
  nome: {
    type: String,
    required: [true, VALIDACAO.PROFESSOR.NOME_OBRIGATORIO],
    trim: true
  }
})

professorSchema.pre("save", async function(next) {
  const professor = this

  if (!professor.isModified("senha"))
    return next();

  // 1. Valida a senha
  if(!validaSenha(professor.senha))
    return next(new Error(VALIDACAO.GERAL.SENHA_INVALIDA))

  // 2. Faz o hashing
  try
  {
    const senhaHasheada = await bcrypt.hash(professor.senha, 10)
    professor.senha = senhaHasheada
    next()
  }
  catch(error)
  {
    next(error);
  }
})

const Professor = mongoose.model("Professor", professorSchema)

module.exports = Professor
