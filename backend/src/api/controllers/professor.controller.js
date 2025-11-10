const mongoose = require("mongoose")

const Professor = require("../../models/Professor.model")

const {
  ERRO,
  PROFESSOR,
  AUTH,
  VALIDACAO
} = require("../../constants/responseMessages.constants")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR,
  NOME_DE_ERRO_GENERICO
} = require("../../constants/error.constants")

exports.getProfessorById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: PROFESSOR.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PROFESSOR.ID_FORNECIDO_INVALIDO})

    const professor = await Professor.findById(id).select("-__v")

    if (!professor)
      return res.status(404).json({mensagem: PROFESSOR.NAO_ENCONTRADO})

    res.status(200).json({
      mensagem: PROFESSOR.ENCONTRADO_COM_SUCESSO,
      professor: professor
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getTodosProfessores = async (req, res) => {
  try
  {
    const professores = await Professor.find().select("-__v")
    res.status(200).json({
      mensagem: PROFESSOR.TODOS_PROFESSORES_ENCONTRADOS,
      professores: professores
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateProfessorById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: PROFESSOR.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PROFESSOR.ID_FORNECIDO_INVALIDO})

    const{email, senha, nome} = req.body

    // 1. Find
    const professor = await Professor.findById(id).select("-__v")

    if (!professor)
      return res.status(404).json({mensagem: PROFESSOR.NAO_ENCONTRADO})

    // 2. Modify
    if(email) professor.email = email
    if(senha) professor.senha = senha
    if(nome) professor.nome = nome

    // 3. Save
    await professor.save()

    professor.senha = undefined

    res.status(200).json({
      mensagem: PROFESSOR.ATUALIZADO_COM_SUCESSO,
      professor: professor
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)
    {
      if(error.keyValue.email)
        return res.status(409).json({mensagem: AUTH.EMAIL_EM_USO})

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

    if(error.name == NOME_DE_ERRO_GENERICO && error.message == VALIDACAO.GERAL.SENHA_INVALIDA)
    {
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO
      })
    }

    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.deleteProfessorById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: PROFESSOR.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: PROFESSOR.ID_FORNECIDO_INVALIDO})

    const professorDeletado = await Professor.findByIdAndDelete(id).select("-__v")

    if (!professorDeletado)
      return res.status(404).json({mensagem: PROFESSOR.NAO_ENCONTRADO})

    res.status(200).json({
      mensagem: PROFESSOR.DELETADO_COM_SUCESSO,
      professor: professorDeletado
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}
