const express = require("express")
const router = express.Router()

const turmaController = require("../controllers/turma.controller")

router.post("/", turmaController.cadastraTurma)

module.exports = router
