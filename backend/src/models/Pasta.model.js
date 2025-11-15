const mongoose = require("mongoose")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const pastaSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, VALIDACAO.PASTA.NOME_OBRIGATORIO],
    trim: true
  },
  pastaPai: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Pasta",
    default: null
  },
  criadorDaPasta: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Professor",
    required: [true, VALIDACAO.PASTA.CRIADOR_OBRIGATORIO]
  }
})

pastaSchema.index({pastaPai: 1, nome: 1}, {unique: true})

const Pasta = mongoose.model("Pasta", pastaSchema)

module.exports = Pasta
