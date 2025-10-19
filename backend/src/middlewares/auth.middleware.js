const jwt = require("jsonwebtoken")

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization

  if(!authHeader) {
    return res.status(401).json({message: "Acesso negado. O token de autenticação não foi fornecido."});
  }

  const parts = authHeader.split(" ");
  if(parts.length !== 2 || parts[0] !== "Bearer") {
    return res.status(401).json({message: "Erro no formato do token. O formato esperado é \"Bearer <token>\"."});
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
    if(error.name == "TokenExpiredError") {
      return res.status(401).json({
        code: 'TOKEN_EXPIRED',
        message: 'Sua sessão expirou. Por favor, faça login novamente.'
      });
    }

    // O token é inválido
    if(error.name == "JsonWebTokenError") {
      return res.status(401).json({
        code: 'TOKEN_INVALID',
        message: 'Token de autenticação inválido.'
      });
    }

    // Algum outro erro inesperado
    return res.status(500).json({
      message: 'Ocorreu um erro interno ao validar o token.'
    });
  }
}

module.exports = authMiddleware
