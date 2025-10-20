const checkRole = (rolesPermitidos) => {
  return (req, res, next) => {
    // As informações do payload do token não estavam no corpo da requisição
    if (!req.user) {
      return res.status(401).json({mensagem: "Acesso negado. Token não encontrado ou inválido."});
    }

    const userRole = req.user.role

    if(rolesPermitidos.includes(userRole))
    {
      next()
    }
    else
    {
      res.status(403).json({mensagem: "Acesso proibido. Você não tem a permissão necessária para este recurso."});
    }
  }
}

module.exports = checkRole
