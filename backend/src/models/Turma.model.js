const mongoose = require("mongoose")

const turmaSchema = mongoose.Schema({
  nome: {
    type: String,
    required: [true, "O nome da turma é obrigatório"],
    unique: true,
    trim: true
  },
  serie: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Serie",
    default: null
  }
})

const Turma = mongoose.model("Turma", turmaSchema)

module.exports = Turma
