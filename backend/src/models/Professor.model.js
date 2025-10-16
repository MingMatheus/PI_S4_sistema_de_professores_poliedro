const mongoose = require("mongoose")

const professorSchema = mongoose.Schema({
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
    required: [true, "O nome do professor é obrigatório"],
    trim: true
  }
})

const Professor = mongoose.model("Professor", professorSchema)

module.exports = Professor
