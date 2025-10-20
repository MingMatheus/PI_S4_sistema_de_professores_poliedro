const Turma = require("../../models/Turma.model")

const codigoDeErroDeDuplicidade = 11000

exports.cadastraTurma = async (req, res) => {
  try
  {
    const turma = new Turma(req.body)

    await turma.save()

    res.status(201).json({mensagem: "Turma cadastrada com sucesso"})
  }
  catch(error)
  {
    if(error.code == codigoDeErroDeDuplicidade)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
      return res.status(409).json({mensagem: "Já existe uma turma cadastrada com esse nome"});

    if(error.name == "ValidationError")  // código 400 significa bad request
    {
      return res.status(400).json({
        mensagem: "Dados inválidos. Por favor, verifique os campos obrigatórios e formatos",
        erros: error.errors
      })
    }

    return res.status(500).json({mensagem: "Ocorreu um erro no servidor, tente novamente mais tarde"}) // código 500, internal server error
  }
}
