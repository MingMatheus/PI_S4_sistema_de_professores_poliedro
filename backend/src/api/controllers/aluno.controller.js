const mongoose = require("mongoose")

const Aluno = require("../../models/Aluno.model")

const {
  ERRO,
  ALUNO
} = require("../../constants/responseMessages.constants")

exports.getAlunoById = async (req, res) => {
  try
  {
    const {id} = req.params

    if(!id)
      return res.status(400).json({mensagem: ALUNO.ID_NAO_FORNECIDO})

    if(!mongoose.Types.ObjectId.isValid(id))
      return res.status(400).json({mensagem: ALUNO.ID_FORNECIDO_INVALIDO})

    const aluno = await Aluno.findById(id).select("-__v")

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
  try {
    const alunos = await Aluno.find()
    return res.status(200).json({
      mensagem: ALUNO.TODOS_ALUNOS_ENCONTRADOS,
      data: alunos,
      sucesso: true
    })
  } catch (error) {
    return res.status(500).json({
      mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR,
      data: null,
      sucesso: false
    })
  }
}

exports.updateAlunoById = async (req, res) => {
  try {
    const aluno = await Aluno.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    })
    if (!aluno) {
      return res.status(404).json({
        mensagem: ALUNO.NAO_ENCONTRADO,
        data: null,
        sucesso: false
      })
    }
    return res.status(200).json({
      mensagem: ALUNO.ATUALIZADO_COM_SUCESSO,
      data: aluno,
      sucesso: true
    })
  } catch (error) {
    return res.status(500).json({
      mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR,
      data: null,
      sucesso: false
    })
  }
}

exports.deleteAlunoById = async (req, res) => {
  try {
    const aluno = await Aluno.findByIdAndDelete(req.params.id)
    if (!aluno) {
      return res.status(404).json({
        mensagem: ALUNO.NAO_ENCONTRADO,
        data: null,
        sucesso: false
      })
    }
    return res.status(200).json({
      mensagem: ALUNO.DELETADO_COM_SUCESSO,
      data: null,
      sucesso: true
    })
  } catch (error) {
    return res.status(500).json({
      mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR,
      data: null,
      sucesso: false
    })
  }
}
