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
    const avaliacao = new Avaliacao(req.body)
    const novaAvaliacao = await avaliacao.save()

    res.status(201).json({
      mensagem: AVALIACAO.CRIADA_COM_SUCESSO,
      avaliacao: novaAvaliacao
    })
  } catch (error) {
    if (error.code == MONGO_DUPLICATE_KEY) {
      return res.status(409).json({ mensagem: AVALIACAO.NOME_EM_USO })
    }

    if (error.name == MONGOOSE_VALIDATION_ERROR) {
      const errorMessages = Object.values(error.errors).map(err => err.message)
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      })
    }

    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}

exports.getTodasAvaliacoes = async (req, res) => {
  try {
    const avaliacoes = await Avaliacao.find()
      .select("-__v")
      .populate("materia", "nome")

    res.status(200).json({
      mensagem: AVALIACAO.TODAS_AVALIACOES_ENCONTRADAS,
      avaliacoes: avaliacoes
    })
  }
  catch (error) {
    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}

exports.getAvaliacaoById = async (req, res) => {
  try {
    const { id } = req.params

    if (!id)
      return res.status(400).json({ mensagem: AVALIACAO.ID_NAO_FORNECIDO })

    if (!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({ mensagem: AVALIACAO.ID_FORNECIDO_INVALIDO })

    const avaliacao = await Avaliacao.findById(id)
      .select("-__v")
      .populate("materia", "nome")

    if (!avaliacao)
      return res.status(404).json({ mensagem: AVALIACAO.NAO_ENCONTRADA })

    res.status(200).json({
      mensagem: AVALIACAO.ENCONTRADA_COM_SUCESSO,
      avaliacao: avaliacao
    })
  }
  catch (error) {
    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}

exports.updateAvaliacaoById = async (req, res) => {
  try {
    const { id } = req.params

    if (!id)
      return res.status(400).json({ mensagem: AVALIACAO.ID_NAO_FORNECIDO })

    if (!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({ mensagem: AVALIACAO.ID_FORNECIDO_INVALIDO })

    const {
      nome,
      peso,
      tipo,
      materia,
      notaMaxima,
      descricao,
      turma,
      dataEntrega,
      status
    } = req.body

    const avaliacao = await Avaliacao.findById(id).select("-__v")

    if (!avaliacao)
      return res.status(404).json({ mensagem: AVALIACAO.NAO_ENCONTRADA })

    if (nome !== undefined) avaliacao.nome = nome
    if (peso !== undefined) avaliacao.peso = peso
    if (tipo !== undefined) avaliacao.tipo = tipo
    if (materia !== undefined) avaliacao.materia = materia
    if (notaMaxima !== undefined) avaliacao.notaMaxima = notaMaxima
    if (descricao !== undefined) avaliacao.descricao = descricao
    if (turma !== undefined) avaliacao.turma = turma
    if (dataEntrega !== undefined) avaliacao.dataEntrega = dataEntrega
    if (status !== undefined) avaliacao.status = status

    await avaliacao.save()

    res.status(200).json({
      mensagem: AVALIACAO.ATUALIZADA_COM_SUCESSO,
      avaliacao: avaliacao
    })
  }
  catch (error) {
    if (error.code == MONGO_DUPLICATE_KEY) {
      return res.status(409).json({ mensagem: AVALIACAO.NOME_EM_USO })
    }

    if (error.name == MONGOOSE_VALIDATION_ERROR) {
      const errorMessages = Object.values(error.errors).map(err => err.message)
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      })
    }

    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}

exports.deleteAvaliacaoById = async (req, res) => {
  try {
    const { id } = req.params

    if (!id)
      return res.status(400).json({ mensagem: AVALIACAO.ID_NAO_FORNECIDO })

    if (!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({ mensagem: AVALIACAO.ID_FORNECIDO_INVALIDO })

    const avaliacao = await Avaliacao.findByIdAndDelete(id)
      .select("-__v")
      .populate("materia", "nome")

    if (!avaliacao)
      return res.status(404).json({ mensagem: AVALIACAO.NAO_ENCONTRADA })

    res.status(200).json({
      mensagem: AVALIACAO.DELETADA_COM_SUCESSO,
      avaliacao: avaliacao
    })
  }
  catch (error) {
    return res.status(500).json({ mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR })
  }
}
