const mongoose = require("mongoose")
const Avaliacao = require("../../models/Avaliacao.model")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

const {
  AVALIACAO,
  ERRO,
} = require("../../constants/responseMessages.constants")

exports.createAvaliacao = async (req, res) => {
  try {
    const avaliacao = new Avaliacao(req.body);
    const novaAvaliacao = await avaliacao.save();

    res.status(201).json({
      mensagem: AVALIACAO.CRIADA_COM_SUCESSO,
      avaliacao: novaAvaliacao
    });
  } catch (error) {
    if (error.code == MONGO_DUPLICATE_KEY) {
      return res.status(409).json({ mensagem: AVALIACAO.NOME_EM_USO });
    }

    if (error.name == MONGOOSE_VALIDATION_ERROR) {
      const errorMessages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      });
    }

    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR });
  }
};

exports.getTodasAvaliacoes = async (req, res) => {
  try
  {
    // Note: In a real application, you'd likely want to filter these by materia.
    // e.g., /api/materias/:materiaId/avaliacoes
    const avaliacoes = await Avaliacao.find()
      .select("-__v")
      .populate("materia", "nome")

    res.status(200).json({
      mensagem: AVALIACAO.TODAS_AVALIACOES_ENCONTRADAS,
      avaliacoes: avaliacoes
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getAvaliacaoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: AVALIACAO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: AVALIACAO.ID_FORNECIDO_INVALIDO})

    const avaliacao = await Avaliacao.findById(id)
      .select("-__v")
      .populate("materia", "nome")

    if (!avaliacao)
      return res.status(404).json({mensagem: AVALIACAO.NAO_ENCONTRADA})

    res.status(200).json({
      mensagem: AVALIACAO.ENCONTRADA_COM_SUCESSO,
      avaliacao: avaliacao
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateAvaliacaoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: AVALIACAO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: AVALIACAO.ID_FORNECIDO_INVALIDO})

    const { nome, peso, tipo, materia, notaMaxima } = req.body

    // 1. Find
    const avaliacao = await Avaliacao.findById(id).select("-__v")

    if (!avaliacao)
      return res.status(404).json({mensagem: AVALIACAO.NAO_ENCONTRADA})

    // 2. Modify
    if(nome) avaliacao.nome = nome
    if(peso) avaliacao.peso = peso
    if(tipo) avaliacao.tipo = tipo
    if(materia) avaliacao.materia = materia
    if(notaMaxima) avaliacao.notaMaxima = notaMaxima

    // 3. Save
    await avaliacao.save()

    res.status(200).json({
      mensagem: AVALIACAO.ATUALIZADA_COM_SUCESSO,
      avaliacao: avaliacao
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      return res.status(409).json({mensagem: AVALIACAO.NOME_EM_USO})
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

exports.deleteAvaliacaoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: AVALIACAO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: AVALIACAO.ID_FORNECIDO_INVALIDO})
      
    const avaliacao = await Avaliacao.findByIdAndDelete(id)
      .select("-__v")
      .populate("materia", "nome")

    if (!avaliacao)
      return res.status(404).json({mensagem: AVALIACAO.NAO_ENCONTRADA});

    res.status(200).json({
      mensagem: AVALIACAO.DELETADA_COM_SUCESSO,
      avaliacao: avaliacao
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}
