const mongoose = require("mongoose")
const Aviso = require("../../models/Aviso.model")

const {
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

const {
  ROLES
} = require("../../constants/validation.constants")

const {
  AVISO,
  ERRO,
  AUTH
} = require("../../constants/responseMessages.constants")

exports.createAviso = async (req, res) => {
  try
  {
    const novoAviso = new Aviso({
      ...req.body,
      autor: req.user.sub
    });

    await novoAviso.save();

    res.status(201).json({
      mensagem: AVISO.CRIADO_COM_SUCESSO,
      aviso: novoAviso
    });

  }
  catch(error)
  {
    if(error.name == MONGOOSE_VALIDATION_ERROR)
    {
      const errorMessages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO,
        erros: errorMessages
      });
    }

    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR});
  }
}

exports.getTodosAvisos = async (req, res) => {
  try
  {
    const avisos = await Aviso.find().select("-__v")
    res.status(200).json({
      mensagem: AVISO.TODOS_AVISOS_ENCONTRADOS,
      avisos: avisos
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getAvisoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: AVISO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: AVISO.ID_FORNECIDO_INVALIDO})

    const aviso = await Aviso.findById(id).select("-__v")

    if (!aviso)
      return res.status(404).json({mensagem: AVISO.NAO_ENCONTRADO})

    res.status(200).json({
      mensagem: AVISO.ENCONTRADO_COM_SUCESSO,
      aviso: aviso
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateAvisoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: AVISO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: AVISO.ID_FORNECIDO_INVALIDO})

    const { titulo, conteudo, seriesAlvo, turmasAlvo, alunosAlvo } = req.body

    const aviso = await Aviso.findById(id)

    if (!aviso)
      return res.status(404).json({mensagem: AVISO.NAO_ENCONTRADO})

    if (aviso.autor.toString() !== req.user.sub) {
        return res.status(403).json({ mensagem: AUTH.NAO_TEM_PERMISSAO });
    }

    if(titulo) aviso.titulo = titulo
    if(conteudo) aviso.conteudo = conteudo
    if(seriesAlvo) aviso.seriesAlvo = seriesAlvo
    if(turmasAlvo) aviso.turmasAlvo = turmasAlvo
    if(alunosAlvo) aviso.alunosAlvo = alunosAlvo

    await aviso.save()

    res.status(200).json({
      mensagem: AVISO.ATUALIZADO_COM_SUCESSO,
      aviso: aviso
    })
  }
  catch(error)
  {
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

exports.deleteAvisoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: AVISO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: AVISO.ID_FORNECIDO_INVALIDO})

    const aviso = await Aviso.findById(id);

    if (!aviso)
      return res.status(404).json({mensagem: AVISO.NAO_ENCONTRADO});

    if (aviso.autor.toString() !== req.user.sub)
      return res.status(403).json({ mensagem: AUTH.NAO_TEM_PERMISSAO });

    const avisoDeletado = await Aviso.findByIdAndDelete(id).select("-__v");

    res.status(200).json({
      mensagem: AVISO.DELETADO_COM_SUCESSO,
      aviso: avisoDeletado
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}
