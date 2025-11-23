const mongoose = require("mongoose")
const Turma = require("../../models/Turma.model")
const Aluno = require("../../models/Aluno.model")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

const {
  TURMA,
  ERRO
} = require("../../constants/responseMessages.constants")

exports.cadastraTurma = async (req, res) => {
  try
  {
    const turma = new Turma(req.body)

    await turma.save()

    res.status(201).json({mensagem: TURMA.CRIADA_COM_SUCESSO})
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      if(error.keyValue.nome)
        return res.status(409).json({mensagem: TURMA.NOME_EM_USO})

      return res.status(409).json({mensagem: ERRO.UNICIDADE});
    }

    if(error.name == MONGOOSE_VALIDATION_ERROR)  // código 400 significa bad request
    {
      const errorMessages = Object.values(error.errors).map(err => err.message);

      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      })
    }

    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR}) // código 500, internal server error
  }
}

exports.getTurmaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: TURMA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: TURMA.ID_FORNECIDO_INVALIDO})

    const turma = await Turma.findById(id)
      .select("-__v")
      .populate("serie", "nome")

    if (!turma)
      return res.status(404).json({mensagem: TURMA.NAO_ENCONTRADA})

    res.status(200).json({
      mensagem: TURMA.ENCONTRADA_COM_SUCESSO,
      turma: turma
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getTodasTurmas = async (req, res) => {
  try
  {
    const turmas = await Turma.find()
      .select("-__v")
      .populate("serie", "nome")

    res.status(200).json({
      mensagem: TURMA.TODAS_TURMAS_ENCONTRADAS,
      turmas: turmas
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateTurmaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: TURMA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: TURMA.ID_FORNECIDO_INVALIDO})

    const{nome, serie} = req.body

    // 1. Find
    const turma = await Turma.findById(id).select("-__v")

    if (!turma)
      return res.status(404).json({mensagem: TURMA.NAO_ENCONTRADA})

    // 2. Modify
    if(nome) turma.nome = nome
    if(serie) turma.serie = serie

    // 3. Save
    await turma.save()

    res.status(200).json({
      mensagem: TURMA.ATUALIZADA_COM_SUCESSO,
      turma: turma
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      if(error.keyValue.nome)
        return res.status(409).json({mensagem: TURMA.NOME_EM_USO})

      return res.status(409).json({mensagem: ERRO.UNICIDADE});
    }

    if(error.name == MONGOOSE_VALIDATION_ERROR)
    {
      const errorMessages = Object.values(error.errors).map(err => err.message);

      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      })
    }

    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.deleteTurmaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: TURMA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: TURMA.ID_FORNECIDO_INVALIDO})

    const turmaDeletada = await Turma.findByIdAndDelete(id)
      .select("-__v")
      .populate("serie", "nome")

    if (!turmaDeletada)
      return res.status(404).json({mensagem: TURMA.NAO_ENCONTRADA})

    await Aluno.updateMany(
      { turma: id }, 
      { $set: { turma: null } }
    )

    res.status(200).json({
      mensagem: TURMA.DELETADA_COM_SUCESSO,
      turma: turmaDeletada
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}
