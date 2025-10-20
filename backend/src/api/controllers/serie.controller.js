const Serie = require("../../models/Serie.model")

const {
  MONGO_DUPLICATE_KEY,
  MONGOOSE_VALIDATION_ERROR
} = require("../../constants/error.constants")

exports.cadastraSerie = async (req, res) => {
  try
  {
    const serie = new Serie(req.body)

    await serie.save()

    res.status(201).json({mensagem: "Serie cadastrada com sucesso"})
  }
  catch(error)
  {
    if(error.code == MONGO_DUPLICATE_KEY)  // Retorna um código 409, que indica conflito (de unicidade nesse caso)
    {
      if(error.keyValue.nome)
        return res.status(409).json({mensagem: "Já existe uma série cadastrada com esse nome"})

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
