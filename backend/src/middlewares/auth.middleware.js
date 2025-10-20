const jwt = require("jsonwebtoken")

const {
  JWT_EXPIRED_ERROR,
  JWT_INVALID_ERROR,
  API
} = require("../constants/error.constants")

const {
  AUTH,
  ERRO
} = require("../constants/responseMessages.constants")

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization

  if(!authHeader) {
    return res.status(401).json({mensagem: AUTH.TOKEN_NAO_FORNECIDO});
  }

  const parts = authHeader.split(" ");
  if(parts.length != 2 || parts[0].toLowerCase() != "bearer") {
    return res.status(401).json({mensagem: AUTH.TOKEN_MAL_FORMATADO});
  }
  const token = parts[1];

  try 
  {
    const decodedPayload = jwt.verify(token, process.env.JWT_SECRET)
    req.user = decodedPayload

    return next()
  }
  catch(error)
  {
    // O token está expirado
    if(error.name == JWT_EXPIRED_ERROR) {
      return res.status(401).json({
        code: API.TOKEN_EXPIRADO,
        mensagem: AUTH.TOKEN_EXPIROU
      });
    }

    // O token é inválido
    if(error.name == JWT_INVALID_ERROR) {
      return res.status(401).json({
        code: API.TOKEN_INVALIDO,
        mensagem: AUTH.TOKEN_INVALIDO
      });
    }

    // Algum outro erro inesperado
    return res.status(500).json({mensagem: ERRO.ERRO_INTERNO_NO_SERVIDOR});
  }
}

module.exports = authMiddleware
