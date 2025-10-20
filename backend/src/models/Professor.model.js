const mongoose = require("mongoose")
const bcrypt = require("bcrypt")
const {validaEmailProfessor, validaSenha} = require("../utils/validators.utils")

const professorSchema = mongoose.Schema({
  email: {
    type: String,
    required: [true, "O email é obrigatório"],
    unique: true,
    trim: true,
    lowercase: true,
    validate: {
      validator: validaEmailProfessor,
      message: "Por favor insira um email de professor válido"
    }
  },
  senha: {
    type: String,
    required: [true, "A senha é obrigatória"],
    select: false
  },
  nome: {
    type: String,
    required: [true, "O nome do professor é obrigatório"],
    trim: true
  }
})

professorSchema.pre("save", async function(next) {
  const professor = this

  if (!professor.isModified("senha"))
    return next();

  // 1. Valida a senha
  if(!validaSenha(professor.senha))
    return next(new Error("A senha está inválida"))

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
