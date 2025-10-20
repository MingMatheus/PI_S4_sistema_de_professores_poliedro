const mongoose = require("mongoose")
const bcrypt = require("bcrypt")
const {validaEmailAluno, validaSenha} = require("../utils/validators.utils")

const alunoSchema = mongoose.Schema({
  email: {
    type: String,
    required: [true, "O email é obrigatório"],
    unique: true,
    trim: true,
    lowercase: true,
    validate: {
      validator: validaEmailAluno,
      message: "Por favor insira um email de aluno válido"
    }
  },
  senha: {
    type: String,
    required: [true, "A senha é obrigatória"],
    select: false
  },
  nome: {
    type: String,
    required: [true, "O nome do aluno é obrigatório"],
    trim: true
  },
  turma: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Turma",
    default: null
  },
  ra: {
    type: String,
    required: [true, "O RA é obrigatório"],
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
    return next(new Error("A senha está inválida"))

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
