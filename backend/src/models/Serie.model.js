const mongoose = require("mongoose")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const serieSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, VALIDACAO.SERIE.NOME_OBRIGATORIO],
    unique: true,
    trim: true
  }
})

const Serie = mongoose.model("Serie", serieSchema);

module.exports = Serie
