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
  ERRO
} = require("../../constants/responseMessages.constants")

exports.createAviso = async (req, res) => {
  try
  {
    const novoAviso = new Aviso({
      ...req.body,
      autor: req.user.sub
    });

    await novoAviso.save(); // O hook pre('save') roda aqui!

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
