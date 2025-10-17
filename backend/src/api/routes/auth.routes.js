const express = require("express")
const router = express.Router()

const authController = require("../controllers/auth.controller")

router.post("/cadastro/alunos", authController.cadastraAluno)

module.exports = router
