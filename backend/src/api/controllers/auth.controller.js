const bcrypt = require("bcrypt")

const Aluno = require("../../models/Aluno.model")
const Professor = require("../../models/Professor.model")

const codigoDeErroDeDuplicidade = 11000

exports.registraAluno = async (req, res) => {
  try
  {
    const email = req.body.email
    const senha = req.body.senha
    const nome = req.body.nome
    const turma = req.body.turma
    const ra = req.body.ra

    const senhaHasheada = await bcrypt.hash(senha, 10)

    const aluno = new Aluno({
      email: email,
      senha: senhaHasheada,
      nome: nome,
      turma: turma,
      ra: ra
    })

    const respostaDoMongo = await aluno.save()

    res.status(201).end()
  }
  catch(error)
  {
    if(error.code == codigoDeErroDeDuplicidade)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      if(error.keyValue.email)
      {
        return res.status(409).json({mensagem: "Esse endereço de email já está cadastrado"})
      }
      if(error.keyValue.ra)
      {
        return res.status(409).json({mensagem: "Esse RA já está cadastrado"})
      }

      return res.status(409).json({mensagem: "Um campo único já existe"});
    }

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
