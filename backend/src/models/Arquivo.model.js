const mongoose = require("mongoose")

const arquivoSchema = mongoose.Schema({
  nomeOriginal: {
    type: String,
    required: [true, 'O nome original do arquivo é obrigatório.'],
    trim: true,
  },
  nomeNoSistema: {
    type: String,
    required: true,
    unique: true,
  },
  tamanho: {
    type: Number, // Tamanho do arquivo em bytes.
    required: true,
  },
  tipo: {
    type: String,
    required: true,
  },
  caminho: {
    type: String, // O caminho físico no disco do servidor (ex: 'backend/uploads/nome-unico.pdf').
    required: true,
  },
  url: {
    type: String, // A URL para acessar o arquivo
    required: true,
  },
  pastaOndeSeEncontra: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Pasta',
    required: true,
  },
  professorQueFezOUpload: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Professor',
    required: true,
  }
},
{
  timestamps: true
})

const Arquivo = mongoose.model("Arquivo", arquivoSchema)

module.exports = Arquivo
