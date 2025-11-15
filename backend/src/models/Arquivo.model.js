const mongoose = require("mongoose")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const arquivoSchema = mongoose.Schema({
  nomeOriginal: {
    type: String,
    required: [true, VALIDACAO.ARQUIVO.NOME_ORIGINAL_OBRIGATORIO],
    trim: true,
  },
  nomeNoSistema: {
    type: String,
    required: [true, VALIDACAO.ARQUIVO.NOME_NO_SISTEMA_OBRIGATORIO],
    unique: true,
  },
  tamanho: {
    type: Number, // Tamanho do arquivo em bytes.
    required: [true, VALIDACAO.ARQUIVO.TAMANHO_OBRIGATORIO],
  },
  tipo: {
    type: String,
    required: [true, VALIDACAO.ARQUIVO.TIPO_OBRIGATORIO],
  },
  caminho: {
    type: String, // O caminho físico no disco do servidor (ex: 'backend/uploads/nome-unico.pdf').
    required: [true, VALIDACAO.ARQUIVO.CAMINHO_OBRIGATORIO],
  },
  url: {
    type: String, // A URL para acessar o arquivo
    required: [true, VALIDACAO.ARQUIVO.URL_OBRIGATORIA],
  },
  pastaOndeSeEncontra: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Pasta',
    default: null
  },
  professorQueFezOUpload: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Professor',
    required: [true, VALIDACAO.ARQUIVO.PROFESSOR_QUE_FEZ_O_UPLOAD_OBRIGATORIO],
  }
},
{
  timestamps: true
})

arquivoSchema.index({pastaOndeSeEncontra: 1, nomeOriginal: 1}, {unique: true});

const Arquivo = mongoose.model("Arquivo", arquivoSchema)

module.exports = Arquivo
