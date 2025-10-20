const ERROR_CODES = {
  // Códigos de Erro do MongoDB
  MONGO_DUPLICATE_KEY: 11000,

  // Nomes de Erros do Mongoose
  MONGOOSE_VALIDATION_ERROR: 'ValidationError',
  
  // Nomes de Erros do JWT
  JWT_EXPIRED_ERROR: 'TokenExpiredError',
  JWT_INVALID_ERROR: 'JsonWebTokenError',
};

// Congela o objeto para torná-lo imutável
module.exports = Object.freeze(ERROR_CODES);
