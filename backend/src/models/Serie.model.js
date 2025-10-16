const mongoose = require("mongoose")

const serieSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, "O nome da série é obrigatório"],
    unique: true,
    trim: true
  }
})

const Serie = mongoose.model("Serie", serieSchema);

module.exports = Serie
