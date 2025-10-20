const mongoose = require("mongoose")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const turmaSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, VALIDACAO.TURMA.NOME_OBRIGATORIO],
    unique: true,
    trim: true
  },
  serie: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Serie",
    default: null
  }
})

const Turma = mongoose.model("Turma", turmaSchema)

module.exports = Turma
