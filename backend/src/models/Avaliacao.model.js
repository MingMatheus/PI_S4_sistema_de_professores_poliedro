const mongoose = require("mongoose")

// Tirei o TIPOS_DE_AVALIACAO daqui
// porque vamos aceitar qualquer string em `tipo`
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
    trim: true
    // sem enum aqui de propósito
  },
  materia: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Materia",
    // continua opcional, pra não quebrar a tela de atividades agora
  },
  notaMaxima: {
    type: Number,
    default: 10
  },
  descricao: {
    type: String,
    trim: true
  },
  turma: {
    type: String,
    trim: true
  },
  dataEntrega: {
    type: String, // ex: "20/03/2025"
    trim: true
  },
  status: {
    type: String,
    enum: ["Aberta", "Encerrada"],
    default: "Aberta"
  }
})

// mantém o índice como estava
avaliacaoSchema.index({ nome: 1, materia: 1 }, { unique: true })

const Avaliacao = mongoose.model("Avaliacao", avaliacaoSchema)

module.exports = Avaliacao
