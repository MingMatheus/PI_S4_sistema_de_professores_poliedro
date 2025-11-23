const mongoose = require("mongoose")

const Aluno = require("../../models/Aluno.model")

const {
  ERRO,
  ALUNO,
  AUTH,
  VALIDACAO
} = require("../../constants/responseMessages.constants")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR,
  NOME_DE_ERRO_GENERICO
} = require("../../constants/error.constants")

exports.getAlunoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: ALUNO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: ALUNO.ID_FORNECIDO_INVALIDO})

    const aluno = await Aluno.findById(id)
      .select("-__v")
      .populate({
        path: "turma",
        select: "-__v",
        populate: {
          path: "serie",
          select: "-__v"
        }
      })

    if (!aluno)
      return res.status(404).json({mensagem: ALUNO.NAO_ENCONTRADO})

    res.status(200).json({
      mensagem: ALUNO.ENCONTRADO_COM_SUCESSO,
      aluno: aluno
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.getTodosAlunos = async (req, res) => {
  try
  {
    const alunos = await Aluno.find({})
      .select("-__v")
      .populate({
        path: "turma",
        select: "-__v",
        populate: {
          path: "serie",
          select: "-__v"
        }
      })

    res.status(200).json({
      mensagem: ALUNO.TODOS_ALUNOS_ENCONTRADOS,
      alunos: alunos
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}

exports.updateAlunoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: ALUNO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: ALUNO.ID_FORNECIDO_INVALIDO})

    const{email, senha, nome, turma, ra} = req.body

    // 1. Find
    const aluno = await Aluno.findById(id).select("-__v")

    if (!aluno)
      return res.status(404).json({mensagem: ALUNO.NAO_ENCONTRADO})

    // 2. Modify
    if(email) aluno.email = email
    if(senha) aluno.senha = senha
    if(nome) aluno.nome = nome
    if(turma) aluno.turma = turma
    if(ra) aluno.ra = ra

    // 3. Save
    await aluno.save()

    aluno.senha = undefined

    res.status(200).json({
      mensagem: ALUNO.ATUALIZADO_COM_SUCESSO,
      aluno: aluno
    })
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      if(error.keyValue.email)
        return res.status(409).json({mensagem: AUTH.EMAIL_EM_USO})

      if(error.keyValue.ra)
        return res.status(409).json({mensagem: AUTH.RA_EM_USO})

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

    // Trata o caso em que a senha enviada é inválida
    if(error.name == NOME_DE_ERRO_GENERICO && error.message == VALIDACAO.GERAL.SENHA_INVALIDA)
    {
      return res.status(400).json({
        mensagem: ERRO.VALIDACAO
      })
    }

    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR}) // código 500, internal server error
  }
}

exports.deleteAlunoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: ALUNO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: ALUNO.ID_FORNECIDO_INVALIDO})

    const alunoDeletado = await Aluno.findByIdAndDelete(id)
      .select("-__v")
      .populate({
        path: "turma",
        select: "-__v",
        populate: {
          path: "serie",
          select: "-__v"
        }
      })

    if (!alunoDeletado)
      return res.status(404).json({mensagem: ALUNO.NAO_ENCONTRADO})

    res.status(200).json({
      mensagem: ALUNO.DELETADO_COM_SUCESSO,
      aluno: alunoDeletado
    })
  }
  catch(error)
  {
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR})
  }
}
