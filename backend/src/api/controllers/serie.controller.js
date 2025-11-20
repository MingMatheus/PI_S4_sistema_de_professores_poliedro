const Serie = require("../../models/Serie.model")
const Turma = require("../../models/Turma.model")
const mongoose = require("mongoose")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

const {
  SERIE,
  ERRO
} = require("../../constants/responseMessages.constants")

exports.cadastraSerie = async (req, res) => {
  try
  {
    const serie = new Serie(req.body)

    await serie.save()

    res.status(201).json({mensagem: SERIE.CRIADA_COM_SUCESSO})
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      if(error.keyValue.nome)
        return res.status(409).json({mensagem: SERIE.NOME_EM_USO})

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

exports.getSerieById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: SERIE.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: SERIE.ID_FORNECIDO_INVALIDO})

    const serie = await Serie.findById(id).select("-__v")

    if (!serie)
      return res.status(404).json({mensagem: SERIE.NAO_ENCONTRADA})

    res.status(200).json({
      mensagem: SERIE.ENCONTRADA_COM_SUCESSO,
      serie: serie
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getTodasSeries = async (req, res) => {
  try
  {
    const series = await Serie.find().select("-__v")
    res.status(200).json({
      mensagem: SERIE.TODAS_SERIES_ENCONTRADAS,
      series: series
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateSerieById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: SERIE.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: SERIE.ID_FORNECIDO_INVALIDO})

    const{nome} = req.body

    // 1. Find
    const serie = await Serie.findById(id).select("-__v")

    if (!serie)
      return res.status(404).json({mensagem: SERIE.NAO_ENCONTRADA})

    // 2. Modify
    if(nome) serie.nome = nome

    // 3. Save
    await serie.save()

    res.status(200).json({
      mensagem: SERIE.ATUALIZADA_COM_SUCESSO,
      serie: serie
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      if(error.keyValue.nome)
        return res.status(409).json({mensagem: SERIE.NOME_EM_USO})

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

exports.deleteSerieById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: SERIE.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: SERIE.ID_FORNECIDO_INVALIDO})

    const serieDeletada = await Serie.findByIdAndDelete(id).select("-__v")

    if (!serieDeletada)
      return res.status(404).json({mensagem: SERIE.NAO_ENCONTRADA})

    await Turma.updateMany(
      { serie: id }, 
      { $set: { serie: null } }
    );

    res.status(200).json({
      mensagem: SERIE.DELETADA_COM_SUCESSO,
      serie: serieDeletada
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}
