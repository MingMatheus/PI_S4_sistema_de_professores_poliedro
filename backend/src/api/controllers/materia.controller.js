const mongoose = require("mongoose")
const Materia = require("../../models/Materia.model")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

const {
  MATERIA,
  ERRO,
} = require("../../constants/responseMessages.constants")

exports.createMateria = async (req, res) => {
  try {
    const materia = new Materia(req.body);
    const novaMateria = await materia.save();

    res.status(201).json({
      mensagem: MATERIA.CRIADA_COM_SUCESSO,
      materia: novaMateria
    });
  } catch (error) {
    if (error.code == MONGO_DUPLICATE_KEY) {
      return res.status(409).json({ mensagem: MATERIA.NOME_EM_USO });
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

exports.getTodasMaterias = async (req, res) => {
  try {
    const materias = await Materia.find().select("-__v")
    res.status(200).json({
      mensagem: MATERIA.TODAS_MATERIAS_ENCONTRADAS,
      materias: materias
    })
  }
  catch (error) {
    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}

exports.getMateriaById = async (req, res) => {
  try {
    const { id } = req.params

    if (!id)
      return res.status(400).json({ mensagem: MATERIA.ID_NAO_FORNECIDO })

    if (!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({ mensagem: MATERIA.ID_FORNECIDO_INVALIDO })

    const materia = await Materia.findById(id).select("-__v")

    if (!materia)
      return res.status(404).json({ mensagem: MATERIA.NAO_ENCONTRADA })

    res.status(200).json({
      mensagem: MATERIA.ENCONTRADA_COM_SUCESSO,
      materia: materia
    })
  }
  catch (error) {
    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}

exports.updateMateriaById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: MATERIA.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: MATERIA.ID_FORNECIDO_INVALIDO})

    const { nome, pesoProva, pesoTrabalho, mediaParaPassar, notaMaxima } = req.body

    // 1. Find
    const materia = await Materia.findById(id).select("-__v")

    if (!materia)
      return res.status(404).json({mensagem: MATERIA.NAO_ENCONTRADA})

    // 2. Modify
    if(nome) materia.nome = nome
    if(pesoProva) materia.pesoProva = pesoProva
    if(pesoTrabalho) materia.pesoTrabalho = pesoTrabalho
    if(mediaParaPassar) materia.mediaParaPassar = mediaParaPassar
    if(notaMaxima) materia.notaMaxima = notaMaxima

    // 3. Save
    await materia.save()

    res.status(200).json({
      mensagem: MATERIA.ATUALIZADA_COM_SUCESSO,
      materia: materia
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      return res.status(409).json({mensagem: MATERIA.NOME_EM_USO})
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

exports.deleteMateriaById = async (req, res) => {
  try {
    const { id } = req.params

    if (!id)
      return res.status(400).json({ mensagem: MATERIA.ID_NAO_FORNECIDO })

    if (!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({ mensagem: MATERIA.ID_FORNECIDO_INVALIDO })

    const materia = await Materia.findByIdAndDelete(id).select("-__v");

    if (!materia)
      return res.status(404).json({ mensagem: MATERIA.NAO_ENCONTRADA });

    res.status(200).json({
      mensagem: MATERIA.DELETADA_COM_SUCESSO,
      materia: materia
    })
  }
  catch (error) {
    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}
