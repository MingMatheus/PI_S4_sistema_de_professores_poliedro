const mongoose = require("mongoose")

const alunoSchema = mongoose.Schema({
  email: {
    type: String,
    required: [true, "O email é obrigatório"],
    unique: true,
    trim: true,
    lowercase: true,
    match: [
      /^\S+@\S+\.\S+$/,
      "Email inválido"
    ]
  },
  senha: {
    type: String,
    required: [true, "A senha é obrigatória"],
    minlength: 8,
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

const Aluno = mongoose.model("Aluno", alunoSchema)

module.exports = Aluno
