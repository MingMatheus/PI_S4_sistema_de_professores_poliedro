const mongoose = require("mongoose")

const {
  TIPOS_DE_AVALIACAO
} = require("../constants/validation.constants")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const avaliacaoSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, VALIDACAO.AVALIACAO.NOME_OBRIGATORIO],
    trim: true
  },
  peso: {
    type: Number,
    default: 1
  },
  tipo: {
    type: String,
    required: [true, VALIDACAO.AVALIACAO.TIPO_OBRIGATORIO],
    enum: Object.values(TIPOS_DE_AVALIACAO)
  },
  materia: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Materia",
    required: [true, VALIDACAO.AVALIACAO.MATERIA_OBRIGATORIA]
  },
  notaMaxima: {
    type: Number,
    default: 10
  }
})

avaliacaoSchema.index({nome: 1, materia: 1}, {unique: true})

const Avaliacao = mongoose.model("Avaliacao", avaliacaoSchema)

module.exports = Avaliacao
