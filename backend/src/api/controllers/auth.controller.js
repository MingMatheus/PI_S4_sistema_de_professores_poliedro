const jwt = require("jsonwebtoken")
const bcrypt = require("bcrypt")

const Aluno = require("../../models/Aluno.model")
const Professor = require("../../models/Professor.model")

const {
  validaEmailProfessor
} = require("../../utils/validators.utils")

const {
  ROLES
} = require("../../constants/validation.constants")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR,
  NOME_DE_ERRO_GENERICO
} = require("../../constants/error.constants")

const {
  AUTH,
  ERRO,
  VALIDACAO
} = require("../../constants/responseMessages.constants")

exports.cadastraAluno = async (req, res) => {
  try
  {
    const novoAluno = new Aluno(req.body)

    await novoAluno.save()

    res.status(201).json({mensagem: AUTH.ALUNO_CRIADO})
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

exports.cadastraProfessor = async (req, res) => {
  try
  {
    const professor = new Professor(req.body)

    await professor.save()

    res.status(201).json({mensagem: AUTH.PROFESSOR_CRIADO})
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      if(error.keyValue.email)
        return res.status(409).json({mensagem: AUTH.EMAIL_EM_USO});

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

exports.login = async (req, res) => {
  const email = req.body.email
  const senha = req.body.senha

  // Testa se o campo email ou o campo senha estão vazios
  if(!email || !senha)
    return res.status(400).json({mensagem: AUTH.CREDENCIAIS_INVALIDAS})  // Status 400: Bad Request

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
    return res.status(401).json({mensagem: AUTH.CREDENCIAIS_INVALIDAS})  // Status 401: Sem autorização

  const senhaEstaCerta = await bcrypt.compare(senha, usuario.senha)
  if(!senhaEstaCerta)
    return res.status(401).json({mensagem: AUTH.CREDENCIAIS_INVALIDAS})  // Status 401: Sem autorização

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

  res.status(200).json({mensagem: AUTH.LOGIN_FEITO, token: token})
}
