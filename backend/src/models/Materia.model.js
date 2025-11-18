const mongoose = require("mongoose")

const {validaMediaParaPassar} = require("../utils/validators.utils")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const MEDIA_DEFAULT = 6
const NOTA_MAXIMA_DEFAULT = 10

const materiaSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, VALIDACAO.MATERIA.NOME_OBRIGATORIO],
    unique,
    trim
  },
  pesoProva: {
    type: Number,
    required: [true, VALIDACAO.MATERIA.PESO_PROVA_OBRIGATORIO]
  },
  pesoTrabalho: {
    type: Number,
    required: [true, VALIDACAO.MATERIA.PESO_TRABALHO_OBRIGATORIO]
  },
  mediaParaPassar: {
    type: Number,
    default: MEDIA_DEFAULT,
    validate: {
      validator: validaMediaParaPassar,
      message: VALIDACAO.MATERIA.MEDIA_PARA_PASSAR_INVALIDA
    }
  },
  notaMaxima: {
    type: Number,
    default: NOTA_MAXIMA_DEFAULT
  }
})

const Materia = mongoose.model("Materia", materiaSchema)

module.exports = Materia
