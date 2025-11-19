const mongoose = require("mongoose")

const {
  validaMediaParaPassar,
  validaPeso,
  validaNotaMaxima
} = require("../utils/validators.utils")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const MEDIA_DEFAULT = 6
const NOTA_MAXIMA_DEFAULT = 10

const materiaSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, VALIDACAO.MATERIA.NOME_OBRIGATORIO],
    unique: true,
    trim: true
  },
  pesoProva: {
    type: Number,
    required: [true, VALIDACAO.MATERIA.PESO_PROVA_OBRIGATORIO],
    validate: {
      validator: validaPeso,
      message: VALIDACAO.MATERIA.PESO_DE_PROVA_INVALIDO
    }
  },
  pesoTrabalho: {
    type: Number,
    required: [true, VALIDACAO.MATERIA.PESO_TRABALHO_OBRIGATORIO],
    validate: {
      validator: validaPeso,
      message: VALIDACAO.MATERIA.PESO_DE_TRABALHO_INVALIDO
    }
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
    default: NOTA_MAXIMA_DEFAULT,
    validate: {
      validator: validaNotaMaxima,
      message: VALIDACAO.MATERIA.NOTA_MAXIMA_INVALIDA
    }
  }
})

const Materia = mongoose.model("Materia", materiaSchema)

module.exports = Materia
