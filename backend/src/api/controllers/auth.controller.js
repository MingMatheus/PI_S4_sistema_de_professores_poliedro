const bcrypt = require("bcrypt")
const jwt = require("jsonwebtoken")

const Aluno = require("../../models/Aluno.model")
const Professor = require("../../models/Professor.model")

const tamanhoMinimoDaSenha = 8
const codigoDeErroDeDuplicidade = 11000
const regexEmailValido = /^\S+@\S+\.\S+$/
const regexEmailDeProfessor = /.*@sistemapoliedro.com.br$/

exports.cadastraAluno = async (req, res) => {
  try
  {
    const email = req.body.email

    if(regexEmailDeProfessor.test(email)) return res.status(400).json({mensagem: "Não é possível cadastrar um aluno com um email de professor"})  // Status 400: Bad Request

    const senha = req.body.senha

    if(senha.length < tamanhoMinimoDaSenha) return res.status(400).json({mensagem: `A senha deve ter no minímo ${tamanhoMinimoDaSenha} dígitos`})  // Status 400: Bad Request

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

    await aluno.save()

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

exports.cadastraProfessor = async (req, res) => {
  try
  {
    const email = req.body.email

    if(!regexEmailDeProfessor.test(email)) return res.status(400).json({mensagem: "O email fornecido não é um email de professor"})  // Status 400: Bad Request

    const senha = req.body.senha

    if(senha.length < tamanhoMinimoDaSenha) return res.status(400).json({mensagem: `A senha deve ter no minímo ${tamanhoMinimoDaSenha} dígitos`})  // Status 400: Bad Request

    const nome = req.body.nome

    const senhaHasheada = await bcrypt.hash(senha, 10)

    const professor = new Professor({
      email: email,
      senha: senhaHasheada,
      nome: nome
    })

    await professor.save()

    res.status(201).end()
  }
  catch(error)
  {
    if(error.code == codigoDeErroDeDuplicidade)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      return res.status(409).json({mensagem: "Já existe um professor cadastrado com esse email"});
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

exports.login = async (req, res) => {
  const email = req.body.email
  const senha = req.body.senha

  // Testa se o email enviado é um email válido
  if(!regexEmailValido.test(email))
    return res.status(400).json({mensagem: "Email inválido"})  // Status 400: Bad Request

  let usuario, role
  // Verifica se o email é de professor ou de aluno
  if(regexEmailDeProfessor.test(email))
  {
    usuario = await Professor.findOne({email: email}).select("+senha")
    role = "professor"
  }
  else
  {
    usuario = await Aluno.findOne({email: email}).select("+senha")
    role = "aluno"
  }

  if(!usuario)
    return res.status(401).json({mensagem: "credenciais inválidas"})  // Status 401: Sem autorização

  const senhaEstaCerta = await bcrypt.compare(senha, usuario.senha)
  if(!senhaEstaCerta)
    return res.status(401).json({mensagem: "credenciais inválidas"})  // Status 401: Sem autorização

  const payload = {
    sub: usuario._id,   // sub significa subject ou sujeito, esse campo representa de qual usuario é esse token, guardando o id dele
    nome: usuario.nome,
    role: role
  }

  const token = jwt.sign(
    payload,
    process.env.JWT_SECRET,
    {expiresIn: "1h"}
  )

  res.status(200).json({token: token})
}
