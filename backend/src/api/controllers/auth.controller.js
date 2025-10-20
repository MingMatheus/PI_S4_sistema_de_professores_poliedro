const jwt = require("jsonwebtoken")
const bcrypt = require("bcrypt")

const Aluno = require("../../models/Aluno.model")
const Professor = require("../../models/Professor.model")

const {
  validaEmail,
  validaEmailProfessor
} = require("../../utils/validators.utils")

const {
  ROLES
} = require("../../constants/validation.constants")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

exports.cadastraAluno = async (req, res) => {
  try
  {
    const novoAluno = new Aluno(req.body)

    await novoAluno.save()

    res.status(201).json({mensagem: "Aluno criado com sucesso"})
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      if(error.keyValue.email)
        return res.status(409).json({mensagem: "Esse endereço de email já está cadastrado"})

      if(error.keyValue.ra)
        return res.status(409).json({mensagem: "Esse RA já está cadastrado"})

      return res.status(409).json({mensagem: "Um campo único já existe"});
    }

    if(error.name == MONGOOSE_VALIDATION_ERROR)  // código 400 significa bad request
    {
      const errorMessages = Object.values(error.errors).map(err => err.message);

      return res.status(400).json({
        mensagem: "Dados inválidos. Por favor, verifique os campos obrigatórios e formatos",
        erros: errorMessages
      })
    }

    return res.status(500).json({mensagem: "Ocorreu um erro no servidor, tente novamente mais tarde"}) // código 500, internal server error
  }
}

exports.cadastraProfessor = async (req, res) => {
  try
  {
    const professor = new Professor(req.body)

    await professor.save()

    res.status(201).json({mensagem: "Professor criado com sucesso"})
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      return res.status(409).json({mensagem: "Já existe um professor cadastrado com esse email"});
    }

    if(error.name == MONGOOSE_VALIDATION_ERROR)  // código 400 significa bad request
    {
      const errorMessages = Object.values(error.errors).map(err => err.message);

      return res.status(400).json({
        mensagem: "Dados inválidos. Por favor, verifique os campos obrigatórios e formatos",
        erros: errorMessages
      })
    }

    return res.status(500).json({mensagem: "Ocorreu um erro no servidor, tente novamente mais tarde"}) // código 500, internal server error
  }
}

exports.login = async (req, res) => {
  const email = req.body.email
  const senha = req.body.senha

  // Testa se o email enviado é um email válido
  if(!validaEmail(email))
    return res.status(400).json({mensagem: "Email inválido"})  // Status 400: Bad Request

  let usuario, role
  // Verifica se o email é de professor ou de aluno
  if(validaEmailProfessor(email))
  {
    usuario = await Professor.findOne({email: email}).select("+senha")
    role = ROLES.PROFESSOR
  }
  else
  {
    usuario = await Aluno.findOne({email: email}).select("+senha")
    role = ROLES.ALUNO
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

  res.status(200).json({mensagem: "Login realizado com sucesso", token: token})
}
