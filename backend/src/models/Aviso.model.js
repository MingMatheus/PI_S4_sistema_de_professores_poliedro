const mongoose = require("mongoose")

const {
  VALIDACAO
} = require("../constants/responseMessages.constants")

const avisoSchema = mongoose.Schema({
  titulo: {
    type: String,
    required: [true, VALIDACAO.AVISO.TITULO_OBRIGATORIO],
    trim: true
  },
  conteudo: {
    type: String,
    required: [true, VALIDACAO.AVISO.CONTEUDO_OBRIGATORIO]
  },
  autor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Professor",
    required: [true, VALIDACAO.AVISO.AUTOR_OBRIGATORIO]
  },
  seriesAlvo: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Serie',
    default: []
  }],
  turmasAlvo: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Turma',
    default: []
  }],
  alunosAlvo: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Aluno',
    default: []
  }]
},
{
  timestamps: true
})

avisoSchema.pre('save', function(next) {
  const aviso = this;

  // Verifica o tamanho dos arrays
  const temSerie = aviso.seriesAlvo && aviso.seriesAlvo.length > 0;
  const temTurma = aviso.turmasAlvo && aviso.turmasAlvo.length > 0;
  const temAluno = aviso.alunosAlvo && aviso.alunosAlvo.length > 0;

  // Se nenhum dos três tiver conteúdo, lança erro
  if(!temSerie && !temTurma && !temAluno)
  {
    // Cria um erro de validação do Mongoose manualmente
    const erro = new mongoose.Error.ValidationError(null);
    erro.addError('destinatarios', new mongoose.Error.ValidatorError({
      message: VALIDACAO.AVISO.DESTINATARIO_OBRIGATORIO,
      path: 'destinatarios', // Um "campo virtual" para o erro
    }));
    
    return next(erro);
  }

  next();
});

const Aviso = mongoose.model("Aviso", avisoSchema)

module.exports = Aviso
