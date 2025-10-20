const Turma = require("../../models/Turma.model")

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
