const mongoose = require("mongoose")

const pastaSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, "O nome da pasta é obrigatório"],
    trim: true
  },
  pastaPai: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Pasta",
    default: null
  },
  criadorDaPasta: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Professor",
    required: [true, "A pasta precisa do professor que a criou"]
  }
})

folderSchema.index({ pastaPai: 1, nome: 1 }, { unique: true });

const Pasta = mongoose.model("Pasta", pastaSchema)

module.exports = Pasta
