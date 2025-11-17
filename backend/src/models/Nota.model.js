const mongoose = require("mongoose")

const {validaNotaObtida} = require("../utils/validators.utils")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const notaSchema = mongoose.Schema({
  notaObtida: {
    type: Number,
    required: [true, VALIDACAO.NOTA.NOTA_OBRIGATORIA],
    validate: {
      validator: validaNotaObtida,
      message: VALIDACAO.NOTA.NOTA_INVALIDA
    }
  },
  aluno: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Aluno",
    required: [true, VALIDACAO.NOTA.ALUNO_OBRIGATORIO]
  },
  avaliacao: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Avaliacao",
    required: [true, VALIDACAO.NOTA.AVALIACAO_OBRIGATORIA]
  }
})

notaSchema.index({aluno: 1, avaliacao: 1}, {unique: true})

const Nota = mongoose.model("Nota", notaSchema)

module.exports = Nota
