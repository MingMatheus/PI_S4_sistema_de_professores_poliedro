const mongoose = require("mongoose")
const bcrypt = require("bcrypt")
const {validaEmailAluno, validaSenha} = require("../utils/validators.utils")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const alunoSchema = mongoose.Schema({
  email: {
    type: String,
    required: [true, VALIDACAO.GERAL.EMAIL_OBRIGATORIO],
    unique: true,
    trim: true,
    lowercase: true,
    validate: {
      validator: validaEmailAluno,
      message: VALIDACAO.ALUNO.EMAIL_INVALIDO
    }
  },
  senha: {
    type: String,
    required: [true, VALIDACAO.GERAL.SENHA_OBRIGATORIA],
    select: false
  },
  nome: {
    type: String,
    required: [true, VALIDACAO.ALUNO.NOME_OBRIGATORIO],
    trim: true
  },
  turma: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Turma",
    default: null
  },
  ra: {
    type: String,
    required: [true, VALIDACAO.ALUNO.RA_OBRIGATORIO],
    unique: true,
    trim: true
  }
})

alunoSchema.pre("save", async function(next) {
  const aluno = this

  if (!aluno.isModified("senha"))
    return next();

  // 1. Valida a senha
  if(!validaSenha(aluno.senha))
    return next(new Error(VALIDACAO.GERAL.SENHA_INVALIDA))

  // 2. Faz o hashing
  try
  {
    const senhaHasheada = await bcrypt.hash(aluno.senha, 10)
    aluno.senha = senhaHasheada
    next()
  }
  catch(error)
  {
    next(error);
  }
})

const Aluno = mongoose.model("Aluno", alunoSchema)

module.exports = Aluno
