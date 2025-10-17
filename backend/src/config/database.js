const mongoose = require('mongoose');
require('dotenv').config();

const conectaAoBancoDeDados = async () => {
  try
  {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("Conexão com o MongoDB estabelecida com sucesso!");
  }
  catch (error)
  {
    console.error("Falha ao conectar com o MongoDB:", error.message);
    process.exit(1); // Encerra a aplicação
  }
};

module.exports = conectaAoBancoDeDados;
